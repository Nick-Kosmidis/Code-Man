integer GHOST_CHANNEL = 777;

default
{
    state_entry()
    {
        llSay( 0, "Script running");
    }
    
    touch_start(integer number)
    {
        llRegionSay(GHOST_CHANNEL, "DISTRACT="+llGetPos());
    }
}
