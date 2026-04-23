vector mazeEntry = <128, 111, 22>;
vector portalEntry = <128, 100, 21>;
vector cameraPosition = <128, 120, 57>; // Ύψος για την κάμερα
integer inMaze = FALSE;
string meshName = "Pacman"; 

string hudName = "CodemanHUD"; 
//string templateName = "SlowEffect_Template";

default
{
    touch_start(integer num)
    {
        key user = llDetectedKey(0);
        
        llRequestPermissions(user, PERMISSION_CONTROL_CAMERA);
    }
    
    run_time_permissions(integer perm)
    {
        key user = llGetPermissionsKey();
        
        if (perm & (PERMISSION_CONTROL_CAMERA))
        {
            inMaze = !inMaze;
            
            if(inMaze)
            {
                llOwnerSay("Entering Maze...");
                
                llGiveInventory(user, hudName);
                //llGiveInventory(user, templateName);
                llOwnerSay("Check your inventory for 'Code-Man HUD' and the Script Template.");
                
                llRezObject(meshName, mazeEntry, ZERO_VECTOR, ZERO_ROTATION, 0);

                llClearCameraParams(); 
                llSetCameraParams([
                    CAMERA_ACTIVE, TRUE,
                    CAMERA_FOCUS_LOCKED, TRUE,
                    CAMERA_POSITION_LOCKED, TRUE,
                    CAMERA_POSITION, cameraPosition, 
                    CAMERA_FOCUS, <128.0, 128.0, 0.0> + (<0,1,0> * llGetRot()), 
                    CAMERA_POSITION_LAG, 0.0,
                    CAMERA_FOCUS_LAG, 0.0,
                    CAMERA_DISTANCE, 0.0
                ]);
            }
            else
            {
                llRegionSay(-99, "DIE_PACMAN");
                llSetCameraParams([CAMERA_ACTIVE, FALSE]); 
                llClearCameraParams();
                llOwnerSay("Returning to Lobby.");
            }
        }
    }
}