float grid_unit = 2.0;
float speed = 1.0; 

integer isGhostOutside = FALSE;
integer isScatterMode = TRUE;

integer isFrightened = FALSE;
integer isEaten = FALSE; 

vector currentDirection = <0, -0, 0>;
vector initialPosition = <128.0, 130.0, 21.5>;
vector outOfMazePosition = <128.0, 134.0, 21.5>;
vector pinkyHomeCorner = <108.0, 148.0, 21.5>;

integer canMove = FALSE;
float slowDuration = 0.0;

float NORMAL_SPEED = 1.0;
float SLOW_SPEED = 0.2;
float FRIGHTENED_SPEED = 0.5;

key pacmanKey;

list ghostNames = ["Blinky", "Pinky", "Inky", "Clyde"];

integer checkName(string name)
{
    return llListFindList(ghostNames, [name]);
}

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
        
        if (checkName(hitName) != -1 || hitName == "PowerPellet") 
        {
            return TRUE;
        }
        else if (hitName == "Pacman")
        {
            if(isFrightened && !isEaten)
            {
                isEaten = TRUE;
                isFrightened = FALSE; 
                isGhostOutside = TRUE; 
                speed = 1.0;
                currentDirection = llVecNorm(currentDirection) * speed;
                
                llOwnerSay("Pinky is EATEN! Returning to ghost house...");
                UpdateGhostSprite();
            }
            else if(!isFrightened && !isEaten)
            {
                llRegionSay(-99, "DIE_PACMAN");
            }
            return TRUE;
        }
        else if (hitName == "GhostGate")
        {
            if(isEaten) 
                return TRUE;
                
            if(isGhostOutside == TRUE)
                return FALSE;
            else
            {
                llSetRegionPos(outOfMazePosition);
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
    
    if (isEaten)
    {
        llSetTextureAnim(FALSE, 0, 0, 0, 0.0, 0.0, 0.0);
        llSetTexture("EatenGhost", ALL_SIDES);
        llSetTextureAnim(0, 0, 4, 1, frame, 1.0, 0.0); 
    }
    else if (isFrightened)
    {
        llSetTextureAnim(FALSE, 0, 0, 0, 0.0, 0.0, 0.0);
        llSetTexture("FrightenedGhost", ALL_SIDES);
    }
    else
    {
        llSetTexture("PinkGhost", ALL_SIDES);
        llSetTextureAnim(ANIM_ON, 0, 4, 1, frame, 1.0, 0.0);
    }
}

ResetGhost()
{
    canMove = FALSE;             
    isGhostOutside = FALSE; 
    isScatterMode = TRUE;
    isFrightened = FALSE;
    isEaten = FALSE;
    speed = NORMAL_SPEED;
    slowDuration = 0.0;           
    
    currentDirection = <0, 0.5, 0>; 
    llSetRegionPos(initialPosition);
    llSetColor(<1, 1, 1>, ALL_SIDES);
    
    UpdateGhostSprite();
}

vector chooseRandomDirection(vector pos) 
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
}

vector choosePinkyDirection(vector pos)
{
    vector targetPosition = pos; 
    list details = llGetObjectDetails(pacmanKey, [OBJECT_POS, OBJECT_ROT]);
    
    if (isEaten)
    {
        targetPosition = initialPosition;
    }
    else if (llGetListLength(details) > 1) 
    {
        if(isScatterMode)
            targetPosition = pinkyHomeCorner;
        else
        {
            vector pacmanPosition = llList2Vector(details, 0);
            rotation pacmanRotation = llList2Rot(details, 1);
    
            vector pacmanDirection = llRot2Fwd(pacmanRotation); 
        
            targetPosition = pacmanPosition + (pacmanDirection * 8.0);
        }
    }

    list testDirections = [<speed,0,0>, <-speed,0,0>, <0,speed,0>, <0,-speed,0>];
    list available = [];
    integer i;
    
    for (i = 0; i < 4; i++) 
    {
        vector d = llList2Vector(testDirections, i);
        if (isPathClear(pos, d)) 
        {
            if (d != -currentDirection) 
                available += [d];
        }
    }

    integer count = llGetListLength(available);
    if (count == 0) 
        return -currentDirection;

    vector bestDirection = llList2Vector(available, 0);
    float minDistance = 9999.0;

    for (i = 0; i < count; i++) 
    {
        vector d = llList2Vector(available, i);
        float dist = llVecDist(pos + d, targetPosition);
        if (dist < minDistance) 
        {
            minDistance = dist;
            bestDirection = d;
        }
    }
    return bestDirection;    
}

