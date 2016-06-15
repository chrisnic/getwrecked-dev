//
//      Name: targetCursor
//      Desc: Handles the look of the cursor target while in a vehicle
//      Return: None
//

private ['_pos', '_col', '_scale', '_icon', '_limit', '_vehDir', '_vehicle'];

// Not in a race/battle
if (GW_CURRENTZONE == "workshopZone") exitWith {};
	
// Dialogs open, abort
if (GW_SETTINGS_ACTIVE || GW_SPECTATOR_ACTIVE || GW_TITLE_ACTIVE) exitWith {};

// Source vehicle isn't available
if (isNull GW_CURRENTVEHICLE) exitWith {};
if (!alive GW_CURRENTVEHICLE) exitWith {};

_vehicle = GW_CURRENTVEHICLE;
_unit = player;

IF (vectorUp _vehicle distance [0,0,1] > 1) exitWith {};

// Get all the camera information we need
_cameraPosition = positionCameraToWorld [0,0,0];
GW_TARGET_DIRECTION = [_cameraPosition, (positionCameraToWorld [0,0,4])] call dirTo;

GW_MIN = positionCameraToWorld [0,0,200];
GW_ORIGIN = (ASLtoATL visiblePositionASL _vehicle);

// Determine which target marker to use
// Resolution of aim and ballistics is still very much a WIP
GW_TARGET = GW_MIN;
_terrainIntersect = terrainIntersect [_cameraPosition, GW_MIN];
_heightAboveTerrain = (GW_ORIGIN) select 2;

if (_terrainIntersect || _heightAboveTerrain > 3) then { GW_TARGET = (screenToWorld [0.5, 0.5]); };
if (GW_DEBUG) then { [GW_ORIGIN, GW_TARGET, 0.1] spawn debugLine; };

GW_TARGET = GW_MIN;

// Determine available weapons from camera direction
_weaponsList = _vehicle getVariable ["weapons", []];

_icon = noTargetIcon;
_col = [0.99,0.14,0.09,1];
_col set[3, 0.5];
_scale = 1.7;

_count = 0;
_lastWeapon = "";
_hasFired = false;

if ('cloak' in GW_VEHICLE_STATUS || 'noshoot' in GW_VEHICLE_STATUS) exitWith {
	_pos = _vehicle modelToWorldVisual [0,40,0];
	drawIcon3D [vehicleTargetIcon, [1,1,1,0.5], _pos, 1.25, 1.25, 0];	
	drawIcon3D [noTargetIcon, _col, GW_TARGET, _scale, _scale, 0];	
};

// Reset the available weapons each pass
GW_AVAIL_WEAPONS = [];

{

	if (GW_WAITFIRE) exitWith {};

	_type = _x select 0;

	if ( !(_type in GW_FIREABLE_WEAPONS) ) exitWith {};		

	_obj = _x select 1;	

	if (true) then {
		
		// Angle difference between camera and weapon
		_defaultDir = _obj getVariable ["GW_defaultDirection", 0];
		_actualDir = [GW_TARGET_DIRECTION - GW_CURRENTDIR] call normalizeAngle;	
		if (abs ( [_actualDir - _defaultDir] call flattenAngle ) > 30 ) exitWith {};

		_col = [1,1,1,0.7];
		_count = _count + 1;	
		_lastWeapon = _type;	

		_bind = _obj getVariable ['GW_KeyBind', ["-1", "1"]];
		_bind = if (_bind isEqualType []) then { (_bind select 1) } else { _bind };	
		GW_AVAIL_WEAPONS pushback [_obj, _type, _bind];

		// Only fire mouse bound weapons
		if (GW_LMBDOWN) exitWith {

			if (_bind != "1") exitWith {};

			_hasFired = true;
			[_type, _vehicle, _obj] spawn fireAttached;

		};	

	};

	false
} count _weaponsList > 0;

// For multiple weapons, just use the default
_icon = if (_count > 1) then {
	targetIcon;
} else {
	(_lastWeapon call getWeaponIcon)
};

['Can Shoot', true] call logDebug;

// Mouse shooting
if (_hasFired) then {
	_scale = 1.5;
	_col = [1,1,1,1];	
};

_pos = _vehicle modelToWorldVisual [0,40,0];
drawIcon3D [vehicleTargetIcon, [1,1,1,0.5], _pos, 1.25, 1.25, 0];	
drawIcon3D [_icon, _col, GW_TARGET, _scale, _scale, 0];	