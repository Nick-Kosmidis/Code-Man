// =========================================================
// INSTRUCTIONS FOR THE USER:
// 1. Open this script from your Inventory.
// 2. Go to the link_message event below.
// 3. Write an 'if' statement to check if 'str' equals "EXECUTE_USER_LOGIC".
// 4. Inside that 'if' statement, write your custom logic (e.g., playsounds, effects).
// 5. Click "Save" and close the script window.
// 6. Rename this script to "SlowScript" in your Inventory.
// 7. Simply drag and drop the script ANYWHERE onto your HUD.
// 8. Click the "RunButton" on your HUD to execute your logic!
// =========================================================

float duration = 100;

default
{
    link_message(integer sender_num, integer num, string str, key id)
    {
        if (str == "EXECUTE_FREEZE_LOGIC")
        {
            llOwnerSay("User Script: Custom Logic Activated!");
            llMessageLinked(LINK_SET, 0, "FREEZE=" + duration, NULL_KEY);
        }
    }
}