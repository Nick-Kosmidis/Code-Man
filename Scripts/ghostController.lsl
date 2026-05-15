integer scatterTime = 7;
integer chaseTime = 20;
integer isScatter = TRUE;
integer gameActive = FALSE;

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
            llOwnerSay("Game Logic Started: SCATTER");
            llRegionSay(-200, "SCATTER_MODE");
            llSetTimerEvent(scatterTime);
        }
        else if (msg == "STOP_GAME")
        {
            gameActive = FALSE;
            llSetTimerEvent(0); 
            llOwnerSay("Game Logic Stopped.");
        }
    }

    timer()
    {
        if (!gameActive) return;

        if (isScatter) 
        {
            llOwnerSay("Switching to: CHASE");
            llRegionSay(-200, "CHASE_MODE");
            isScatter = FALSE;
            llSetTimerEvent(chaseTime);
        } 
        else 
        {
            llOwnerSay("Switching to: SCATTER");
            llRegionSay(-200, "SCATTER_MODE");
            isScatter = TRUE;
            llSetTimerEvent(scatterTime);
        }
    }
}