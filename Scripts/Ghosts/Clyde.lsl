float grid_unit = 2.0;

float NORMAL_SPEED = 1.0;
float SLOW_SPEED = 0.2;
float FRIGHTENED_SPEED = 0.5;

float speed = 1.0;
float effectDuration = 0.0;
float distractionDuration = 0.0;

integer canMove = FALSE;

integer isGhostOutside = FALSE;
integer isScatterMode = TRUE;

integer isFrightened = FALSE;
integer isEaten = FALSE;
integer isSlowed = FALSE;
integer isFrozen = FALSE;
integer isDistracted = FALSE;

vector currentDirection = <0, 0.5, 0>;

vector initialPosition = <131.0, 130.0, 21.5>;
vector outOfMazePosition = <128.0, 134.0, 21.5>;
vector clydeHomeCorner = <108.0, 110.0, 21.5>;
vector distractionTarget;

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

ResetEffects()
{
    isFrightened = FALSE;
    isSlowed = FALSE;
    isFrozen = FALSE;

    ResetDistraction(); 
    effectDuration = 0.0;
}

ApplyNormalState()
{
    ResetEffects();
    speed = NORMAL_SPEED;
    currentDirection = llVecNorm(currentDirection) * speed;
    UpdateGhostSprite();
}

ApplyFrightenedState()
{
    if (isEaten || !isGhostOutside)
        return;

    ResetEffects();
    isFrightened = TRUE;
    speed = FRIGHTENED_SPEED;
    currentDirection = -llVecNorm(currentDirection) * speed;
    UpdateGhostSprite();
}

ApplySlowState(float newSpeed, float duration)
{
    if (isEaten)
        return;

    ResetEffects();
    isSlowed = TRUE;
    speed = newSpeed;
    currentDirection = llVecNorm(currentDirection) * speed;
    effectDuration = duration;
    UpdateGhostSprite();
}

ApplyFreezeState(float duration)
{
    if (isEaten)
        return;

    ResetEffects();
    isFrozen = TRUE;
    speed = 0.0;
    effectDuration = duration;
    UpdateGhostSprite();
}

ApplyDistraction(vector target, float duration)
{
    if (isEaten || isFrozen)
        return;

    isDistracted = TRUE;
    distractionTarget = target;
    distractionDuration = duration;
    currentDirection = -currentDirection;
}

BecomeEaten()
{
    isEaten = TRUE;
    ResetEffects();
    speed = NORMAL_SPEED;
    currentDirection = llVecNorm(currentDirection) * speed;
    isGhostOutside = TRUE;
    llOwnerSay("Ghost eaten.");
    ResetDistraction();
    UpdateGhostSprite();
}

ResetDistraction()
{
    isDistracted = FALSE;
    distractionDuration = 0.0;
    distractionTarget = ZERO_VECTOR;
}

RespawnGhost()
{
    isEaten = FALSE;
    ApplyNormalState();
    isGhostOutside = FALSE;
    llOwnerSay("Ghost respawned.");
    ResetDistraction();
    UpdateGhostSprite();
}

ResetGhost()
{
    canMove = FALSE;
    isGhostOutside = FALSE;
    isScatterMode = TRUE;
    isEaten = FALSE;
    ApplyNormalState();
    currentDirection = <-0.5, 0.0, 0.0>;
    llSetRegionPos(initialPosition);
    ResetDistraction();
    UpdateGhostSprite();
}

UpdateGhostSprite()
{
    float frame = 0.0;

    if (currentDirection.x > 0)
        frame = 0.0;
    else if (currentDirection.x < 0)
        frame = 1.0;
    else if (currentDirection.y > 0)
        frame = 2.0;
    else if (currentDirection.y < 0)
        frame = 3.0;

    llSetTextureAnim(FALSE, 0, 0, 0, 0.0, 0.0, 0.0);

    if (isEaten)
    {
        llSetTexture("EatenGhost", ALL_SIDES);
        llSetTextureAnim(ANIM_ON, 0, 4, 1, frame, 1.0, 0.0);
    }
    else if (isFrozen)
    {
        llSetTexture("SleepyClyde", ALL_SIDES);
    }
    else if (isFrightened)
    {
        llSetTexture("FrightenedGhost", ALL_SIDES);
    }
    else if (isSlowed)
    {
        llSetTexture("SlowedClyde", ALL_SIDES);
    }
    else
    {
        llSetTexture("OrangeGhost", ALL_SIDES);
        llSetTextureAnim(ANIM_ON, 0, 4, 1, frame, 1.0, 0.0);
    }
}



