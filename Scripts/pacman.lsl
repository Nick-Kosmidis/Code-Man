float grid_unit = 2.0; 
vector nextDirection = <0.5, 0.0, 0.0>;
vector currentDirection = <0.5, 0.0, 0.0>; 
float speed = 0.5;
float currentSpeed = 0.5;
float pacmanRadius = 2.0; 
float teleportFreezeUntil = 0.0;

integer lifes = 3;
integer controls_to_track;
integer canMove = FALSE;
integer isEaten = FALSE;

integer isCamouflaged = FALSE;
float camouflageDuration;
float camouflageTime = 10.0;
string camouflageGhost = "YellowGhost";
string camouflageMode = "NORMAL";
float camouflageSpeedMultiplier = 1.0;

float energyRefillCooldown = 10.0;
float lastEnergyRefillTime = 0.0;

float MIN_X = 96.0;
float MAX_X = 160.0;
float MIN_Y = 108.0;
float MAX_Y = 152.0;

integer HUD_CHANNEL = -98;

integer energy = 100;


list SAFE_TILES = [<108.0, 110.0, 21.5>, <110.0, 110.0, 21.5>, <112.0, 110.0, 21.5>, <114.0, 110.0, 21.5>, <116.0, 110.0, 21.5>, <118.0, 110.0, 21.5>, 
<120.0, 110.0, 21.5>, <122.0, 110.0, 21.5>, <124.0, 110.0, 21.5>, <126.0, 110.0, 21.5>, <128.0, 110.0, 21.5>, <130.0, 110.0, 21.5>, <132.0, 110.0, 21.5>, <134.0, 110.0, 21.5>,
<136.0, 110.0, 21.5>, <138.0, 110.0, 21.5>, <140.0, 110.0, 21.5>, <140.0, 110.0, 21.5>, <142.0, 110.0, 21.5>, <144.0, 110.0, 21.5>, <146.0, 110.0, 21.5>, <148.0, 110.0, 21.5>,
<108.0, 112.0, 21.5>, <126.0, 112.0, 21.5>, <130.0, 112.0, 21.5>, <148.0, 112.0, 21.5>, <108.0, 114.0, 21.5>, <110.0, 114.0, 21.5>, <112.0, 114.0, 21.5>, <114.0, 114.0, 21.5>,
<116.0, 114.0, 21.5>, <120.0, 114.0, 21.5>, <122.0, 114.0, 21.5>, <124.0, 114.0, 21.5>, <126.0, 114.0, 21.5>, <130.0, 114.0, 21.5>, <132.0, 114.0, 21.5>, <134.0, 114.0, 21.5>, 
<136.0, 114.0, 21.5>, <140.0, 114.0, 21.5>, <142.0, 114.0, 21.5>, <144.0, 114.0, 21.5>, <146.0, 114.0, 21.5>, <148.0, 114.0, 21.5>, <112.0, 116.0, 21.5>, <116.0, 116.0, 21.5>, 
<136.0, 116.0, 21.5>, <136.0, 116.0, 21.5>, <140.0, 116.0, 21.5>, <142.0, 116.0, 21.5>, <108.0, 118.0, 21.5>, <110.0, 118.0, 21.5>, <112.0, 118.0, 21.5>, <116.0, 118.0, 21.5>, 
<118.0, 118.0, 21.5>, <120.0, 118.0, 21.5>, <122.0, 118.0, 21.5>, <124.0, 118.0, 21.5>, <126.0, 118.0, 21.5>, <128.0, 118.0, 21.5>, <130.0, 118.0, 21.5>, <132.0, 118.0, 21.5>, 
<134.0, 118.0, 21.5>, <136.0, 118.0, 21.5>, <138.0, 118.0, 21.5>, <140.0, 118.0, 21.5>, <140.0, 118.0, 21.5>, <144.0, 118.0, 21.5>, <146.0, 118.0, 21.5>, <148.0, 118.0, 21.5>,
<108.0, 120.0, 21.5>, <116.0, 120.0, 21.5>, <126.0, 120.0, 21.5>, <130.0, 120.0, 21.5>, <140.0, 120.0, 21.5>, <148.0, 120.0, 21.5>, <108.0, 122.0, 21.5>, <110.0, 122.0, 21.5>, 
<112.0, 122.0, 21.5>, <114.0, 122.0, 21.5>, <116.0, 122.0, 21.5>, <118.0, 122.0, 21.5>, <120.0, 122.0, 21.5>, <122.0, 122.0, 21.5>, <124.0, 122.0, 21.5>, <126.0, 122.0, 21.5>, 
<130.0, 122.0, 21.5>, <132.0, 122.0, 21.5>, <134.0, 122.0, 21.5>, <136.0, 122.0, 21.5>, <138.0, 122.0, 21.5>, <140.0, 122.0, 21.5>, <140.0, 122.0, 21.5>, <142.0, 122.0, 21.5>, 
<144.0, 122.0, 21.5>, <146.0, 122.0, 21.5>, <148.0, 122.0, 21.5>, <116.0, 124.0, 21.5>, <120.0, 124.0, 21.5>,<136.0, 124.0, 21.5>, <140.0, 124.0, 21.5>, <116.0, 126.0, 21.5>, <120.0, 126.0, 21.5>, 
<122.0, 126.0, 21.5>, <124.0, 126.0, 21.5>, <126.0, 126.0, 21.5>, <128.0, 126.0, 21.5>, <130.0, 126.0, 21.5>, <132.0, 126.0, 21.5>, <134.0, 126.0, 21.5>, <136.0, 126.0, 21.5>, 
<140.0, 126.0, 21.5>, <116.0, 128.0, 21.5>, <120.0, 128.0, 21.5>, <136.0, 128.0, 21.5>, <140.0, 128.0, 21.5>, <116.0, 130.0, 21.5>, <118.0, 130.0, 21.5>, <120.0, 130.0, 21.5>,
<116.0, 130.0, 21.5>, <136.0, 130.0, 21.5>, <138.0, 130.0, 21.5>, <140.0, 130.0, 21.5>, <116.0, 132.0, 21.5>, <120.0, 132.0, 21.5>, <136.0, 132.0, 21.5>, <140.0, 132.0, 21.5>,
<116.0, 134.0, 21.5>, <120.0, 134.0, 21.5>, <122.0, 134.0, 21.5>, <124.0, 134.0, 21.5>, <126.0, 134.0, 21.5>, <128.0, 134.0, 21.5>, <130.0, 134.0, 21.5>, <132.0, 134.0, 21.5>, 
<134.0, 134.0, 21.5>, <136.0, 134.0, 21.5>, <140.0, 134.0, 21.5>, <116.0, 136.0, 21.5>, <126.0, 136.0, 21.5>, <130.0, 136.0, 21.5>, <140.0, 136.0, 21.5>, <108.0, 138.0, 21.5>, <110.0, 138.0, 21.5>, <112.0, 138.0, 21.5>, <114.0, 138.0, 21.5>, <116.0, 138.0, 21.5>, <120.0, 138.0, 21.5>, 
<122.0, 138.0, 21.5>, <124.0, 138.0, 21.5>, <126.0, 138.0, 21.5>, <130.0, 138.0, 21.5>, <132.0, 138.0, 21.5>, <134.0, 138.0, 21.5>, <136.0, 138.0, 21.5>, <140.0, 138.0, 21.5>, 
<142.0, 138.0, 21.5>, <144.0, 138.0, 21.5>, <146.0, 138.0, 21.5>, <148.0, 138.0, 21.5>, <108.0, 140.0, 21.5>, <116.0, 140.0, 21.5>, <120.0, 140.0, 21.5>, <136.0, 140.0, 21.5>,
<140.0, 140.0, 21.5>, <148.0, 140.0, 21.5>, <108.0, 142.0, 21.5>, <110.0, 142.0, 21.5>, <112.0, 142.0, 21.5>, <114.0, 142.0, 21.5>, <116.0, 142.0, 21.5>, <118.0, 142.0, 21.5>, 
<120.0, 142.0, 21.5>, <122.0, 142.0, 21.5>, <124.0, 142.0, 21.5>, <126.0, 142.0, 21.5>, <128.0, 142.0, 21.5>, <130.0, 142.0, 21.5>, <132.0, 142.0, 21.5>, <134.0, 142.0, 21.5>,
<136.0, 142.0, 21.5>, <138.0, 142.0, 21.5>, <140.0, 142.0, 21.5>, <140.0, 142.0, 21.5>, <142.0, 142.0, 21.5>, <144.0, 142.0, 21.5>, <146.0, 142.0, 21.5>, <148.0, 142.0, 21.5>,
<108.0, 144.0, 21.5>, <116.0, 144.0, 21.5>, <126.0, 144.0, 21.5>, <130.0, 144.0, 21.5>, <140.0, 144.0, 21.5>, <148.0, 144.0, 21.5>, <108.0, 146.0, 21.5>, <116.0, 146.0, 21.5>, 
<126.0, 146.0, 21.5>, <130.0, 146.0, 21.5>, <140.0, 146.0, 21.5>, <148.0, 146.0, 21.5>, <108.0, 148.0, 21.5>, <110.0, 148.0, 21.5>, <112.0, 148.0, 21.5>, <114.0, 148.0, 21.5>, 
<116.0, 148.0, 21.5>, <118.0, 148.0, 21.5>, <120.0, 148.0, 21.5>, <122.0, 148.0, 21.5>, <124.0, 148.0, 21.5>, <126.0, 148.0, 21.5>, <130.0, 148.0, 21.5>, <132.0, 148.0, 21.5>, 
<134.0, 148.0, 21.5>, <136.0, 148.0, 21.5>, <138.0, 148.0, 21.5>, <140.0, 148.0, 21.5>, <140.0, 148.0, 21.5>, <142.0, 148.0, 21.5>, <144.0, 148.0, 21.5>, <146.0, 148.0, 21.5>, 
<148.0, 148.0, 21.5>];

