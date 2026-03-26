vector currentDirection = <-1, 0, 0>;
float speed = 0.8;
float lookAhead = 1.0; 
float ghostRadius = llGetScale().x; // 1.5; 
integer bShouldMove = TRUE;

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
    if (position.y >= 111.0 && position.y <= 143.0) 
    {
        // Area 1&3
        if ((position.y <= 121.0) || (position.y >= 133.0))
        {
            if (position.x >= 112.0 && position.x <= 144.0) 
                return TRUE;
        }
        else 
        {
            // Area 2
            if (position.x >= 118.5 && position.x <= 137.5) 
                return TRUE;
        }
    }
    
    return FALSE;
}

default
{
    state_entry()
    {
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
            
            if(status > 0 || isOutOfBounds)
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
}