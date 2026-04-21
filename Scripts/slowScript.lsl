// =========================================================
// GHOST POWER-UP TEMPLATE (Level 3 Logic)
// Instructions for the User:
// 1. Open this script from your Inventory.
// 2. Write your logic inside the touch_start event.
// 3. Click "Save".
// 4. Rename this script to "SlowEffect" in your Inventory.
// 5. Drag and drop the "SlowEffect" script into your HUD.
// 6. Click the "UPDATE LOGIC" button on your HUD.
// =========================================================

default
{
    // This event triggers when you click the Ghost in the Maze
    touch_start(integer total_number)
    {
        llOwnerSay("Power-up Activated: Sending SLOW signal to Ghost...");

        // STEP 1: Send a "link message" to the main Ghost script.
        // "SLOW_ON" is the command the Ghost is waiting for.
        llMessageLinked(LINK_THIS, 0, "SLOW_ON", NULL_KEY);

        // STEP 2: Set a timer for 5.0 seconds.
        // This defines how long the ghost will stay slow.
        llSetTimerEvent(5.0);
    }

    // This event triggers after the time you set in llSetTimerEvent has passed
    timer()
    {
        llOwnerSay("Power-up Expired: Ghost returning to normal speed.");

        // STEP 3: Send the "SLOW_OFF" command to reset the Ghost's speed.
        llMessageLinked(LINK_THIS, 0, "SLOW_OFF", NULL_KEY);
        
        // STEP 4: Stop the timer (set to 0.0) so it doesn't run again.
        llSetTimerEvent(0.0);
        
        // OPTIONAL: Delete this script from the Ghost to keep it clean.
        // llRemoveInventory(llGetScriptName());
    }
}