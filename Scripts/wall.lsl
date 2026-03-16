integer CH_CONTROL = -99;
integer CH_SELECT = -98;


default 
{
    state_entry() 
    {
        llListen(CH_CONTROL, "", NULL_KEY, ""); 
    }
    
    touch_start(integer num) 
    {
        llRegionSay(CH_SELECT, (string)llGetKey());
    }

    listen(integer channel, string name, key id, string msg) 
    {
        if (channel == CH_CONTROL) 
        {
            llOwnerSay("Command returned: " + msg);
            list data = llParseString2List(msg, ["|"], []);

            if (llList2Key(data, 0) == llGetKey()) 
            {
                string command = llList2String(data, 1);
                if (command == "HIDE") 
                    llSetAlpha(0.0, ALL_SIDES);
                else if (command == "SHOW") 
                    llSetAlpha(1.0, ALL_SIDES);
                else if (command == "MOVE_LEFT") 
                    llSetPos(llGetPos() + <0, -5, 0>);
                else if (command == "MOVE_RIGHT") 
                    llSetPos(llGetPos() + <0, 5, 0>);
                else if (command == "MOVE_FRONT") 
                    llSetPos(llGetPos() + <-5, 0, 0>);
                else if (command == "MOVE_BACK") 
                    llSetPos(llGetPos() + <5, 0, 0>);
            }
        }
    }
} 