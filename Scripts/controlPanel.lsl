string TEMPLATE_NAME = "TemplateScript";
string PLAYER_SCRIPT = "ExecScript";          
integer GHOST_PIN = 12345;                  

default
{
    touch_start(integer total_number)
    {
        string clicked = llGetLinkName(llDetectedLinkNumber(0));
        key user = llDetectedKey(0);

        if (clicked == "TemplateButton")
        {
            llOwnerSay("Giving you the Slow Logic Template. Edit it in your inventory!");
            llGiveInventory(user, TEMPLATE_NAME);
        }
        else if (clicked == "UpdateButton")
        {
            if (llGetInventoryType(PLAYER_SCRIPT) == INVENTORY_SCRIPT)
            {
                llOwnerSay("Searching for Ghosts to update...");
                llSensor("Ghost", NULL_KEY, PASSIVE | SCRIPTED, 96, PI);
            }
            else
            {
                llOwnerSay("Error: Please rename your script to '" + PLAYER_SCRIPT + "' and drag it into the HUD's Content first!");
            }
        }
    }

    sensor(integer num_detected)
    {
        integer i;
        for (i = 0; i < num_detected; i++)
        {
            key ghost_id = llDetectedKey(i);
            llRemoteLoadScriptPin(ghost_id, PLAYER_SCRIPT, GHOST_PIN, TRUE, 1);
        }
        llOwnerSay("Successfully injected logic into " + (string)num_detected + " Ghosts.");
    }

    no_sensor()
    {
        llOwnerSay("No Ghosts found nearby. Move closer!");
    }
}