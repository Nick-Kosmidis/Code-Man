default
{
    on_rez(integer start_param)
    {
        llRequestPermissions(llGetOwner(), PERMISSION_ATTACH);
    }

    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_ATTACH)
        {
            llAttachToAvatar(ATTACH_HUD_BOTTOM_LEFT);
        }
    }
}