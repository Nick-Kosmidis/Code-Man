string TEMPLATE_NAME = "TemplateScript";
string SLOW_SCRIPT = "SlowScript";
integer GHOST_CHANNEL = 777;

default
{
    state_entry()
    {
        llAllowInventoryDrop(TRUE);
    }

    touch_start(integer total_number)
    {
        key user = llDetectedKey(0);
        llOwnerSay("Giving you the Slow Logic Template.");
        llGiveInventory(user, TEMPLATE_NAME);
    }

    link_message(integer sender_num, integer num, string str, key id)
    {
        if (str == "CHECK_AND_RUN")
        {
            if (llGetInventoryType(SLOW_SCRIPT) == INVENTORY_SCRIPT)
            {
                llOwnerSay("Script found! Executing player logic...");
                llMessageLinked(LINK_SET, 100, "EXECUTE_USER_LOGIC", NULL_KEY);
            }
            else
            {
                llOwnerSay("Error: 'SlowScript' not found. Please drag and drop your script onto the HUD first!");
            }
        }
        else if (str == "SLOW_ON")
        {
            llRegionSay(GHOST_CHANNEL, "SLOW");
            llOwnerSay("Broadcasted SLOW command to Ghosts.");
        }
    }

    changed(integer change)
    {
        if (change & CHANGED_INVENTORY)
        {
            if (llGetInventoryType(SLOW_SCRIPT) == INVENTORY_SCRIPT)
            {
                llOwnerSay("Success: 'SlowScript' received and stored in HUD Root!");
            }
        }
    }
}