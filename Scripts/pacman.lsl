// Μεταβλητές Grid
float grid_unit = 2.0; 
vector nextDirection = <0.5, 0.0, 0.0>;
vector currentDirection = <0.5, 0.0, 0.0>; 
float speed = 0.5;
float pacmanRadius = 2.0; 

integer controls_to_track;
integer canMove = FALSE;

float snap(float val) {
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
    
    integer status = llList2Integer(raycast, -1);
    
    if (status > 0)
    {
        key hitKey = llList2Key(raycast, 0);
        list details = llGetObjectDetails(hitKey, [OBJECT_NAME]);
        string hitName = llList2String(details, 0);
        
        if (hitName == "PowerPellet") 
        {
            llRegionSayTo(hitKey, -500, "EATEN");    
            return TRUE;
        }
        
        return FALSE; 
    }
    
    return TRUE;
}

default
{
    state_entry()
    {
        llSetRot(llEuler2Rot(<0, 0, 0> * DEG_TO_RAD));
    }
    
    touch_start(integer num)
    {
        key user = llDetectedKey(0);
        llRequestPermissions(user, PERMISSION_TAKE_CONTROLS);
        llShout(-100, "START_GAME");
    }
    
    on_rez(integer num)
    {
        llListen(-99, "", NULL_KEY, "DIE_PACMAN");
        llSetTexture("PacmanAnim", 0);
        llSetTextureAnim(ANIM_ON | LOOP, 0, 2, 1, 0.0, 2.0, 5.0);
    }

    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_TAKE_CONTROLS)
        {
            controls_to_track = CONTROL_FWD | CONTROL_BACK | CONTROL_LEFT | CONTROL_RIGHT | CONTROL_ROT_LEFT | CONTROL_ROT_RIGHT;
            llTakeControls(controls_to_track, TRUE, FALSE);
            canMove = TRUE;
            llSetTimerEvent(0.1); 
        }
    }

    control(key id, integer level, integer edge)
    {
        if(canMove)
        {
            if (level & (CONTROL_LEFT | CONTROL_ROT_LEFT))      
                nextDirection = <-speed, 0.0, 0.0>; 
            else if (level & (CONTROL_RIGHT | CONTROL_ROT_RIGHT)) 
                nextDirection = <speed, 0.0, 0.0>;  
            else if (level & CONTROL_FWD)                        
                nextDirection = <0.0, speed, 0.0>;  
            else if (level & CONTROL_BACK)                       
                nextDirection = <0.0, -speed, 0.0>;
        }
    }

   timer()
    {
        if(!canMove) return;

        vector pos = llGetPos();
        integer aheadClear = isPathClear(pos, currentDirection);
        
        float distX = llFabs(pos.x - snap(pos.x));
        float distY = llFabs(pos.y - snap(pos.y));

        if((distX < 0.25 && distY < 0.25) || !aheadClear) 
        {
            if(isPathClear(pos, nextDirection)) 
            {
                if(currentDirection != nextDirection)
                {
                    currentDirection = nextDirection;
                    
                    pos.x = snap(pos.x);
                    pos.y = snap(pos.y);
                    llSetRegionPos(pos); 
                    
                    float angle = llAtan2(currentDirection.y, currentDirection.x);
                    llSetRot(llEuler2Rot(<0, 0, angle>));
                }
            }
        }

        if(isPathClear(pos, currentDirection))
        {
            llSetRegionPos(pos + currentDirection);
        }
    }
    
    listen(integer channel, string name, key id, string msg)
    {
        if (msg == "DIE_PACMAN") 
        {
            llShout(-100, "STOP_GAME");
            llRegionSay(-98, "END_GAME");
            llDie(); 
        }
    }
}