integer isPathClear(vector pos, vector dir)
{
    if (isFrozen)
        return FALSE;

    vector startPoint = pos + (llVecNorm(dir) * 0.6);

    vector endPosition = startPoint + (llVecNorm(dir) * 1.2);

    list raycast = llCastRay(startPoint, endPosition,
    [
        RC_REJECT_TYPES,
        RC_REJECT_AGENTS | RC_REJECT_LAND,

        RC_DATA_FLAGS,
        RC_GET_ROOT_KEY
    ]);

    integer result = llList2Integer(raycast, -1);

    if (result > 0)
    {
        key hitKey = llList2Key(raycast, 0);

        string hitName = llKey2Name(hitKey);

        if (checkName(hitName) != -1 || hitName == "Pellet" || hitName == "PowerPellet")
        {
            return TRUE;
        }
        else if (hitName == "Pacman")
        {
            if (isFrightened && !isEaten)
            {
                BecomeEaten();
            }
            else if (!isFrightened && !isEaten)
            {
                llRegionSay(-99, "EAT_PACMAN");
            }

            return TRUE;
        }
        else if (hitName == "GhostGate")
        {
            if (isEaten)
                return TRUE;

            if (isGhostOutside)
                return FALSE;

            llSetRegionPos(outOfMazePosition);

            isGhostOutside = TRUE;

            return TRUE;
        }
        return FALSE;
    }
    return TRUE;
}

vector chooseRandomDirection(vector pos)
{
    list testDirs =
    [
        <speed,0,0>,
        <-speed,0,0>,
        <0,speed,0>,
        <0,-speed,0>
    ];

    list available = [];

    integer i;

    for(i = 0; i < 4 ;i++)
    {
        vector d = llList2Vector(testDirs, i);

        if(isPathClear(pos, d))
        {
            if(d != -currentDirection)
            {
                available += [d];
            }
        }
    }

    integer count = llGetListLength(available);

    if(count == 0)
        return -currentDirection;

    return llList2Vector( available, (integer)llFrand(count));
}

