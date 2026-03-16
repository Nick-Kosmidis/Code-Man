# Project: Code-Man

Live Programming as Gameplay in OpenSim

## Description
Code-Man is an immersive educational project built within the OpenSimulator environment that transforms the classic Pac-Man gameplay into a live programming challenge. By leveraging the Firestorm viewer and LSL (Linden Scripting Language) , the project enables users to manipulate game behavior.

## Level Structure
- **Level 0:** Empty / Sandbox environment.
- **Level 1:** Basic API calls via direct expressions.
- **Level 2:** Basic logic implementation (code blocks).
- **Level 3:** API Extension (custom command registration).
- **Level 4:** GUI-based programming via in-game HUD.

## Repository Contents
- `/Scripts`: LSL source code files for game logic, APIs, and GUI handlers.
- `/Assets`: 3D mesh files (.dae) for the maze and game objects.
- `/Backup`: The `.oar` file (OpenSimulator Archive) containing the full world state.

## How to run this project on a new machine
To reproduce the project environment, please follow these steps:

1. **Prerequisites:**
   - Install the **OpenSimulator** server (ensure it is configured to run on your local machine).
   - Install the **Firestorm Viewer** to access the virtual world.

2. **Loading the World:**
   - Copy the latest `.oar` file from the `/Backup` folder to your OpenSim server directory.
   - Access the OpenSim console and run the command: 
     `load oar <path_to_file>/world.oar`
   - This will import all objects, terrains, and scripts exactly as they were designed.

3. **In-Game Setup:**
   - Log in using your Firestorm Viewer.
   - Locate the objects in the region. You will find the scripts attached to the objects in the `/Scripts` folder.
   - Ensure the script engine (Mono or LSL) is enabled in your server configuration.

4. **Testing:**
   - Interact with the objects to trigger the programming interface. 
   - Refer to the individual script headers for specific API usage.
