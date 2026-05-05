float grid_unit = 2.0;
float speed = 0.5; 
vector currentDirection = <0.5, 0, 0>;
integer canMove = TRUE;

float snap(float val) 
{
    return (float)llRound(val / grid_unit) * grid_unit;
}

// Έλεγχος για τοίχους
integer isPathClear(vector pos, vector dir) 
{
    vector startPoint = pos + (llVecNorm(dir) * 0.6);
    vector endPosition = startPoint + (llVecNorm(dir) * 1.2);
    list raycast = llCastRay(startPoint, endPosition, [RC_REJECT_TYPES, RC_REJECT_AGENTS | RC_REJECT_LAND]);
    return (llList2Integer(raycast, -1) == 0);
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

default 
{
    state_entry() 
    {
        llSetRot(llEuler2Rot(<0,0,0>)); 
        UpdateGhostSprite();
        llSetTimerEvent(0.1);
    }

    timer() 
    {
        if(!canMove) return;
        
        vector pos = llGetPos();
        integer aheadClear = isPathClear(pos, currentDirection);
        
        float distX = llFabs(pos.x - snap(pos.x));
        float distY = llFabs(pos.y - snap(pos.y));

        if ((distX < 0.25 && distY < 0.25) || !aheadClear) 
        {
            vector nextDir = chooseRandomDirection(pos);
            
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
            currentDirection = chooseRandomDirection(pos);
            UpdateGhostSprite();
        }
    }
}