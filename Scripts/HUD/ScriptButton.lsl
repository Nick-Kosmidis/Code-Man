string TEMPLATE_NAME = "TemplateScript";
string SLOW_SCRIPT = "SlowScript";
string FREEZE_SCRIPT = "FreezeScript";
string DISTRACTION_SCRIPT = "DistractionScript";
string currentOwner;
integer GHOST_CHANNEL = 777;
integer canCode = FALSE;

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
        llListen(-99, "", NULL_KEY, "CODE_ACTIVATED");
    }

    touch_start(integer total_number)
    {
        key user = llDetectedKey(0);
        llOwnerSay("Giving you the Slow Logic Template.");
        llGiveInventory(user, TEMPLATE_NAME);
    }
    
    listen(integer channel, string name, key id, string msg)
    {
        canCode = TRUE;

        llOwnerSay("Power-Up Activated: Now you can code");
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
            if (llGetInventoryType(SLOW_SCRIPT) == INVENTORY_SCRIPT)
            {
                llOwnerSay("Script found! Executing player logic...");
                llSetScriptState(SLOW_SCRIPT, TRUE); 
                llMessageLinked(LINK_SET, 100, "EXECUTE_USER_LOGIC", NULL_KEY);
            }
            else
            {
                llOwnerSay("Error: 'SlowScript' not found. Please drag and drop your script onto the HUD first!");
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
        else 
        {
            string clean_str = str;
            
            if (llSubStringIndex(clean_str, "=") != -1)
            {
                list parts = llParseString2List(clean_str, ["="], []);
                
                string command = llStringTrim(llList2String(parts, 0), STRING_TRIM);
                string value = llStringTrim(llList2String(parts, 1), STRING_TRIM);
                
                if (command == "SLOW")
                {
                    if((float)value < 0)
                    {
                        llOwnerSay("Speed cannot be negative"); 
                    }
                    llRegionSay(GHOST_CHANNEL, "SLOW_" + value);
                    llOwnerSay("Broadcasted SLOW for " + value + " seconds to Ghosts.");
                }
                else if (command == "FREEZE")
                {
                    if((float)value > 10)
                    {
                        llOwnerSay("Max freeze duration is 10 seconds");
                        llRegionSay(GHOST_CHANNEL, "FREEZE_10");
                    }
                    else
                    {
                        llRegionSay(GHOST_CHANNEL, "FREEZE_" + value);
                        llOwnerSay("Broadcasted FREEZE for " + value + " seconds to Ghosts.");   
                    }
                }
                else if(command == "DISTRACT")
                {
                    llRegionSay(GHOST_CHANNEL, clean_str);
                    llOwnerSay("Broadcasted DISTRACT Target Point: " + value + " to Ghosts.");
                }
            }
            else
            {
                if (clean_str == "SLOW")
                {
                    llRegionSay(GHOST_CHANNEL, "SLOW");
                    llOwnerSay("Broadcasted default SLOW command to Ghosts.");
                }
                else if (clean_str == "FREEZE")
                {
                    llRegionSay(GHOST_CHANNEL, "FREEZE");
                    llOwnerSay("Broadcasted default FREEZE command to Ghosts.");
                }
                else if(clean_str == "DISTRACT")
                {
                    llRegionSay(GHOST_CHANNEL, "DISTRACT");
                    llOwnerSay("Broadcasted Scatter DISTRACT command to Ghosts.");
                }
            }
        }
    }

    changed(integer change)
    {
        if (change & CHANGED_INVENTORY)
        {
            if (llGetInventoryType(SLOW_SCRIPT) == INVENTORY_SCRIPT)
            {
                llOwnerSay("Success: 'SlowScript' received and stored in HUD Root!");
                llSetScriptState(SLOW_SCRIPT, TRUE);
            }
            if (llGetInventoryType(FREEZE_SCRIPT) == INVENTORY_SCRIPT)
            {
                llOwnerSay("Success: 'FreezeScript' received and stored in HUD Root!");
                llSetScriptState(FREEZE_SCRIPT, TRUE);
            }
            if (llGetInventoryType(DISTRACTION_SCRIPT) == INVENTORY_SCRIPT)
            {
                llOwnerSay("Success: 'DistractionScript' received and stored in HUD Root!");
                llSetScriptState(DISTRACTION_SCRIPT, TRUE);
            }
        }
    }
}