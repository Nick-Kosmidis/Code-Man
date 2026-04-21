vector currentDirection = <-1, 0, 0>;
float speed = 0.5;
float lookAhead = 1.5; 
float ghostRadius = llGetScale().x; 
integer bShouldMove = FALSE;
integer GHOST_PIN = 12345; 

UpdateGhostSprite()
{
    float frame = 0.0;
    if(currentDirection == <1, 0, 0>)       frame = 0.0; 
    else if(currentDirection == <-1, 0, 0>)  frame = 1.0; 
    else if(currentDirection == <0, 1, 0>)   frame = 2.0; 
    else if(currentDirection == <0, -1, 0>)  frame = 3.0; 
    
    llSetTextureAnim(ANIM_ON, 0, 4, 1, frame, 1.0, 0.0);
}

vector GenerateRandomDirection()
{
    integer rand = (integer)llFrand(4);
    if(rand == 0) return <1, 0, 0>;
    if(rand == 1) return <-1, 0, 0>;
    if(rand == 2) return <0, 1, 0>;
    return <0, -1, 0>;
}

integer IsSafeToMove(vector position)
{
    if (position.y >= 111.0 && position.y <= 144) 
    {
        if ((position.y <= 124.0) || (position.y >= 134.0))
        {
            if (position.x >= 108.5 && position.x <= 140) 
                return TRUE;
        }
        else 
        {
            if (position.x >= 116 && position.x <= 137.5) 
                return TRUE;
        }
    }
    return FALSE;
}

default
{
    state_entry()
    {
        llSetRemoteScriptAccessPin(GHOST_PIN); 
        llSetTimerEvent(0.2);
    }
   
    timer()
    {
        if(bShouldMove)
        {
            vector currentPosition = llGetPos();
            float detectionDistance = 0.7; 
            vector beamEnd = currentPosition + (currentDirection * detectionDistance);
            
            list raycast = llCastRay(currentPosition, beamEnd, [RC_REJECT_TYPES, RC_REJECT_AGENTS]);
            integer status = llList2Integer(raycast, -1);
            
            vector nextPosition = currentPosition + (currentDirection * speed);
            integer isOutOfBounds = !IsSafeToMove(nextPosition); 
            
            if(status > 0) //|| isOutOfBounds)
            {
                vector newDirection = GenerateRandomDirection();
                while(newDirection == currentDirection || newDirection == -currentDirection)
                {
                    newDirection = GenerateRandomDirection();
                }
                
                currentDirection = newDirection;
                UpdateGhostSprite();
            }
            else
            {
                llSetPos(nextPosition);
            }
        }
    }
    
    link_message(integer sender_num, integer num, string str, key id)
    {
        if (str == "SLOW_ON")
        {
            speed = 0.08; 
            llSetColor(<0, 0, 1>, ALL_SIDES); 
            llOwnerSay("Ghost effect: SLOWED by user script.");
        }
        else if (str == "SLOW_OFF")
        {
            speed = 0.5;
            llSetColor(<1, 1, 1>, ALL_SIDES);
            llOwnerSay("Ghost effect: NORMAL SPEED restored.");
        }
    }
}