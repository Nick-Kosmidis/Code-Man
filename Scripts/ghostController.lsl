integer scatterTime = 7;
integer chaseTime = 20;
integer isScatter = TRUE;
integer gameActive = FALSE;

integer modeTimer = 0;   
integer noClipCounter = 0; 
integer cloakCounter = 0;
integer energyDrainCounter = 0;
integer eventCooldown = 0;
    
integer GHOST_CHANNEL = 777;
integer MAZE_CHANNEL = -600;
integer PACMAN_CHANNEL = -99;
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

    float dice = llFrand(100.0);
    dice = 60.0;
    if (dice < 25.0)
    {
        noClipCounter = 15; 
        llRegionSay(MAZE_CHANNEL, "NO_CLIP_ON"); 
        llOwnerSay("[RANDOM EVENT] Ghosts enabled No-Clip! Walls are now phase-shifted.");
    }
    else if (dice < 50.0)
    {
        energyDrainCounter = 15; 
        llRegionSay(PACMAN_CHANNEL, "REMOVE_ENERGY=5");  
        llOwnerSay("[RANDOM EVENT] Pacman's energy drains!!!");
    }
    else if (dice < 75.0)
    { 
        llRegionSay(MAZE_CHANNEL, "CHANGE_POSITION");  
        llOwnerSay("[RANDOM EVENT] Terrain Teraforming!!!");
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