string TEMPLATE_NAME = "TemplateScript";
string SLOW_SCRIPT = "SlowScript";
string FREEZE_SCRIPT = "FreezeScript";
string DISTRACTION_SCRIPT = "DistractionScript";
string CAMOUFLAGE_SCRIPT = "CamouflageScript";
string TELEPORT_SCRIPT = "TeleportScript";
string ENERGY_SCRIPT = "EnergyScript";
string currentOwner;

integer GHOST_CHANNEL = 777;
integer PACMAN_CHANNEL = -99;
integer HUD_CHANNEL = -98;
integer canCode = FALSE;

list scripts = [SLOW_SCRIPT, FREEZE_SCRIPT, DISTRACTION_SCRIPT, CAMOUFLAGE_SCRIPT, TELEPORT_SCRIPT, ENERGY_SCRIPT];
list commands = ["EXECUTE_SLOW_LOGIC", "EXECUTE_FREEZE_LOGIC", "EXECUTE_DISTRACT_LOGIC", "EXECUTE_CAMOUFLAGE_LOGIC", "EXECUTE_TELEPORT_LOGIC", "EXECUTE_ENERGY_LOGIC"];

list ADMINS =
[
    "a33d8e61-db24-4475-88ec-b292c0de124e"
];

integer IsAdmin()
{
    return llListFindList(ADMINS, currentOwner) != -1;
}

