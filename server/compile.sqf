//
//
//
//		Server Function Compile & Configuration
//
//
//
loadVehicle =  compile preprocessFile "server\functions\loadVehicle.sqf";
logKill = compile preprocessFile "server\functions\logKill.sqf";

// Zone Functions
initEvents = compile preprocessFile "server\zones\events.sqf";
createSupplyDrop = compile preprocessFile "server\zones\createSupplyDrop.sqf";

// Object
setupObject = compile preprocessFile "server\objects\setup_object.sqf";

// Vehicle
setVehicleRespawn = compile preprocessFile "server\vehicles\vehicle_respawn.sqf";
setupVehicle = compile preprocessFile "server\vehicles\setup_vehicle.sqf";
loadVehicle = compile preprocessFile "server\functions\loadVehicle.sqf";

initCleanup = compile preprocessFile "server\cleanup.sqf";

// MP Functions
pubVar_fnc_spawnObject = compile preprocessFile "server\functions\pubVar_spawnObject.sqf";
"pubVar_spawnObject" addPublicVariableEventHandler { (_this select 1) call pubVar_fnc_spawnObject };

pubVar_fnc_logDiag = compile preprocessFile "server\functions\pubVar_logDiag.sqf";
"pubVar_logDiag" addPublicVariableEventHandler { (_this select 1) call pubVar_fnc_logDiag };

// Utility
setVisibleAttached = compile preprocessFile "server\functions\setVisibleAttached.sqf";
setObjectSimulation = compile preprocessFile "server\functions\setObjectSimulation.sqf";
setSimulationVisibility =  compile preprocessFile "server\functions\setSimulationVisibility.sqf";

// Leaderboard
if (GW_LEADERBOARD_ENABLED) then {
	call compile preprocessFile "server\functions\leaderboard.sqf";
};



