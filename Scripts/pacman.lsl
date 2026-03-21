default
{
    on_rez(integer param)
    {
        llRequestPermissions(llGetOwner(), PERMISSION_ATTACH);
    }

    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_ATTACH)
        {
            
            vector rotation_euler = <0, 0, 180.0>; 
            rotation_euler *= DEG_TO_RAD; 
            rotation_euler.x = 0; 
            rotation_euler.y = 0; 
            
            llSetRot(llEuler2Rot(rotation_euler));
            llAttachToAvatarTemp(ATTACH_PELVIS);
        }
    }

    attach(key id)
    {
        if (id == NULL_KEY)
        {
            llDie(); 
        }
    }
}