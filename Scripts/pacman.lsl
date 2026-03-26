vector currentDirection = <0.5, 0.0, 0.0>; 
float speed = 0.5;
float pacmanRadius = llGetScale().x * 1.2;                   
integer controls_to_track;
integer canMove = FALSE;

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
        canMove = TRUE;
    }
    
    on_rez(integer num)
    {
        llListen(-99, "", NULL_KEY, "DIE_PACMAN");
        
        llSetTexture("PacmanAnim", 0);
        llSetTextureAnim(
            ANIM_ON | LOOP,
            0,             
            2, 1,           
            0.0, 2.0,       
            5.0             
        );
    }

    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_TAKE_CONTROLS)
        {
            controls_to_track = CONTROL_FWD | CONTROL_BACK | CONTROL_LEFT | CONTROL_RIGHT | CONTROL_ROT_LEFT | CONTROL_ROT_RIGHT;
            
            llTakeControls(controls_to_track, TRUE, FALSE);
            llSetTimerEvent(0.1); 
        }
    }

    control(key id, integer level, integer edge)
    {
        if(canMove)
        {
            if (level & (CONTROL_LEFT | CONTROL_ROT_LEFT))  
            {
                currentDirection = <-speed, 0.0, 0.0>; 
                llSetRot(llEuler2Rot(<0, 0, 180> * DEG_TO_RAD)); 
            }
            else if (level & (CONTROL_RIGHT | CONTROL_ROT_RIGHT)) 
            {
                currentDirection = <speed, 0.0, 0.0>;  
                llSetRot(llEuler2Rot(<0, 0, 0> * DEG_TO_RAD));   
            }
            else if (level & CONTROL_FWD)
            {
                currentDirection = <0.0, speed, 0.0>;  
                llSetRot(llEuler2Rot(<0, 0, 90> * DEG_TO_RAD));
            }
            else if (level & CONTROL_BACK)
            {
                currentDirection = <0.0, -speed, 0.0>; 
                llSetRot(llEuler2Rot(<0, 0, 270> * DEG_TO_RAD));
            }
        }
        
    }

    timer()
    {
        vector currentPosition = llGetPos();
        vector endPosition = currentPosition + (currentDirection * pacmanRadius);
        
        list raycast = llCastRay(currentPosition, endPosition, [RC_REJECT_TYPES, RC_REJECT_AGENTS]);
        integer status = llList2Integer(raycast, -1);
        
        if(status <= 0)
        {
            vector nextPos = llGetPos() + currentDirection;
            llSetPos(nextPos);
        }

    }
    
    listen(integer channel, string name, key id, string msg)
    {
            if (msg == "DIE_PACMAN")
        {
            llDie(); 
        }
    }
}