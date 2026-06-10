integer scatterTime = 7;
integer chaseTime = 20;
integer isScatter = TRUE;
integer gameActive = FALSE;

integer modeTimer = 0;   
integer noClipCounter = 0; 
integer cloakCounter = 0;
integer energyDrainCounter = 0;
integer revertedControlsCounter = 0;
integer eventCooldown = 0; 
    
integer GHOST_CHANNEL = 777;
integer MAZE_CHANNEL = -600;
integer PACMAN_CHANNEL = -99;
integer HUD_CHANNEL = -98;

list POWERUP_POSITIONS = [<126.0, 134.0, 21.0>, <130.0, 134.0, 21.0>, <132.0, 134.0, 21.0>, <134.0, 134.0, 21.0>,
<136.0, 134.0, 21.0>, <136.0, 132.0, 21.0>, <136.0, 130.0, 21.0>, <138.0, 130.0, 21.0>, <136.0, 128.0, 21.0>, <136.0, 126.0, 21.0>, <132.0, 126.0, 21.0>, <130.0, 126.0, 21.0>, 
<128.0, 126.0, 21.0>];

SpawnPowerUp()
{
    string inventoryName = "PowerUp";

    llOwnerSay("Trying to spawn powerup");

    integer type = llGetInventoryType(inventoryName);

    llOwnerSay("Inventory type = " + (string)type);

    if(type == INVENTORY_OBJECT)
    {
        integer safeTilesCount = llGetListLength(POWERUP_POSITIONS);
        integer randomTileIndex = (integer)llFrand(safeTilesCount);

        vector targetTile = llList2Vector(POWERUP_POSITIONS, randomTileIndex);

        llOwnerSay("Rezzing at " + (string)targetTile);

        llRezObject(
            inventoryName,
            <126.0, 134.0, 21.0>,
            ZERO_VECTOR,
            ZERO_ROTATION,
            0
        );
    }
}

SpawnGhost(string ghostName, vector position)
{
    string inventoryName = "YellowGhost";
    
    if(ghostName == "BLINKY")       inventoryName = "Blinky";
    else if(ghostName == "INKY")    inventoryName = "Inky";
    else if(ghostName == "PINKY")   inventoryName = "Pinky";
    else if(ghostName == "CLYDE")   inventoryName = "Clyde";
    
    if (llGetInventoryType(inventoryName) == INVENTORY_OBJECT)
    {
        llRezObject(inventoryName, <128.0, 134.0, 21.5>, ZERO_VECTOR, ZERO_ROTATION, 0);
        llOwnerSay("Spawning " + inventoryName + " at position " + (string)position);
    }
    else
    {
        llOwnerSay("Error: Ghost " + inventoryName + " not in Inventory!");
    }
}

TriggerRandomEvent()
{
    if (noClipCounter > 0 || cloakCounter > 0) 
        return;

    integer dice = (integer)llFrand(5.0);
    dice = 4;
    if (dice == 0)
    {
        noClipCounter = 15; 
        llRegionSay(MAZE_CHANNEL, "NO_CLIP_ON"); 
        llOwnerSay("[RANDOM EVENT] Ghosts enabled No-Clip! Walls are now phase-shifted.");
    }
    else if (dice == 1)
    {
        energyDrainCounter = 15; 
        llRegionSay(PACMAN_CHANNEL, "REMOVE_ENERGY=5");  
        llOwnerSay("[RANDOM EVENT] Pacman's energy drains!!!");
    }
    else if (dice == 2)
    { 
        llRegionSay(MAZE_CHANNEL, "CHANGE_POSITION");  
        llOwnerSay("[RANDOM EVENT] Terrain Teraforming!!!");
    }
    else if (dice == 3)
    { 
        revertedControlsCounter = 10;
        llRegionSay(PACMAN_CHANNEL, "REVERT_CONTROLS");  
        llOwnerSay("[RANDOM EVENT] Pacman Controls are reverted!!!");
    }
    else if (dice == 4)
    {
        llRegionSay(HUD_CHANNEL, "CODE_DEACTIVATED");
        SpawnPowerUp();
    }
    else
    {
        llOwnerSay("CLOAKING");
        cloakCounter = 12;
        llRegionSay(GHOST_CHANNEL, "CLOAK_ON");
        llOwnerSay("[RANDOM EVENT] Ghosts enabled Cloaking! They are now invisible.");
    }
    
     eventCooldown = 40;
}

