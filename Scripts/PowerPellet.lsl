integer isEatean = FALSE;

default
{
    state_entry()
    {
        llListen(-500, "", NULL_KEY, "");
        llCollisionFilter("", NULL_KEY, TRUE);
    }
    
    listen(integer c, string n, key id, string msg)
    {
        if(msg == "EATEN" && !isEatean)
        {
            llSetAlpha(0.0, ALL_SIDES);
            isEatean = TRUE; 
            
            llCollisionFilter("", NULL_KEY, FALSE);
            llRegionSay(-300, "GHOST_FRIGHT");    
            
            llSetTimerEvent(6.0);
        }
    }

    timer()
    {
        llRegionSay(-300, "GHOST_FRIGHT_STOP");
        
        llSetAlpha(1.0, ALL_SIDES);
        llCollisionFilter("", NULL_KEY, TRUE);
        
        isEatean = FALSE; 
        llSetTimerEvent(0.0);
    }
}