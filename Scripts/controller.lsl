key currentTarget = NULL_KEY;
integer CH_CONTROL = -99;
integer CH_SELECT = -98;

// --- LIBRARY FUNCTIONS ---
// Κάθε συνάρτηση αναλαμβάνει μία συγκεκριμένη εργασία
SendAction(string action) {
    if (currentTarget != NULL_KEY) {
        llRegionSay(CH_CONTROL, (string)currentTarget + "|" + action);
    }
}

LibHide()        { SendAction("HIDE"); }
LibShow()        { SendAction("SHOW"); }
LibMove(){ SendAction("MOVE"); }

// --- MAIN LOGIC ---
default 
{
    state_entry() 
    {
        llListen(0, "", llGetOwner(), ""); 
        llListen(CH_SELECT, "", NULL_KEY, ""); 
    }

    listen(integer channel, string name, key id, string msg) 
    {
        // 1. Διαχείριση Επιλογής
        if (channel == CH_SELECT) 
        {
            currentTarget = (key)msg;
            llOwnerSay("Locked on: " + (string)currentTarget);
            return; // Σταματάμε εδώ, δεν χρειάζεται να ελέγξουμε commands
        }

        // 2. Διαχείριση Εντολών
        if (channel == 0) 
        {
            if (currentTarget == NULL_KEY) {
                llOwnerSay("You have not selected any object!");
                return;
            }

            llOwnerSay("Executing: " + msg);
            
            // Mapping εντολών σε συναρτήσεις (Library Calls)
            if (msg == "/hide")         LibHide();
            else if (msg == "/show")    LibShow();
            else if (msg == "/move")    LibMove();

        }
    }
}