default 
{
    state_entry() 
    {
        llSensorRepeat("Pacman", NULL_KEY, PASSIVE | SCRIPTED, 96.0, PI, 2.0);
        llListen(-100, "", NULL_KEY, "");
        llListen(-200, "", NULL_KEY, "");
        llListen(-300, "", NULL_KEY, "");
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
            vector nextDir;
            if (isEaten)
                nextDir = choosePinkyDirection(pos);
            else if(isGhostOutside && !isFrightened)
                nextDir = choosePinkyDirection(pos);
            else
                nextDir = chooseRandomDirection(pos);
            
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
            if(isGhostOutside)
                currentDirection = choosePinkyDirection(pos);
            else
                currentDirection = chooseRandomDirection(pos);
            UpdateGhostSprite();
        }

        if (isEaten && llVecDist(llGetPos(), initialPosition) < 0.6)
        {
            isEaten = FALSE;
            isFrightened = FALSE;
            isGhostOutside = FALSE; 
            speed = NORMAL_SPEED;
            
            currentDirection = llVecNorm(currentDirection) * speed;
            
            llSetTextureAnim(FALSE, 0, 0, 0, 0.0, 0.0, 0.0);
            llSetTexture("PinkGhost", ALL_SIDES);
            
            llOwnerSay("Inside Ghost House. Respawning Pinky...");
            UpdateGhostSprite();
        }
    }
    
    link_message(integer sender_num, integer num, string str, key id)
    {
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
                ResetGhost();
            }
        }
        else if (channel == -200 && !isEaten) 
        {
            if (msg == "SCATTER_MODE" && isScatterMode == FALSE)
            {
                isScatterMode = TRUE;
                currentDirection = -currentDirection;
                UpdateGhostSprite();
                llOwnerSay("Ghost: Entering Scatter");
            }
            else if (msg == "CHASE_MODE" && isScatterMode == TRUE)
            {
                isScatterMode = FALSE;
                currentDirection = -currentDirection;
                UpdateGhostSprite();
                llOwnerSay("Ghost: Entering Chase");
            }
        }
        else if (channel == -300)
        {
            if (msg == "GHOST_FRIGHT")
            {
                if(isEaten || !isGhostOutside) return;
                
                llOwnerSay("BUU");
                isFrightened = TRUE;    
                speed = FRIGHTENED_SPEED;
                
                currentDirection = llVecNorm(currentDirection) * speed;
                currentDirection = -currentDirection;
                
                UpdateGhostSprite();
            }
            else if (msg == "GHOST_FRIGHT_STOP")
            {
                if (isEaten || !isGhostOutside) 
                {
                    isFrightened = FALSE;
                    return;
                }
                
                isFrightened = FALSE;
                speed = NORMAL_SPEED;
                currentDirection = llVecNorm(currentDirection) * speed;
                
                llSetTextureAnim(FALSE, 0, 0, 0, 0.0, 0.0, 0.0);
                llSetTexture("PinkGhost", ALL_SIDES);
                
                UpdateGhostSprite();
                llOwnerSay("Normal Mode Restored");
            }
        }
        else if (channel == 777 && canMove)
        {
            if (msg == "SLOW")
            {
                speed = SLOW_SPEED;
                currentDirection = llVecNorm(currentDirection) * speed;
                slowDuration = 5.0;
                llSetColor(<0,0,1>, ALL_SIDES);
            }
        }
    }
}