integer CanScriptExecute(integer amount)
{
    if(energy-amount < 0)
    {
        llOwnerSay("You dont have enough energy for this...");
        return FALSE;
    }
    
    energy -= amount;
    return TRUE;
}

float snap(float val) 
{
    return (float)llRound(val / grid_unit) * grid_unit;
}

integer IsSafeTeleportPosition(vector pos)
{
    return isPathClear(pos, <0.5,0,0>)
        && isPathClear(pos, <-0.5,0,0>)
        && isPathClear(pos, <0,0.5,0>)
        && isPathClear(pos, <0,-0.5,0>);
}

vector FindRandomSafeLocation()
{
    integer attempts = 50;

    while(attempts--)
    {
        float x = snap(MIN_X + llFrand(MAX_X - MIN_X));
        float y = snap(MIN_Y + llFrand(MAX_Y - MIN_Y));

        vector pos = <x, y, 21.5>;

        if(IsSafeTeleportPosition(pos))
        {
            return pos;
        }
    }

    return llGetPos();
}

StunPacman()
{
    if(llFrand(1.0) > 0.5)
    {
        llOwnerSay("Pacman cant move for 5 seconds!");
        teleportFreezeUntil = llGetTime() + 5.0;   
    }
}

ApplyRandomTeleport()
{
    integer safeTilesCount = llGetListLength(SAFE_TILES);
    integer randomTileIndex = (integer)llFrand(safeTilesCount);
    vector targetTile = llList2Vector(SAFE_TILES, randomTileIndex);
    llSetRegionPos(targetTile);
    StunPacman();
}

