//
//      Name: saveVehicle
//      Desc: Gathers all information about a vehicle and saves to profileNameSpace
//      Return: None
//

private['_saveTarget'];

if (GW_SETTINGS_ACTIVE || GW_PREVIEW_CAM_ACTIVE) exitWith {};
if (GW_WAITSAVE) exitWith {  systemChat 'Save currently in progress. Please wait.'; };
GW_WAITSAVE = true;

params ['_saveTarget'];

_onExit = {
    systemChat (_this select 0);
    GW_WAITSAVE = false;
};

// Prevent abuse
if (_saveTarget == 'default' || _saveTarget == 'last' || _saveTarget == 'GW_LASTLOAD' || _saveTarget == GW_LIBRARY_LOCATION || _saveTarget == 'VEHICLE') exitWith {
    ['Sorry that name is reserved, try saving as something else!'] call _onExit;
};

// Find the closest pad and abort if we're too far away
_pos = (ASLtoATL getPosASL player);
_closest = [saveAreas, _pos] call findClosest;
_distance = (_closest distance player);

if (_distance > 15) exitWith {
    ['You need to be a bit closer to use this!'] spawn _onExit;
};

_target = _closest;

_owner = ( [_target, 8] call checkNearbyOwnership);

if (!_owner) exitWith {
     ["You don't own this vehicle."] spawn _onExit;
};

// Find the closest valid vehicle on pad
_targetPos = getPosASL _target;
_nearby = (position _target) nearEntities [GW_VEHICLE_CLASSES, 8];

if ( count _nearby == 0) exitWith {
    ['No vehicle to save!'] call _onExit;
    GW_WAITSAVE = false;
};

if ( (count _nearby) > 1) exitWith {
    ['Too many vehicles on the pad, please clear it!'] spawn _onExit;
};

GW_SAVE_VEHICLE = _nearby select 0;

_isOwner = [GW_SAVE_VEHICLE, player, true] call checkOwner;
if (!_isOwner) exitWith {
    ["You don't own this vehicle!"] spawn _onExit;
};

// Check it's a valid vehicle and if not wait for it to be compiled
_allowUpgrade = GW_SAVE_VEHICLE getVariable ['isVehicle', false];

if (!_allowUpgrade) then {
    [GW_SAVE_VEHICLE] call compileAttached;
};

GW_SAVE_VEHICLE setDir 0;

// Disable simulation on vehicle
if (!simulationEnabled GW_SAVE_VEHICLE) then {
    [
        [
            GW_SAVE_VEHICLE,
            true
        ],
        "setObjectSimulation",
        false,
        false
    ] call bis_fnc_mp;
};

// Wait for simulation enabled and vehicle compiled
_timeout = time + 3;
waitUntil{
    Sleep 0.1;
    if ( (time > _timeout) || (simulationEnabled GW_SAVE_VEHICLE && { ((getPos GW_SAVE_VEHICLE) select 2 < 1) } && {GW_SAVE_VEHICLE getVariable ['isVehicle', false]} ) ) exitWith { true };
    false
};

if (time > _timeout) exitWith {
    ['Error saving, simulation not enabled or vehicle not compiled properly!'] spawn _onExit;
};


// Wait just a second
Sleep 0.01;

// Kick out anyone who is inside
_crew =  (crew GW_SAVE_VEHICLE);
if ( (count _crew) > 0) then {
    {
        _x action ["eject", GW_SAVE_VEHICLE];
    } ForEach _crew;
};

// Wait for them to get kicked out
_timeout = time + 5;
waitUntil{
    Sleep 0.1;
    _crew =  (crew GW_SAVE_VEHICLE);
    if ( (time > _timeout) || ((count _crew) <= 0) ) exitWith { true };
    false
};

if (time > _timeout) exitWith {
    ['Error saving, you have to exit the vehicle first!'] spawn _onExit;
};

// Actuallu saving now
systemChat 'Saving...';

_class = typeOf GW_SAVE_VEHICLE;
_name = GW_SAVE_VEHICLE getVariable ["name", 'Untitled'];
if (isNil "_name") then {  _name = 'Untitled'; };

// Check the name and save target is valid
_len = (count toArray(_name));
if ( _len == 0 || _name == ' ') then {
    _name = 'Untitled';
};