default
{
    state_entry()
    {
        llAllowInventoryDrop(TRUE);
        llListen(HUD_CHANNEL, "", NULL_KEY, "");
        llListen(PACMAN_CHANNEL, "", NULL_KEY, "CODE_ACTIVATED");
    }

    touch_start(integer total_number)
    {
        key user = llDetectedKey(0);
        llOwnerSay("Giving you the Slow Logic Template.");
        llGiveInventory(user, TEMPLATE_NAME);
    }
    
    listen(integer channel, string name, key id, string msg)
    {
        if(msg == "CODE_ACTIVATED")
        {
            canCode = TRUE;
            llOwnerSay("Power-Up Activated: Now you can code");
        }
        else if(llSubStringIndex(msg, "ENERGY_APPROVED=") == 0)
        {
            string approvedCmd = llGetSubString(msg, 16, -1);
            llRegionSay(GHOST_CHANNEL, approvedCmd);
            llOwnerSay("Broadcasted " + approvedCmd + " to Ghosts.");
        }
    }

    link_message(integer sender_num, integer num, string str, key id)
    {
        currentOwner = (string)llGetOwner();
        
        if(!IsAdmin() && !canCode)
        {
            llOwnerSay("You dont have the ability to code");
            return;
        }
        else
        {
            llOwnerSay("You can code");
        }

        if (str == "CHECK_AND_RUN")
        {
            integer length = llGetListLength(scripts);
            integer index = (integer)llFrand(length);
            
            string selectedScript = llList2String(scripts, index);
            string selectedCommand = llList2String(commands, index);
            
            if (llGetInventoryType(selectedScript) == INVENTORY_SCRIPT)
            {
                llOwnerSay("Random selection: " + selectedScript + " found! Executing player logic...");
                llSetScriptState(selectedScript, TRUE); 
                llMessageLinked(LINK_SET, 100, selectedCommand, NULL_KEY);
            }
            else
            {
                llOwnerSay("Error: Selected script not found. Please drag and drop your script onto the HUD first!");
            }
        }
        else if (str == "CHECK_AND_RUN_SLOW")
        {
            if (llGetInventoryType(SLOW_SCRIPT) == INVENTORY_SCRIPT)
            {
                llOwnerSay("SlowScript found! Executing player logic...");
                llSetScriptState(SLOW_SCRIPT, TRUE); 
                llMessageLinked(LINK_SET, 100, "EXECUTE_SLOW_LOGIC", NULL_KEY);
            }
            else
            {
                llOwnerSay("Error: 'SlowScript' not found. Please drag and drop your script onto the HUD first!");
            }
        }
        else if (str == "CHECK_AND_RUN_FREEZE")
        {
            if (llGetInventoryType(FREEZE_SCRIPT) == INVENTORY_SCRIPT)
            {
                llOwnerSay("FreezeScript found! Executing player logic...");
                llSetScriptState(FREEZE_SCRIPT, TRUE); 
                llMessageLinked(LINK_SET, 100, "EXECUTE_FREEZE_LOGIC", NULL_KEY);
            }
            else
            {
                llOwnerSay("Error: 'Freeze' not found. Please drag and drop your script onto the HUD first!");
            }
        }
        else if (str == "CHECK_AND_RUN_DISTRACT")
        {
            if (llGetInventoryType(DISTRACTION_SCRIPT) == INVENTORY_SCRIPT)
            {
                llOwnerSay("DistractScript found! Executing player logic...");
                llSetScriptState(DISTRACTION_SCRIPT, TRUE); 
                llMessageLinked(LINK_SET, 100, "EXECUTE_DISTRACT_LOGIC", NULL_KEY);
            }
            else
            {
                llOwnerSay("Error: 'DistractionScript' not found. Please drag and drop your script onto the HUD first!");
            }
        }
        else if (str == "CHECK_AND_RUN_CAMOUFLAGE")
        {
            if (llGetInventoryType(CAMOUFLAGE_SCRIPT) == INVENTORY_SCRIPT)
            {
                llOwnerSay("CamouflageScript found! Executing player logic...");
                llSetScriptState(CAMOUFLAGE_SCRIPT, TRUE); 
                llMessageLinked(LINK_SET, 100, "EXECUTE_CAMOUFLAGE_LOGIC", NULL_KEY);
            }
            else
            {
                llOwnerSay("Error: 'CamouflageScript' not found. Please drag and drop your script onto the HUD first!");
            }
        }
        else if (str == "CHECK_AND_RUN_TELEPORT")
        {
            if (llGetInventoryType(TELEPORT_SCRIPT) == INVENTORY_SCRIPT)
            {
                llOwnerSay("TeleportScript found! Executing player logic...");
                llSetScriptState(TELEPORT_SCRIPT, TRUE); 
                llMessageLinked(LINK_SET, 100, "EXECUTE_TELEPORT_LOGIC", NULL_KEY);
            }
            else
            {
                llOwnerSay("Error: 'TeleportScript' not found. Please drag and drop your script onto the HUD first!");
            }
        }
        else if (str == "CHECK_AND_RUN_ENERGY")
        {
            if (llGetInventoryType(ENERGY_SCRIPT) == INVENTORY_SCRIPT)
            {
                llOwnerSay("EnergyScript found! Executing player logic...");
                llSetScriptState(ENERGY_SCRIPT, TRUE); 
                llMessageLinked(LINK_SET, 100, "EXECUTE_ENERGY_LOGIC", NULL_KEY);
            }
            else
            {
                llOwnerSay("Error: 'EnergyScript' not found. Please drag and drop your script onto the HUD first!");
            }
        }
        else 
        {
            string clean_str = str;
            
            if (llSubStringIndex(clean_str, "=") != -1)
            {
                list parts = llParseString2List(clean_str, ["="], []);
                
                string command = llStringTrim(llList2String(parts, 0), STRING_TRIM);
                string value = llStringTrim(llList2String(parts, 1), STRING_TRIM);
                
                if (command == "ENERGY_REFILL")
                {
                    llRegionSay(PACMAN_CHANNEL, clean_str);
                }
                else if (llSubStringIndex(clean_str, "CAMOUFLAGE") == 0)
                {
                    llRegionSay(PACMAN_CHANNEL, "CHECK_ENERGY=25:" + clean_str);
                }
                else if (llSubStringIndex(clean_str, "TELEPORT") == 0)
                {
                    llRegionSay(PACMAN_CHANNEL, "CHECK_ENERGY=15:" + clean_str);
                }
                else if (command == "SLOW")
                {
                    if((float)value < 0)
                    {
                        llOwnerSay("Speed cannot be negative"); 
                    }
                    llRegionSay(PACMAN_CHANNEL, "CHECK_ENERGY=10:SLOW_" + value);
                }
                else if (command == "FREEZE")
                {
                    if((float)value > 10) value = "10";
                    llRegionSay(PACMAN_CHANNEL, "CHECK_ENERGY=20:FREEZE_" + value);
                }
                else if(command == "DISTRACT")
                {
                    llRegionSay(PACMAN_CHANNEL, "CHECK_ENERGY=5:DISTRACT=" + value);
                }
            }
            else
            {
                if (clean_str == "SLOW")
                    llRegionSay(PACMAN_CHANNEL, "CHECK_ENERGY=10:SLOW");
                else if (clean_str == "FREEZE")
                    llRegionSay(PACMAN_CHANNEL, "CHECK_ENERGY=20:FREEZE");
                else if (clean_str == "DISTRACT")
                    llRegionSay(PACMAN_CHANNEL, "CHECK_ENERGY=5:DISTRACT");
                else if (clean_str == "CAMOUFLAGE")
                    llRegionSay(PACMAN_CHANNEL, "CHECK_ENERGY=25:CAMOUFLAGE");
                else if (clean_str == "TELEPORT")
                    llRegionSay(PACMAN_CHANNEL, "CHECK_ENERGY=15:TELEPORT");
                else if (clean_str == "ENERGY_REFILL")
                    llRegionSay(PACMAN_CHANNEL, "ENERGY_REFILL");
            }
        }
    }

    changed(integer change)
    {
        if (change & CHANGED_INVENTORY)
        {
            if (llGetInventoryType(SLOW_SCRIPT) == INVENTORY_SCRIPT) 
                llSetScriptState(SLOW_SCRIPT, TRUE);
                
            if (llGetInventoryType(FREEZE_SCRIPT) == INVENTORY_SCRIPT) 
                llSetScriptState(FREEZE_SCRIPT, TRUE); 
                
            if (llGetInventoryType(DISTRACTION_SCRIPT) == INVENTORY_SCRIPT)  
                llSetScriptState(DISTRACTION_SCRIPT, TRUE); 
                
            if (llGetInventoryType(CAMOUFLAGE_SCRIPT) == INVENTORY_SCRIPT) 
                llSetScriptState(CAMOUFLAGE_SCRIPT, TRUE); 
                
            if (llGetInventoryType(TELEPORT_SCRIPT) == INVENTORY_SCRIPT) 
                llSetScriptState(TELEPORT_SCRIPT, TRUE);
                
            if (llGetInventoryType(ENERGY_SCRIPT) == INVENTORY_SCRIPT) 
                llSetScriptState(ENERGY_SCRIPT, TRUE); 
        }
    }
}