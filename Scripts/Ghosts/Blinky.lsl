float grid_unit = 2.0;
float speed = 1.0; 
integer isGhostOutside = TRUE;

vector currentDirection = <-0.5, 0, 0>;
vector initialPosition = <128.0, 134.0, 21.5>;

integer canMove = FALSE;
float slowDuration = 0.0;

float NORMAL_SPEED = 1.0;
float SLOW_SPEED = 0.2;

key pacmanKey;

float snap(float val) 
{
    return (float)llRound(val / grid_unit) * grid_unit;
}

integer isPathClear(vector pos, vector dir) 
{
    vector startPoint = pos + (llVecNorm(dir) * 0.6);
    vector endPosition = startPoint + (llVecNorm(dir) * 1.2);
   
    list raycast = llCastRay(startPoint, endPosition, [
        RC_REJECT_TYPES, RC_REJECT_AGENTS | RC_REJECT_LAND,
        RC_DATA_FLAGS, RC_GET_ROOT_KEY
    ]);

    integer result = llList2Integer(raycast, -1);
    
    if (result > 0)
    {
        key hitKey = llList2Key(raycast, 0);
        string hitName = llKey2Name(hitKey);
        
        if (hitName == "Pacman") 
        {
            return TRUE;
        }
        else if (hitName == "GhostGate")
        {
            if(isGhostOutside == TRUE)
                return FALSE;
            else
            {
                isGhostOutside = TRUE;
                return TRUE;
            }
                
        }
        return FALSE;
    }

    return TRUE;
}


UpdateGhostSprite()
{
    float frame = 0.0;
    
    if(currentDirection.x > 0)      frame = 0.0; 
    else if(currentDirection.x < 0) frame = 1.0; 
    else if(currentDirection.y > 0) frame = 2.0;
    else if(currentDirection.y < 0) frame = 3.0;
    
    llSetTextureAnim(ANIM_ON, 0, 4, 1, frame, 1.0, 0.0);
}

ResetGhost()
{
    canMove = FALSE;
    llSetRegionPos(initialPosition); 
    slowDuration = 0.0;
    speed = NORMAL_SPEED; 
    currentDirection = <-0.5, 0, 0>;
    llSetColor(<1, 1, 1>, ALL_SIDES);
    UpdateGhostSprite();
            
    llOwnerSay("Ghost returned to base.");
}

/*vector chooseRandomDirection(vector pos) 
{
    list testDirs = [<speed,0,0>, <-speed,0,0>, <0,speed,0>, <0,-speed,0>];
    list available = [];
    integer i;
    
    for (i = 0; i < 4; i++) 
    {
        vector d = llList2Vector(testDirs, i);
        if (isPathClear(pos, d)) 
        {
            if (d != -currentDirection) 
            {
                available += [d];
            }
        }
    }

    integer count = llGetListLength(available);
    if (count == 0) 
        return -currentDirection;

    integer r = (integer)llFrand(count);
    return llList2Vector(available, r);
}*/

vector chooseBlinkyDirection(vector pos)
{
    vector pacmanPosition = pos; 
    list details = llGetObjectDetails(pacmanKey, [OBJECT_POS]);
    
    if (llGetListLength(details) > 0) 
        pacmanPosition = llList2Vector(details, 0);

    list testDirs = [<speed,0,0>, <-speed,0,0>, <0,speed,0>, <0,-speed,0>];
    list available = [];
    integer i;
    
    for (i = 0; i < 4; i++) 
    {
        vector d = llList2Vector(testDirs, i);
        if (isPathClear(pos, d)) 
        {
            if (d != -currentDirection) 
                available += [d];
        }
    }

    integer count = llGetListLength(available);
    if (count == 0) return -currentDirection;

    vector bestDir = llList2Vector(available, 0);
    float minDistance = 9999.0;

    for (i = 0; i < count; i++) 
    {
        vector d = llList2Vector(available, i);
        float dist = llVecDist(pos + d, pacmanPosition);
        if (dist < minDistance) 
        {
            minDistance = dist;
            bestDir = d;
        }
    }
    return bestDir;    
}

default 
{
    state_entry() 
    {
        llSensorRepeat("Pacman", NULL_KEY, PASSIVE | SCRIPTED, 96.0, PI, 2.0);
        llListen(-100, "", NULL_KEY, "");
        llListen(777, "", NULL_KEY, "");
        llSetRot(llEuler2Rot(<0,0,0>)); 
        UpdateGhostSprite();
        llSetTimerEvent(0.1);
    }
    
    sensor(integer num) 
    {
        pacmanKey = llDetectedKey(0); 
    }
    
    no_sensor()
    {
        pacmanKey = NULL_KEY;
    }

    timer() 
    {
        if(!canMove) return;
        
        if (slowDuration > 0) 
        {
            slowDuration -= 0.1;
            if (slowDuration <= 0) 
            {
                speed = NORMAL_SPEED;
                currentDirection = llVecNorm(currentDirection) * speed;
                llSetColor(<1, 1, 1>, ALL_SIDES);
                llOwnerSay("Ghost effect expired: Normal speed restored.");
                UpdateGhostSprite();
            }
        }
        
        
        vector pos = llGetPos();
        integer aheadClear = isPathClear(pos, currentDirection);
        
        float distX = llFabs(pos.x - snap(pos.x));
        float distY = llFabs(pos.y - snap(pos.y));

        if ((distX < 0.25 && distY < 0.25) || !aheadClear) 
        {
            vector nextDir = chooseBlinkyDirection(pos);
            
            if (nextDir != currentDirection) 
            {
                currentDirection = nextDir;
                
                pos.x = snap(pos.x); 
                pos.y = snap(pos.y);
                llSetRegionPos(pos);
                
                UpdateGhostSprite();
            }
        }

        if (isPathClear(pos, currentDirection)) 
        {
            llSetRegionPos(pos + currentDirection);
        } 
        else 
        {
            currentDirection = chooseBlinkyDirection(pos);
            UpdateGhostSprite();
        }
    }
    
    link_message(integer sender_num, integer num, string str, key id)
    {
       
        vector pos = llGetPos();

        if (str == "SLOW_ON")
        {
            speed = SLOW_SPEED;
            currentDirection = llVecNorm(currentDirection) * speed;
            
            slowDuration = 5.0;
            
            llSetColor(<0, 0, 1>, ALL_SIDES);
            llOwnerSay("Ghost effect: SLOWED");
        }
    }
    
    listen(integer channel, string name, key id, string msg)
    {
        if (channel == -100)
        {
            if (msg == "START_GAME")
            {
                canMove = TRUE;
                llOwnerSay("Ghost Activated!");
            }
            else if (msg == "STOP_GAME")
            {
                llOwnerSay("RESET");
                ResetGhost();
            }
        }
    
        // PLAYER COMMANDS
        else if (channel == 777)
        {
            list parts = llParseString2List(msg, [";"], []);
    
            string cmdData = llList2String(parts, 0);
    
            list kv = llParseString2List(cmdData, ["="], []);
    
            string cmd = llList2String(kv, 1);
    
            if (msg == "SLOW")
            {
                speed = SLOW_SPEED;
    
                currentDirection =
                    llVecNorm(currentDirection) * speed;
    
                slowDuration = 5.0;
    
                llSetColor(<0,0,1>, ALL_SIDES);
    
                llOwnerSay("Ghost effect: SLOWED");
            }
        }
    }
}