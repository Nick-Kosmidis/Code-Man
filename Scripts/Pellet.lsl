integer isEaten = FALSE;

default
{
    state_entry()
    {
        llListen(-500, "", NULL_KEY, "");
        llCollisionFilter("", NULL_KEY, TRUE);
    }
    
    listen(integer c, string n, key id, string msg)
    {
        if(msg == "EATEN" && !isEaten)
        {
            llSetAlpha(0.0, ALL_SIDES);
            isEaten = TRUE; 
            
            llCollisionFilter("", NULL_KEY, FALSE);
        }
        else if(msg == "RESET" && isEaten)
        {
            llSetAlpha(1.0, ALL_SIDES);
            isEaten = FALSE;
        }
    }
}