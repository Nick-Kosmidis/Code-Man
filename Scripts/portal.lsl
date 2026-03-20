vector mazeEntry = <128, 71, 22>;
vector portalEntry = <128, 50, 22>;
integer shouldRestore = TRUE;

default
{
    touch_start(integer num)
    {
        key user = llDetectedKey(0);
        llRequestPermissions(user, PERMISSION_CONTROL_CAMERA | PERMISSION_TELEPORT);
        shouldRestore = !shouldRestore;
    }
    
    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_CONTROL_CAMERA)
        {
            if(shouldRestore)
            {
                llTeleportAgent(llGetPermissionsKey(), "", mazeEntry, <0,0,0>);

                llClearCameraParams(); 
                llSetCameraParams([
                    CAMERA_ACTIVE, 1,               
                    CAMERA_FOCUS_LOCKED, FALSE,       
                    CAMERA_POSITION_LOCKED, FALSE,    
                    CAMERA_PITCH, 90.0,             
                    CAMERA_DISTANCE, 5.0,             
                    CAMERA_BEHINDNESS_ANGLE, 0.0,
                    CAMERA_POSITION_LAG, 0.0,         
                    CAMERA_FOCUS_LAG, 0.0             
                ]);
                
                llOwnerSay("Top-down mode: ON");
            }
            else
            {
                llClearCameraParams();
                llTeleportAgent(llGetPermissionsKey(), "", portalEntry, <0,0,0>);
                llOwnerSay("Top-down mode: ON");
            }
        }
    }
}