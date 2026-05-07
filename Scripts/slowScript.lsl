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
    touch_start(integer total_number)
    {
        llOwnerSay("Power-up Activated: Sending SLOW signal to Ghost...");
        llMessageLinked(LINK_THIS, 0, "SLOW_ON", NULL_KEY);
    }
}