integer isTileSafe(vector tile)
{
    if (llListFindList(SAFE_TILES, [tile]) != -1)
        return TRUE; 

    return FALSE; 
}

vector GetClosestTileByStep(vector targetTile, integer step, vector direction)
{
    vector normDir = llVecNorm(direction);
    
    integer i;
    for (i = 1; i <= step; i++)
    {
        vector checkTile = targetTile + (normDir * (i * grid_unit));
        
        checkTile.x = (float)llRound(checkTile.x / grid_unit) * grid_unit;
        checkTile.y = (float)llRound(checkTile.y / grid_unit) * grid_unit;
        checkTile.z = targetTile.z; 
        
        if (llListFindList(SAFE_TILES, [checkTile]) != -1)
        {
            return checkTile;
        }
    }
    
    return llGetPos();
}

vector GetClosestTile(vector targetTile)
{
    integer totalTiles = llGetListLength(SAFE_TILES);
    if(totalTiles == 0) 
        return llGetPos();
        
    vector firstTile = llList2Vector(SAFE_TILES, 0);
    float minDistance = llVecDist(targetTile, firstTile);
    
    integer i;
    for (i = 1; i < totalTiles; i++)
    {
        vector currentTile = llList2Vector(SAFE_TILES, i);
        float dist = llVecDist(targetTile, currentTile);
        
        if (dist < minDistance)
        {
            minDistance = dist;
        }
    }
    
    list closestCandidates = [];
    for (i = 0; i < totalTiles; i++)
    {
        vector currentTile = llList2Vector(SAFE_TILES, i);
        float dist = llVecDist(targetTile, currentTile);
        
        if (llFabs(dist - minDistance) < 0.01)
        {
            closestCandidates += [currentTile];
        }
    }

    integer candidatesCount = llGetListLength(closestCandidates);
    integer randIdx = (integer)llFrand(candidatesCount);
    
    return llList2Vector(closestCandidates, randIdx);
}