vector chooseDistractionDirection(vector pos)
{
    list testDirections = [<speed,0,0>, <-speed,0,0>, <0,speed,0>, <0,-speed,0>];

    list available = [];

    integer i;

    for (i = 0; i < 4; i++)
    {
        vector d = llList2Vector(testDirections, i);

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

    vector bestDirection = llList2Vector(available, 0);

    float minDistance = 999999.0;

    for (i = 0; i < count; i++)
    {
        vector d = llList2Vector(available, i);

        float dist = llVecDist(pos + d, distractionTarget);

        if (dist < minDistance)
        {
            minDistance = dist;
            bestDirection = d;
        }
    }

    return bestDirection;
}

vector chooseClydeDirection(vector pos)
{
    vector targetPosition;

    list details = llGetObjectDetails(pacmanKey, [OBJECT_POS]);

    if (isEaten)
    {
        targetPosition = initialPosition;
    }
    else if (llGetListLength(details) > 0)
    {
        if (isScatterMode)
        {
            targetPosition = clydeHomeCorner;
        }
        else
        {
            vector pacmanPosition = llList2Vector(details, 0);
            float distanceToPacman = llVecDist(pos, pacmanPosition);
            
            if(distanceToPacman <= 16.0)
            {
                targetPosition = clydeHomeCorner;
            }
            else
            {
                targetPosition = pacmanPosition;
            }
        }
    }
    else
    {
        return chooseRandomDirection(pos);
    }

    list testDirections =
    [
        <speed,0,0>,
        <-speed,0,0>,
        <0,speed,0>,
        <0,-speed,0>
    ];

    list available = [];

    integer i;

    for(i = 0; i < 4; i++)
    {
        vector d = llList2Vector(testDirections, i);

        if(isPathClear(pos, d))
        {
            if(d != -currentDirection)
            {
                available += [d];
            }
        }
    }

    integer count = llGetListLength(available);

    if(count == 0)
        return -currentDirection;

    vector bestDirection = llList2Vector(available, 0);

    float minDistance = 9999.0;

    for(i = 0; i < count; i++)
    {
        vector d = llList2Vector(available, i);
        float dist = llVecDist(pos + d, targetPosition);

        if(dist < minDistance)
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
        llSensorRepeat( "Pacman", NULL_KEY, PASSIVE | SCRIPTED, 96.0, PI, 2.0);

        llListen(-100, "", NULL_KEY, "");
        llListen(-200, "", NULL_KEY, "");
        llListen(-300, "", NULL_KEY, "");
        llListen(777, "", NULL_KEY, "");

        llSetTimerEvent(0.1);
        UpdateGhostSprite(); 
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
        if(!canMove)
            return;

        vector pos = llGetPos();

        if (pacmanKey != NULL_KEY)
        {
            list pacmanDetails = llGetObjectDetails(pacmanKey, [OBJECT_POS]);
            if (llGetListLength(pacmanDetails) > 0)
            {
                vector pacmanPos = llList2Vector(pacmanDetails, 0);
                float currentDist = llVecDist(pos, pacmanPos);
                
                if (currentDist <= 1.6)
                {
                    if (isFrightened && !isEaten)
                    {
                        BecomeEaten();
                    }
                    else if (!isFrightened && !isEaten)
                    {
                        llRegionSay(-99, "DIE_PACMAN");
                        ResetGhost();
                        return; 
                    }
                }
            }
        }
        
        if (effectDuration > 0.0)
        {
            effectDuration -= 0.1;

            if (effectDuration <= 0.0)
            {
                ApplyNormalState();
            }
        }
        
        if (distractionDuration > 0.0)
        {
            distractionDuration -= 0.1;
        
            if (distractionDuration <= 0.0)
            {
                ResetDistraction();
                currentDirection = -currentDirection;
            }
        }
        
        if (isEaten)
        {
            if (llVecDist(pos, initialPosition) < 0.6)
            {
                RespawnGhost();
            }
        }

        if(speed <= 0.0)
            return;


        integer aheadClear = isPathClear(pos, currentDirection);
        float distX = llFabs(pos.x - snap(pos.x));
        float distY = llFabs(pos.y - snap(pos.y));

        if ((distX < 0.25 && distY < 0.25) || !aheadClear)
        {
            vector nextDir;

            if (isEaten)
            {
                nextDir = chooseClydeDirection(pos);
            }
            else if (isFrightened)
            {
                nextDir = chooseRandomDirection(pos);
            }
            else if (isDistracted)
            {
                nextDir = chooseDistractionDirection(pos);
            }
            else if (isGhostOutside)
            {
                nextDir = chooseClydeDirection(pos);
            }
            else
            {
                nextDir = chooseRandomDirection(pos);
            }

            if (nextDir != currentDirection)
            {
                currentDirection = nextDir;

                pos.x = snap(pos.x);
                pos.y = snap(pos.y);

                llSetRegionPos(pos);

                UpdateGhostSprite();
            }
        }

        if(isPathClear(pos, currentDirection))
        {
            llSetRegionPos(pos + currentDirection);
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
            if (msg == "SCATTER_MODE")
            {
                isScatterMode = TRUE;
                currentDirection = -currentDirection;
                UpdateGhostSprite();
            }
            else if (msg == "CHASE_MODE")
            {
                isScatterMode = FALSE;
                currentDirection = -currentDirection;
                UpdateGhostSprite();
            }
        }
        else if (channel == -300)
        {
            if (msg == "GHOST_FRIGHT")
            {
                ApplyFrightenedState();
            }
            else if (msg == "GHOST_FRIGHT_STOP")
            {
                if (!isEaten)
                {
                    ApplyNormalState();
                }
            }
        }
        else if (channel == 777)
        {
            if (!canMove || isEaten)
                return;
                
            if (llSubStringIndex(msg, "SLOW") == 0)
            {
                float s = SLOW_SPEED;
                float d = 5.0;

                if (llSubStringIndex(msg, "SLOW_") == 0)
                {
                    s = (float)llDeleteSubString(msg, 0, 4);
                }
                ApplySlowState(s, d);
            }
            else if (llSubStringIndex(msg, "FREEZE") == 0)
            {
                float d = 4.0;

                if (llSubStringIndex(msg, "FREEZE_") == 0)
                {
                    d = (float)llDeleteSubString(msg, 0, 6);
                }

                ApplyFreezeState(d);
            }
            else if (msg == "DISTRACT")
            {
                ApplyDistraction( clydeHomeCorner, 25.0 );
            }
            else if (llSubStringIndex(msg, "DISTRACT=") == 0)
            {
                vector target = (vector)llDeleteSubString(msg, 0, 8);

                ApplyDistraction(target, 25.0);
            }
        }
    }
}