vector startPos;
vector offset = <0.0, 4.0, 0.0>;
float moveTime = 1.5;            
float stayTime = 2.0; 

default
{
    state_entry()
    {
        startPos = llGetPos();
        llSetPrimitiveParams([PRIM_PHYSICS_SHAPE_TYPE, PRIM_PHYSICS_SHAPE_CONVEX]);
    }

    touch_start(integer num)
    {
        state moving;
    }
}



state moving
{
    state_entry()
    {
       
        llSetKeyframedMotion([offset, ZERO_ROTATION, moveTime], []);
        
        llSleep(stayTime);
        
        llSetKeyframedMotion([-offset, ZERO_ROTATION, moveTime], []);
        
        llSleep(moveTime);
        state default;
    }
}