vector startPosition;
vector offsetPosition = <0.0, 4.0, 0.0>; 
float moveTime = 1.5;          
float stayTime = 2.0;            
integer listenHandle;

default 
{
    
    state_entry()
    {
        startPosition = llGetPos();
        // Διασφαλίζουμε ότι το αντικείμενο είναι "Keyframed" για ομαλή κίνηση
        llSetPrimitiveParams([PRIM_PHYSICS_SHAPE_TYPE, PRIM_PHYSICS_SHAPE_CONVEX]);
    }
    
    touch_start(integer num) 
    {   
        key user = llDetectedKey(0);
        llOwnerSay("Wall selected. Type /move in chat to transform terrain.");
        
        // Άνοιγμα ακρόασης μόνο για τον χρήστη που το άγγιξε
        llListenRemove(listenHandle); 
        listenHandle = llListen(0, "", user, "/move");
        
        // Timer για να κλείσει η ακρόαση αν ο παίκτης δεν γράψει τίποτα σε 10 δευτερόλεπτα
        llSetTimerEvent(10.0);
    }
    
    listen(integer channel, string name, key id, string msg)
    {
        if (llToLower(msg) == "/move")
        {
            llOwnerSay("Wall should move");
            llSetTimerEvent(0.0); // Ακύρωση του timeout timer
            llListenRemove(listenHandle);
            state moving;
        }
    }

    timer()
    {
        llListenRemove(listenHandle);
        llOwnerSay("Selection timed out.");
        llSetTimerEvent(0.0);
    }

}

state moving
{
    state_entry()
    {
        // 1. Κίνηση προς το Offset (Interpolation)
        llSetKeyframedMotion([offsetPosition, ZERO_ROTATION, moveTime], []);
        
        // 2. Αναμονή στη νέα θέση
        llSleep(moveTime + stayTime);
        
        // 3. Επιστροφή στην αρχική θέση
        llSetKeyframedMotion([-offsetPosition, ZERO_ROTATION, moveTime], []);
        
        llSleep(moveTime);
        state default;
    }
} 
