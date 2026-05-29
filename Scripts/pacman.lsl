float grid_unit = 2.0; 
vector nextDirection = <0.5, 0.0, 0.0>;
vector currentDirection = <0.5, 0.0, 0.0>; 
float speed = 0.5;
float pacmanRadius = 2.0; 

integer lifes = 3;

integer controls_to_track;
integer canMove = FALSE;
integer isEaten = FALSE;

integer isCamouflaged = FALSE;
float camouflageDuration;

float MIN_X = 96.0;
float MAX_X = 160.0;
float MIN_Y = 108.0;
float MAX_Y = 152.0;

float snap(float val) {
    return (float)llRound(val / grid_unit) * grid_unit;
}

ApplyCamouflage(float time)
{
    isCamouflaged = TRUE;
    camouflageDuration = time;
    llSetObjectName("YellowGhost");
    llSetRot(llEuler2Rot(<0,0,0>));
    UpdateCamouflageSprite();
    llOwnerSay("Camouflage Activated!");
}

ResetCamouflage()
{
    isCamouflaged = FALSE;
    camouflageDuration = 0.0;
    llSetObjectName("Pacman");
    llSetTextureAnim(FALSE, 0,0,0,0,0,0);
    llSetTexture("PacmanAnim", ALL_SIDES);
    
    llScaleTexture(1.0, 1.0, ALL_SIDES);
    llOffsetTexture(0.0, 0.0, ALL_SIDES);
    
    llSetTextureAnim(ANIM_ON | LOOP, 0, 2, 1, 0.0, 2.0, 5.0);
    
    float angle = llAtan2(currentDirection.y, currentDirection.x);
    llSetRot(llEuler2Rot(<0, 0, angle>));

    llOwnerSay("Camouflage Ended!");
}

UpdateCamouflageSprite()
{
    if(!isCamouflaged)
        return;

    
    vector visualDirection = currentDirection;
    if(isCamouflaged)
    {
        visualDirection = nextDirection;
    }

    float frame = 0.0;

    if (currentDirection.x > 0)
        frame = 0.0;
    else if (currentDirection.x < 0)
        frame = 1.0;
    else if (currentDirection.y > 0)
        frame = 2.0;
    else if (currentDirection.y < 0)
        frame = 3.0;

    llSetTextureAnim(FALSE, 0,0,0,0,0,0);
    llSetTexture("YellowGhost", ALL_SIDES);
    
    llScaleTexture(0.25, 1.0, ALL_SIDES);
    llOffsetTexture(-0.125, 0.0, ALL_SIDES);
    
    llSetTextureAnim(ANIM_ON, ALL_SIDES, 4, 1, frame, frame, 0.0);
}

integer isPathClear(vector pos, vector dir) 
{
    vector nextPos = pos + dir;
    if (nextPos.x < MIN_X || nextPos.x > MAX_X || nextPos.y < MIN_Y || nextPos.y > MAX_Y)
    {
        return FALSE; 
    }

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
        
        if (hitName == "PowerPellet" || hitName == "Pellet" || hitName == "PowerUp") 
        {
            llRegionSayTo(hitKey, -500, "EATEN");    
            return TRUE;
        }
        
        return FALSE; 
    }
    
    return TRUE;
}

ResetPacman()
{
    llSetRegionPos(<128.0, 110.0, 21.5>);
    canMove = FALSE;
    speed = 0.5;
    currentDirection = <speed, 0.0, 0.0>; 
    nextDirection = <speed, 0.0, 0.0>;   
    ResetCamouflage();
    llSetRot(llEuler2Rot(<0, 0, 0> * DEG_TO_RAD)); 
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
        isEaten = FALSE;
    }
    
    on_rez(integer num)
    {
        llListen(-99, "", NULL_KEY, "");
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

        if ((distX < 0.25 && distY < 0.25) || !aheadClear) 
        {
            if (isPathClear(pos, nextDirection)) 
            {
                if (currentDirection != nextDirection)
                {
                    currentDirection = nextDirection;
                    
                    pos.x = snap(pos.x);
                    pos.y = snap(pos.y);
                    llSetRegionPos(pos); 
                    
                    if(isCamouflaged)
                    {
                        UpdateCamouflageSprite();
                    }
                    else
                    {
                        float angle = llAtan2(currentDirection.y, currentDirection.x);
                        llSetRot(llEuler2Rot(<0, 0, angle>));
                    }
                }
            }
        }
        
        if (camouflageDuration > 0.0)
        {
            camouflageDuration -= 0.1;
        
            if (camouflageDuration <= 0.0)
            {
                ResetCamouflage();
            }
        }

        if (isPathClear(pos, currentDirection))
        {
            llSetRegionPos(pos + currentDirection);
        }
    }
    
    listen(integer channel, string name, key id, string msg)
    {
        if (msg == "DIE_PACMAN") 
        {
            if(isEaten)
                    return;
                    
            isEaten = TRUE;
            llOwnerSay("Pacman lost a life");
            lifes--;
            ResetPacman();
            llShout(-100, "STOP_GAME");
            if(lifes < 1)
            {
                llRegionSay(-98, "END_GAME");
                llRegionSay(-500, "RESET"); 
                llDie();    
            }
        }
        else if(msg == "EXIT_MAZE")
        {
            llOwnerSay("Should exit maze");
            llShout(-100, "STOP_GAME");
            llRegionSay(-98, "END_GAME");
            llRegionSay(-500, "RESET"); 
            llDie();
        }
        else if(msg == "CAMOUFLAGE")
        {
            ApplyCamouflage(10.0);
        }
    }
}