ApplySteppedTeleport(integer step, vector direction)
{       
    vector targetTile = llGetPos() + (direction * (step * grid_unit));
    
    targetTile.x = (float)llRound(targetTile.x / grid_unit) * grid_unit;
    targetTile.y = (float)llRound(targetTile.y / grid_unit) * grid_unit;
    targetTile.z = 21.5; 
    if(isTileSafe(targetTile))
    {
        llSetRegionPos(targetTile);
    }
    else
    {
        vector safeTile = GetClosestTileByStep(targetTile, step, direction);
        llSetRegionPos(safeTile);
    }

    StunPacman();
}

ApplyTeleport(vector targetTile)
{
    targetTile.x = (float)llRound(targetTile.x / grid_unit) * grid_unit;
    targetTile.y = (float)llRound(targetTile.y / grid_unit) * grid_unit;
    targetTile.z = 21.5;

    if(isTileSafe(targetTile))
    {
        llSetRegionPos(targetTile);
    }
    else
    {
        vector safeTile = GetClosestTile(targetTile);
        llSetRegionPos(safeTile);
    }

    StunPacman();
}

ParseTeleport(string msg)
{
    string cleanMsg = llStringTrim(msg, STRING_TRIM);
    list parts = llParseString2List(cleanMsg, ["=", ","], []);
    integer count = llGetListLength(parts);
    
    if(count == 1)
    {
        ApplyRandomTeleport();
    }
    else if(count == 2)
    {
        integer step = (integer)llList2String(parts, 1);
        if(step > 0)
        {
            list directions = [<1.0,0.0,0.0>, <-1.0,0.0,0.0>, <0.0,1.0,0.0>, <0.0,-1.0,0.0>];
            integer randomIndex = (integer)llFrand(4);
            vector direction = llList2Vector(directions, randomIndex);
            
            if(step > 10) 
                step = 10; 
            
            ApplySteppedTeleport(step, direction);   
        }
    }
    else if(count == 3)
    {
        string param1 = llList2String(parts, 1);
        string param2 = llToUpper(llStringTrim(llList2String(parts, 2), STRING_TRIM));

        if(param2 == "LEFT" || param2 == "RIGHT" || param2 == "UP" || param2 == "DOWN")
        {
            integer step = (integer)param1;
            if(step > 0)
            {
                if(step > 10) 
                    step = 10; 
                
                vector direction = <1.0, 0.0, 0.0>; 
                if(param2 == "LEFT")        
                    direction = <-1.0, 0.0, 0.0>;
                else if(param2 == "RIGHT")  
                    direction = <1.0, 0.0, 0.0>;
                else if(param2 == "UP")     
                    direction = <0.0, 1.0, 0.0>;
                else if(param2 == "DOWN")   
                    direction = <0.0, -1.0, 0.0>;
                
                ApplySteppedTeleport(step, direction);
            }
        }
        else 
        {
            float X = (float)param1;
            float Y = (float)llList2String(parts, 2);
            
            if(X > 0 && Y > 0)
            {
                vector targetTile = <X, Y, 21.5>;
                ApplyTeleport(targetTile);
            }
        }
    }
}

ParseCamouflage(string msg)
{
    list parts = llParseString2List(msg, ["=", ":"], []);
    integer count = llGetListLength(parts);
    camouflageGhost = "YellowGhost";
    camouflageMode = "NORMAL";
    integer i;

    for(i = 1; i < count; i++)
    {
        string token = llToUpper(llList2String(parts, i));
        if(token == "BLINKY" || token == "PINKY" || token == "INKY" || token == "CLYDE")
            camouflageGhost = token;
        else if(token == "FAST" || token == "SLOW")
            camouflageMode = token;
        else {
            float value = (float)token;
            if(value > 0.0) {
                camouflageTime = value;
                if(camouflageTime > 15.0) camouflageTime = 15.0;
                if(camouflageTime < 1.0) camouflageTime = 1.0;
            }
        }
    }
    ApplyCamouflage(camouflageTime);
}

ApplyCamouflage(float time)
{
    isCamouflaged = TRUE;
    camouflageDuration = time;
    llSetRot(llEuler2Rot(<0,0,0>));
    ApplyCamouflageGhost();
    ApplyCamouflageMode();
    UpdateCamouflageSprite();
    llOwnerSay("Camouflage Activated");
}

ApplyCamouflageGhost()
{
    string texture = "YellowGhost";
    if(camouflageGhost == "BLINKY")      texture = "Blinky";
    else if(camouflageGhost == "PINKY") texture = "Pinky";
    else if(camouflageGhost == "INKY")  texture = "Inky";
    else if(camouflageGhost == "CLYDE") texture = "Clyde";

    llSetTexture(texture, ALL_SIDES);
    llSetObjectName(camouflageGhost);
}

