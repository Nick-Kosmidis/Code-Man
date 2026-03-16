key currentTarget = NULL_KEY;
integer CH_CONTROL = -99;
integer CH_SELECT = -98;

SendAction(string action) 
{
    if (currentTarget != NULL_KEY) 
    {
        llRegionSay(CH_CONTROL, (string)currentTarget + "|" + action);
    }
}

LibMove(string direction, float amount)
{ 
    SendAction("MOVE_" + direction + "|" + (string)amount); 
}
LibHide()   { SendAction("HIDE"); }
LibShow()   { SendAction("SHOW"); }

default 
{
    state_entry() 
    {
        llListen(CH_SELECT, "", NULL_KEY, ""); 
        llListen(0, "", llGetOwner(), ""); 
    }

    listen(integer channel, string name, key id, string msg) 
    {
        
        if (channel == CH_SELECT) 
        {
            currentTarget = (key)msg;
            llOwnerSay("Selected object: " + (string)currentTarget);
        }
       
        if (channel == 0 && currentTarget != NULL_KEY) 
        {
            llOwnerSay("Executing: " + msg);
            
            list parts = llParseString2List(msg, [" "], []);
            string mainCommand = llList2String(parts, 0);
            string secondaryCommand = llList2String(parts, 1);    
            string value = llList2String(parts, 2); 
            
            
            if (mainCommand == "/move") 
            {
                float distance = 5.0;
                if(value != "") 
                    distance = (float)value;
                LibMove(llToUpper(secondaryCommand), distance);
            }
            else if (msg == "/hide")        
                LibHide();
            else if (msg == "/show")   
                LibShow();
        }

        if (currentTarget == NULL_KEY) 
        {
            llOwnerSay("You have not selected any object!");
            return;
        }
    }
}