vector startPos;
vector offset = <0.0, 0.0, 2.5>;
float moveTime = 0.75;         

default
{
    state_entry()
    {
        startPos = llGetPos();
        llSetLinkPrimitiveParamsFast(LINK_SET, [
            PRIM_PHYSICS_SHAPE_TYPE, PRIM_PHYSICS_SHAPE_CONVEX,
            PRIM_COLOR, ALL_SIDES, <0.0, 1.0, 0.0>, 0.4
        ]);
        llSetObjectName("GhostBarrier");
        llListen(-700, "", NULL_KEY, "");
    }
    
    listen(integer channel, string name, key id, string msg)
    {
        if (msg == "ACTIVATE")
        {
            state active; 
        }
    }
}

state active
{
    state_entry()
    {
        llSetKeyframedMotion([offset, ZERO_ROTATION, moveTime], []);
        llSleep(moveTime);
        
        llSleep(10.0);
        
        llSetObjectName("PacmanBarrier");
        llSetLinkPrimitiveParamsFast(LINK_SET, [
            PRIM_COLOR, ALL_SIDES, <1.0, 0.0, 0.0>, 0.8
        ]);
        
        llSleep(10.0);
        
        llSetKeyframedMotion([-offset, ZERO_ROTATION, moveTime], []);
        llSleep(moveTime);
        
        state default;
    }
}