_len = (count toArray(_saveTarget));
if ( _len == 0 || _saveTarget == ' ') then {
    _saveTarget = _name;
} else {
    _name = _saveTarget;
};

_name = toUpper(_name);

_abort = false;

// If no save target specified, see if the user wants to give it one
if (_name == "Untitled") then {

    _result = ['SAVE', _name, 'INPUT', [generateName, randomizeIcon]] call createMessage;

    if (_result isEqualType ""  && ({ (count toArray _result == 0) || (_result == "Untitled") } )) then {
        _abort = true;
        ['Save aborted by user.'] spawn _onExit;
    };

    if (_result isEqualType true && { !_result }) then {
        _abort = true;
        ['Save aborted by user.'] spawn _onExit;

    };

    if (!_abort) then {
        _name = _result;
        _saveTarget = _result;
    };
};

if ( !(_saveTarget isEqualType "") ) then { ['Please choose another vehicle name.'] spawn _onExit; _abort = true; };
if (_abort) exitWith {};

_startTime = time;

_paint = GW_SAVE_VEHICLE getVariable ["GW_paint",""];
_attachments = attachedObjects GW_SAVE_VEHICLE;

_attachArray = [];

// Remove bad items
GW_SAVE_VEHICLE call cleanAttached;

// Get information about each attached item
if (count _attachments > 0) then {

    {
        _p = getPosWorld _x;
        _p = GW_SAVE_VEHICLE worldToModel (ASLtoAGL _p);

        // Delete the object if we're having issues with it (or its old)
        if (!alive _x || (_p distance _pos) > 999999) then {

           deleteVehicle _x;

        } else {

            _p =  _p call positionToString;

            _tag = _x getVariable ['GW_Tag', ''];
            _data = [_tag, GW_LOOT_LIST] call getData;
            _c = _data select 0;
            _k = _x getVariable ["GW_KeyBind",  ["-1", "1"]];

            _pitchBank = _x call BIS_fnc_getPitchBank;
            _dir = [(_pitchBank select 0), (_pitchBank select 1), getDir _x];

            _element = [_c, _p, _dir, _k];
            _attachArray pushBack _element;

        };

    } ForEach _attachments;
};

// Get various meta and random data about the vehicle
_creator = GW_SAVE_VEHICLE getVariable ['creator', name player];
_prevAmmo = GW_SAVE_VEHICLE getVariable ["ammo", 1];
_prevFuel = (fuel GW_SAVE_VEHICLE) + (GW_SAVE_VEHICLE getVariable ["fuel", 0]);
_vehicleBinds = GW_SAVE_VEHICLE getVariable [GW_BINDS_LOCATION, GW_BINDS_ORDER];
_taunt = GW_SAVE_VEHICLE getVariable ['GW_Taunt', []];

_stats = [];
{  _stats pushback ([_x, toUpper(_name)] call getStat); FALSE } count GW_STATS_ORDER;

_meta = [
    GW_VERSION, // Current version of GW
    _creator, // Original author of vehicle
    _prevFuel, // Prior Fuel
    _prevAmmo,  // Prior Ammo
    _stats, // Stats would go here, but they are handled locally and seperately
    _vehicleBinds,
    _taunt
];

_data = [_class, toUpper(_name), _paint, [], 0, _attachArray, _meta];

if (count str _data > GW_MAX_DATA_SIZE) exitWith {
    ['Vehicle too large to save, please remove items.'] spawn _onExit;
};

_success = [toUpper(_saveTarget), [_data]] call registerVehicle;
GW_LASTLOAD = _saveTarget;

if (_success) then {
    _totalTime = time - _startTime;
    systemChat format['Vehicle saved: %1 in %2.', _saveTarget, _totalTime];
    ['VEHICLE SAVED!', 2, successIcon, nil, "slideDown"] spawn createAlert;
} else {
    systemChat format['Error saving %1 to library.', _saveTarget];
};

// Return the vehicle to the pad
GW_SAVE_VEHICLE setVariable ["name", _saveTarget, true];
GW_SAVE_VEHICLE setVariable ["isSaved", true];
GW_SAVE_VEHICLE setPosASL _targetPos;
GW_SAVE_VEHICLE setDammage 0;

// Make it so other people can use the pad
_closest setVariable ["owner", "", true];

// Then re-disable simulation
[''] spawn _onExit;
