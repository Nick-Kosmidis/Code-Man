default
{
    state_entry()
    {
        llListen(0, "", llGetOwner(), "");
    }

    changed(integer change)
    {
        if (change & CHANGED_OWNER)
            llResetScript();
    }

    listen(integer channel, string name, key id, string msg)
    {
        string lower_msg = llToLower(llStringTrim(msg, STRING_TRIM));

        if (lower_msg == "help" || lower_msg == "/help")
        {
            llOwnerSay("\n=== HUD HELP SYSTEM ===");
            llOwnerSay("Type one of the following commands in local chat to view instructions:");
            llOwnerSay(" 'help framework': Codeman-Script Overview & Software Architecture.");
            llOwnerSay(" 'help buttons'  : Guide for Custom HUD Buttons configuration.");
            llOwnerSay(" 'help script'   : Guide for User Script conditions and structure.");
            llOwnerSay(" 'help messages' : Guide for output messages (llMessageLinked) within User Scripts.");
            llOwnerSay(" 'help powerups' : Guide for all Power-up variations & use cases.");
            llOwnerSay("=============================");
        }
        
        else if (lower_msg == "help framework")
        {
            llOwnerSay("\n=== CODEMAN-SCRIPT FRAMEWORK OVERVIEW ===");
            llOwnerSay("Codeman-Script is a programmable scripting framework for the Pacman environment allowing custom scripts to dynamically modify mechanics, ghost behavior, and abilities. Each script consumes energy validated by Pacman.");
            
            llOwnerSay("\n🏢 SOFTWARE ARCHITECTURE (3 Primary Entities):");
            llOwnerSay("1. HUD (Code Editor Interface):\n" +
                       "• Responsibilities: Executing player scripts, validating availability, broadcasting requests, managing templates, triggering effects.\n" +
                       "• Note: Does not directly modify game state; sends requests to components.");
                       
            llOwnerSay("2. PACMAN CONTROLLER:\n" +
                       "• Responsibilities: Movement, Teleportation, Camouflage, Energy management, Script authorization.\n" +
                       "• Note: Authoritative source of truth. Validates energy before any action executes.");
                       
            llOwnerSay("3. GHOST CONTROLLERS:\n" +
                       "• Responsibilities: Pathfinding, Chase/Scatter behavior, Script-driven state modifications.\n" +
                       "• Commands received: SLOW, FREEZE, DISTRACT.");
                       
            llOwnerSay("\n ADVANCED SCRIPT COMBINATIONS:");
            llOwnerSay("• Freeze + Teleport: Freeze nearby ghosts and instantly relocate to safety.\n" +
                       "• Camouflage + Teleport: Blend into groups and relocate before the effect expires.\n" +
                       "• Energy Refill + Any Ability: Recover energy reserves to chain advanced tactics.");
                       
            llOwnerSay("\n CUSTOM LOGIC DEVELOPMENT:");
            llOwnerSay("Designed for user-created logic beyond primitives. Example: A loop continuously generating random distraction vectors causes ghosts to exhibit erratic and confused movement patterns, producing complex emergent behaviors.");
            llOwnerSay("=============================");
        }
        
        else if (lower_msg == "help buttons")
        {
            llOwnerSay("\n=== CUSTOM BUTTONS CONFIGURATION ===");
            llOwnerSay("If you are creating custom buttons for your HUD, your button script must send a llMessageLinked to the Root script using one of these exact strings:");
            llOwnerSay("• 'CHECK_AND_RUN' : Selects and executes a random script from your inventory.");
            llOwnerSay("• 'CHECK_AND_RUN_SLOW' : Executes the SlowScript.");
            llOwnerSay("• 'CHECK_AND_RUN_FREEZE' : Executes the FreezeScript.");
            llOwnerSay("• 'CHECK_AND_RUN_DISTRACT' : Executes the DistractionScript.");
            llOwnerSay("• 'CHECK_AND_RUN_CAMOUFLAGE' : Executes the CamouflageScript.");
            llOwnerSay("• 'CHECK_AND_RUN_TELEPORT' : Executes the TeleportScript.");
            llOwnerSay("• 'CHECK_AND_RUN_ENERGY' : Executes the EnergyScript.");
            llOwnerSay("=============================");
        }
        
        else if (lower_msg == "help script")
        {
            llOwnerSay("\n=== USER SCRIPT STRUCTURE ===");
            llOwnerSay("When coding your own logic script, the entry condition inside the link_message event must verify the activation string (str):");
            llOwnerSay("\nCode Structure Example:\n" +
                       "link_message(integer sender_num, integer num, string str, key id) {\n" +
                       "    if (str == \"EXECUTE_SLOW_LOGIC\") {\n" +
                       "        // Write your custom logic here...\n" +
                       "        // Trigger the power-up at the end\n" +
                       "    }\n" +
                       "}");
            llOwnerSay("\nAvailable activation strings (str) per script type:\n" +
                       "• SlowScript ➔ \"EXECUTE_SLOW_LOGIC\"\n" +
                       "• FreezeScript ➔ \"EXECUTE_FREEZE_LOGIC\"\n" +
                       "• DistractionScript ➔ \"EXECUTE_DISTRACT_LOGIC\"\n" +
                       "• CamouflageScript ➔ \"EXECUTE_CAMOUFLAGE_LOGIC\"\n" +
                       "• TeleportScript ➔ \"EXECUTE_TELEPORT_LOGIC\"\n" +
                       "• EnergyScript ➔ \"EXECUTE_ENERGY_LOGIC\"");
            llOwnerSay("\n 0. DISABLE CODE POWER-UP:\n" +
                       "Grants temporary access to the scripting system. Without obtaining this, custom script execution is disabled.\n" +
                       "• Purpose: Introduces progression, resource management, and strategic timing.");
            llOwnerSay("=============================");
        }
        
        else if (lower_msg == "help messages")
        {
            llOwnerSay("\n=== USER SCRIPT OUTPUT MESSAGES ===");
            llOwnerSay("Once your custom logic code executes, you must pass the power-up event to the game environment using:\n" +
                       "llMessageLinked(LINK_SET, 0, \"MESSAGE\", NULL_KEY);");
            llOwnerSay("\nReplace \"MESSAGE\" with plain commands or format them with custom parameter values (Variations).");
            llOwnerSay("Example: llMessageLinked(LINK_SET, 0, \"SLOW=5\", NULL_KEY);");
            llOwnerSay("View all acceptable command strings by typing: 'help powerups'");
            llOwnerSay("=============================");
        }
        
        else if (lower_msg == "help powerups")
        {
            llOwnerSay("\n=== POWER-UPS & VARIATIONS ===");
            
            llOwnerSay("\n1. SLOW (Cost: 10 Energy)\n" +
                       "Reduces the movement speed of all ghosts.\n" +
                       "• \"SLOW\" : Applies default slowdown effect.\n" +
                       "• \"SLOW=X\" : Slows all ghosts with X speed.\n" +
                       "• Use Cases: Escaping nearby ghosts or combining with Teleport.");
                       
            llOwnerSay("\n2. FREEZE (Cost: 20 Energy)\n" +
                       "Completely disables ghost movement.\n" +
                       "• \"FREEZE\" : Applies default freeze duration.\n" +
                       "• \"FREEZE=X\" : Freezes all ghosts for X seconds.\n" +
                       "• Use Cases: Escape situations, safe pellet collection, or strategic repositioning.");
                       
            llOwnerSay("\n3. DISTRACT (Cost: 5 Energy)\n" +
                       "Manipulates ghost navigation behavior toward a location.\n" +
                       "• \"DISTRACT\" : Activates default distraction Scatter mode.\n" +
                       "• \"DISTRACT=<X,Y,Z>\" : Redirects ghosts toward specific vector coordinates.\n" +
                       "• Use Cases: Creating safe routes or pulling ghosts away from objectives.\n" +
                       "Note: Can be used as a foundation for advanced mechanics like temporary decoy objects.");
                       
            llOwnerSay("\n4. CAMOUFLAGE (Cost: 25 Energy)\n" +
                       "Temporarily transforms Pacman into a ghost-like entity.\n" +
                       "• \"CAMOUFLAGE\" : Pacman becomes a yellow ghost.\n" +
                       "• \"CAMOUFLAGE=GHOST_NAME\" : Transforms into Blinky/Inky/Pinky/Clyde appearance.\n" +
                       "• \"CAMOUFLAGE=GHOST_NAME:FAST/SLOW\" : Changes appearance and alters speed.\n" +
                       "• \"CAMOUFLAGE=GHOST_NAME:FAST/SLOW:X\" : Alters appearance and speed for X seconds.\n" +
                       "• Use Cases: Blending with ghost groups or misleading AI systems.");
                       
            llOwnerSay("\n5. TELEPORT (Cost: 15 Energy)\n" +
                       "Instantly relocates Pacman within the maze.\n" +
                       "• \"TELEPORT\" : Random Teleport to any location.\n" +
                       "• \"TELEPORT=X\" : Random Direction Teleport X units away.\n" +
                       "• \"TELEPORT=X,DIRECTION\" : Moves X units to LEFT/RIGHT/UP/DOWN.\n" +
                       "• \"TELEPORT=X,Y\" : Coordinate Teleport directly to (X,Y).\n" +
                       "Safety: If destination is invalid, system automatically selects nearest valid tile.");
                       
            llOwnerSay("\n6. ENERGY REFILL (Cost: 0 - Cooldown: 10s)\n" +
                       "Restores Pacman's scripting resource pool.\n" +
                       "• \"ENERGY_REFILL\" : Instantly restores +10 energy.\n" +
                       "• \"ENERGY_REFILL=X\" : Restores exact custom amount X.\n" +
                       "• Use Cases: Recovering after extensive script usage or enabling high-cost ability combos.");
            llOwnerSay("=============================");
        }
    }
}