vector mazeEntry = <128, 71, 22>;
vector portalEntry = <128, 50, 22>;
integer inMaze = FALSE;
string meshName = "Pacman"; 

default
{
    touch_start(integer num)
    {
        key user = llDetectedKey(0);
        llRequestPermissions(user, PERMISSION_CONTROL_CAMERA | PERMISSION_TELEPORT);
    }
    
    run_time_permissions(integer perm)
    {
        key user = llGetPermissionsKey();
        if (perm & PERMISSION_CONTROL_CAMERA)
        {
            inMaze = !inMaze;
            
            if(inMaze)
            {
                llRezObject(meshName, llGetPos() + <0,0,1.0>, ZERO_VECTOR, llEuler2Rot(<0, 0, 180>), 0);
                
                llTeleportAgent(user, "", mazeEntry, <0,0,0>);

                llClearCameraParams(); 
                llSetCameraParams([
                    CAMERA_ACTIVE, 1,               
                    CAMERA_PITCH, 90.0,        
                    CAMERA_DISTANCE, 15.0,            
                    CAMERA_FOCUS_LOCKED, FALSE,       
                    CAMERA_POSITION_LOCKED, FALSE,    
                    CAMERA_BEHINDNESS_ANGLE, 0.0,
                    CAMERA_POSITION_LAG, 0.0,         
                    CAMERA_FOCUS_LAG, 0.0             
                ]);
            }
            else
            {
                llSetCameraParams([CAMERA_ACTIVE, 0]); 
                llClearCameraParams();
                
                llTeleportAgent(user, "", portalEntry, <0,0,0>);
            }
        }
    }
}