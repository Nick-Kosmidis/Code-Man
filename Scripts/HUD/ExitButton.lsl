integer PACMAN_CHANNEL = -99;
integer PELLETS_CHANNEL = 500;
default
{
    touch_start(integer total_number)
    {
        llOwnerSay("Exit the maze");
        llRegionSay(PACMAN_CHANNEL, "EXIT_MAZE");
        llRegionSay(PELLETS_CHANNEL, "RESET");
        llSetCameraParams([CAMERA_ACTIVE, FALSE]);
        llClearCameraParams();
    }
}