default
{
    state_entry()
    {
        llListen(-100, "", NULL_KEY, "");
        
    }

    listen(integer channel, string name, key id, string msg)
    {
        if (msg == "START_GAME")
        {
            gameActive = TRUE;
            isScatter = TRUE;
            modeTimer = scatterTime;
            noClipCounter = 0;
            cloakCounter = 0;
            eventCooldown = 5;
            
            llRegionSay(GHOST_CHANNEL, "SCATTER_MODE");
            llSetTimerEvent(1.0); 
        }
        else if (msg == "STOP_GAME" || msg == "RESET")
        {
            gameActive = FALSE;
            noClipCounter = 0;
            cloakCounter = 0;
            llSetTimerEvent(0); 
            llRegionSay(MAZE_CHANNEL, "NO_CLIP_OFF");
            llRegionSay(MAZE_CHANNEL, "RESET_POSITION");
            llRegionSay(GHOST_CHANNEL, "CLOAK_OFF");
        }
        else if(llSubStringIndex(msg, "SPAWN:") == 0)
        {
            list parts = llParseString2List(msg, [":"], []);
            string ghostName = llToUpper(llList2String(parts, 1));
            vector spawnPosition = (vector)llList2String(parts, 2);
            SpawnGhost(ghostName, spawnPosition);
        }
    }

    timer()
    {
        if (!gameActive) 
            return;

        if (modeTimer > 0)
        {
            modeTimer--;
            if (modeTimer <= 0)
            {
                if (isScatter) 
                {
                    llOwnerSay("START CHASE");
                    llRegionSay(-200, "CHASE_MODE");
                    isScatter = FALSE;
                    modeTimer = chaseTime;
                } 
                else 
                {
                    llOwnerSay("START SCATTER");
                    llRegionSay(-200, "SCATTER_MODE");
                    isScatter = TRUE;
                    modeTimer = scatterTime;
                }
            }
        }
       
        if (noClipCounter > 0)
        {
            noClipCounter--;
            if (noClipCounter == 0)
            {
                llRegionSay(MAZE_CHANNEL, "NO_CLIP_OFF"); 
                llOwnerSay("Notice: Ghost No-Clip expired.");
            }
        }

        if (cloakCounter > 0)
        {
            cloakCounter--;
            if (cloakCounter == 0)
            {
                llRegionSay(GHOST_CHANNEL, "CLOAK_OFF");
                llOwnerSay("Notice: Ghost Cloaking expired.");
            }
        }
        
        if (energyDrainCounter > 0)
        {
            energyDrainCounter--;
            if (energyDrainCounter == 0)
            {
                llRegionSay(PACMAN_CHANNEL, "REMOVE_ENERGY_OFF");
                llOwnerSay("Notice: Ghost Cloaking expired.");
            }
        }

        if (revertedControlsCounter > 0)
        {
            revertedControlsCounter--;
            if (revertedControlsCounter == 0)
            {
                llRegionSay(PACMAN_CHANNEL, "REVERT_CONTROLS_STOP");
                llOwnerSay("Notice: Controls revertion expired.");
            }
        }

        if (noClipCounter == 0 && cloakCounter == 0)
        {
            if (eventCooldown > 0)
            {
                eventCooldown--;
            }
            else
            {
                llOwnerSay("TRY TRIGGER EVENT");
            
                if (llFrand(100.0) > 0.0)
                {
                    TriggerRandomEvent();
                }
            }
        }
    }
}