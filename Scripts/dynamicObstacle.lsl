vector initialPosition = <132.0, 116.0, 22.0>;
vector positionToMove = <132.0, 114.0, 22.0>;

vector offset; 
float moveTime = 1.0; 
float stayTime = 20.0; 

integer movementStep = 0;

MakeObstacleTransparent()
{
    llSetLinkPrimitiveParamsFast(LINK_SET, [
            PRIM_PHYSICS_SHAPE_TYPE, PRIM_PHYSICS_SHAPE_CONVEX,
            PRIM_COLOR, ALL_SIDES, <0.0, 0.0, 1.0>, 0.4
        ]);
    llSetObjectName("TransparentObstacle");
}

ResetObstacle()
{
    llSetLinkPrimitiveParamsFast(LINK_SET, [
            PRIM_PHYSICS_SHAPE_TYPE, PRIM_PHYSICS_SHAPE_CONVEX,
            PRIM_COLOR, ALL_SIDES, <0.0, 0.0, 1.0>, 1.0
        ]);
    llSetObjectName("Obstacle");
}

ResetPosition()
{
   
    llSetKeyframedMotion([], []); 
    llSetPos(initialPosition);
}

default
{
    state_entry()
    {
        llSetPrimitiveParams([PRIM_PHYSICS, FALSE]);
        llSetPos(initialPosition);
        llListen(-600, "", NULL_KEY, "");
        offset = positionToMove - initialPosition; 
    }
    
    listen(integer channel, string name, key id, string msg)
    {
        if(msg == "NO_CLIP_ON")
        {
            MakeObstacleTransparent();
        }
        else if (msg == "NO_CLIP_OFF")
        {
            ResetObstacle();
        }
        else if (msg == "CHANGE_POSITION")
        {
            state moving;
        }
        else if (msg == "RESET_POSITION")
        {
            ResetPosition();
        }
    }
}

state moving
{
    state_entry()
    {
        
        llListen(-600, "", NULL_KEY, "");

        llSetKeyframedMotion([offset, ZERO_ROTATION, moveTime], []);

        movementStep = 1;
        llSetTimerEvent(moveTime);
    }

    timer()
    {
        if (movementStep == 1)
        {
            movementStep = 2;
            llSetTimerEvent(stayTime);
        }
        else if (movementStep == 2)
        {
            llSetKeyframedMotion([-offset, ZERO_ROTATION, moveTime], []);
            movementStep = 3;
            llSetTimerEvent(moveTime);
        }
        else if (movementStep == 3)
        {
            llSetTimerEvent(0.0);
            state default;
        }
    }
    
    listen(integer channel, string name, key id, string msg)
    {
        if(msg == "NO_CLIP_ON")
        {
            MakeObstacleTransparent();
        }
        else if (msg == "NO_CLIP_OFF")
        {
            ResetObstacle();
        }
        else if (msg == "RESET_POSITION")
        {
            llSetTimerEvent(0.0);
            ResetPosition();
            state default; 
        }
    }
    
    state_exit()
    {
        llSetTimerEvent(0.0);
    }
}