ApplyCamouflageMode()
{
    camouflageSpeedMultiplier = 1.0;
    if(camouflageMode == "FAST")       camouflageSpeedMultiplier = 2.0;
    else if(camouflageMode == "SLOW")  camouflageSpeedMultiplier = 0.5;
}

ResetCamouflage()
{
    isCamouflaged = FALSE;
    camouflageDuration = 0.0;
    camouflageGhost = "YellowGhost";
    camouflageMode = "NORMAL";
    camouflageSpeedMultiplier = 1.0;
    
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
    if(!isCamouflaged) return;
    float frame = 0.0;

    if(currentDirection.x > 0)       frame = 0.0;
    else if(currentDirection.x < 0)  frame = 1.0;
    else if(currentDirection.y > 0)  frame = 2.0;
    else if(currentDirection.y < 0)  frame = 3.0;

    string texture = "YellowGhost";
    if(camouflageGhost == "BLINKY")      texture = "Blinky";
    else if(camouflageGhost == "PINKY") texture = "Pinky";
    else if(camouflageGhost == "INKY")  texture = "Inky";
    else if(camouflageGhost == "CLYDE") texture = "Clyde";

    llSetTextureAnim(FALSE, ALL_SIDES, 0,0,0,0,0);
    llSetTexture(texture, ALL_SIDES);
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
        else if (hitName == "GhostBarrier")
        {
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
        llListen(-99, "", NULL_KEY, ""); 
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
        llResetScript();
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

        if (llGetTime() < teleportFreezeUntil)
        {
            return;
        }

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
                    
                    if(isCamouflaged) UpdateCamouflageSprite();
                    else {
                        float angle = llAtan2(currentDirection.y, currentDirection.x);
                        llSetRot(llEuler2Rot(<0, 0, angle>));
                    }
                }
            }
        }
                
        if (camouflageDuration > 0.0)
        {
            camouflageDuration -= 0.1;
            if (camouflageDuration <= 0.0) ResetCamouflage();
        }

        vector moveDir = currentDirection;
        if(isCamouflaged) moveDir *= camouflageSpeedMultiplier;

        if (isPathClear(pos, currentDirection))
        {
            llSetRegionPos(pos + moveDir);
        }
    }
    
    listen(integer channel, string name, key id, string msg)
    {
 
        if(llSubStringIndex(msg, "CHECK_ENERGY=") == 0)
        {
            string data = llGetSubString(msg, 13, -1);
            list parts = llParseString2List(data, [":"], []);
            
            integer cost = (integer)llList2String(parts, 0);
            string originalCommand = llList2String(parts, 1);
            
            if(CanScriptExecute(cost))
            {
                llOwnerSay("Consumed " + (string)cost + " energy. Remaining energy: " + energy);
                if(llSubStringIndex(originalCommand, "SLOW") == 0 ||llSubStringIndex(originalCommand, "FREEZE") == 0 || llSubStringIndex(originalCommand, "DISTRACT") == 0)
                {
                    llRegionSay(HUD_CHANNEL, "ENERGY_APPROVED=" + originalCommand);
                }
                else if(llSubStringIndex(originalCommand, "CAMOUFLAGE") == 0) {
                    ParseCamouflage(originalCommand);
                }
                else if(llSubStringIndex(originalCommand, "TELEPORT") == 0) {
                    ParseTeleport(originalCommand);
                }
            }
        }
        else if (llSubStringIndex(msg, "ENERGY_REFILL") == 0)
        {
            float currentTime = llGetTime();
            if (currentTime - lastEnergyRefillTime < energyRefillCooldown)
            {
                float remainingCooldown = energyRefillCooldown - (currentTime - lastEnergyRefillTime);
                llOwnerSay("Energy Refill is on cooldown! Please wait " + (string)energyRefillCooldown + " seconds.");
                return;
            }
            integer amountToAdd = 10;
    
            if (llSubStringIndex(msg, "=") != -1)
            {
                list refillParts = llParseString2List(msg, ["="], []);
                amountToAdd = (integer)llList2String(refillParts, 1);
            }
            energy = energy + amountToAdd;
    
            if (energy > 100) 
            {
                energy = 100;
            }
    
            llOwnerSay("Energy restored by " + (string)amountToAdd + "! Current Energy: " + (string)energy);
            
            lastEnergyRefillTime = currentTime;
        }
            
        if (msg == "DIE_PACMAN") 
        {
            if(isEaten) return;
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
            llShout(-100, "STOP_GAME");
            llRegionSay(-98, "END_GAME");
            llRegionSay(-500, "RESET"); 
            llDie();
        }
    }
}