vector currentDirection = <1, 0, 0>;
float speed = 0.8;
float lookAhead = 1.0; 
float ghostRadius = llGetScale().x / 1.5; 
integer bShouldMove = FALSE;


UpdateRotation()
{
    float finalAngle = 0;
    
    if(currentDirection == <1, 0, 0>)       finalAngle = 90;
    else if(currentDirection == <-1, 0, 0>)  finalAngle = -90;
    else if(currentDirection == <0, 1, 0>)   finalAngle = 180;
    else if(currentDirection == <0, -1, 0>)  finalAngle = 0;

    llSetRot(llEuler2Rot(<0, 0, finalAngle * DEG_TO_RAD>));
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
    //Area 1
    if (position.y >= 71 && position.y <= 110) 
    {
        //llOwnerSay("Ghost is in Area 1");
        if (position.x >= 100 && position.x <= 156) 
            return TRUE;
    }
    //Area 2
    else if (position.y > 110 && position.y < 146) 
    {
        //llOwnerSay("Ghost is in Area 2");
        if (position.x >= 111 && position.x <= 146) 
            return TRUE;
    }
    //Area 3
    else if (position.y >= 146 && position.y <= 186) 
    {
        //llOwnerSay("Ghost is in Area 3");
        if (position.x >= 100 && position.x <= 156) 
            return TRUE;
    }
    
    return FALSE; 
}

default
{
    state_entry()
    {
        UpdateRotation();
        llSetTimerEvent(0.2);
    }
   
    timer()
    {
        if(bShouldMove)
        {
            vector currentPosition = llGetPos();
            vector start = currentPosition + (currentDirection * ghostRadius);
            vector end = start + (currentDirection * lookAhead);
            
            list raycast = llCastRay(start, end, [RC_REJECT_TYPES, RC_REJECT_AGENTS]);
            integer status = llList2Integer(raycast, -1);
            
            vector nextStep = currentPosition + (currentDirection * (speed + ghostRadius));
            integer isOutOfBounds = !IsSafeToMove(nextStep);
            if(status > 0 || isOutOfBounds)
            {
                if(isOutOfBounds)
                    llOwnerSay("Ghost try to escape");
                vector newDirection = GenerateRandomDirection();
                while(newDirection == currentDirection || newDirection == -currentDirection)
                {
                    newDirection = GenerateRandomDirection();
                }
                //llOwnerSay("New Direction is:" + newDirection);
                currentDirection = newDirection;
            }
            UpdateRotation();
            llSetPos(currentPosition + (currentDirection * speed));
        }
        
    }
}