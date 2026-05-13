vector mazeEntry = <128, 110, 21.5>; 
string meshName = "Pacman"; 
string hudName = "CodemanHUD";
integer inMaze = FALSE;
vector cameraPosition = <128, 128, 64>;

default
{
    touch_start(integer num)
    {
        key user = llDetectedKey(0);
        llRequestPermissions(user, PERMISSION_CONTROL_CAMERA);
        llOwnerSay(llGetRot());
    }
    
    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_CONTROL_CAMERA)
        {
            inMaze = !inMaze;
            key user = llGetPermissionsKey();
            
            if(inMaze)
            {
                if (llGetInventoryType(meshName) == INVENTORY_OBJECT)
                {
                    llOwnerSay("Spawning Pacman...");
                    llRezObject(meshName, mazeEntry, ZERO_VECTOR, ZERO_ROTATION, 0);
                }
                else
                {
                    llOwnerSay("Error: '" + meshName + "' is not contained in the Portal's Content folder");
                }
                
                if (llGetInventoryType(hudName) == INVENTORY_OBJECT)
                    llGiveInventory(user, hudName);

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
                
                llOwnerSay("Returning to Lobby. Game Over. Ghosts resetting...");
            }
        }
    }
}