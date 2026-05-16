integer PACMAN_CHANNEL = -99;

default
{
    touch_start(integer total_number)
    {
        llOwnerSay("Exit the maze");
        llRegionSay(PACMAN_CHANNEL, "DIE_PACMAN");
        llSetCameraParams([CAMERA_ACTIVE, FALSE]);
        llClearCameraParams();
    }
}