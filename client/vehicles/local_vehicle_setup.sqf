//
//      Name: setupLocalVehicle
//      Desc: Compiles and adds meta information for newly loaded vehicle
//      Return: None
//

private ['_vehicle', '_name', '_raw', '_meta', '_version', '_creator', '_prevFuel', '_prevAmmo', '_stats'];

_vehicle = [_this,0, objNull, [objNull]] call filterParam;

if (isNull _vehicle) exitWith {};
if (!alive _vehicle) exitWith {};

// Compile vehicle information
_vehicle lockCargo true;
[_vehicle] call compileAttached;

// Set us as the owner
_vehicle setVariable ["owner", GW_PLAYERNAME, true];

_name = _vehicle getVariable ["name", ''];
if (_name == '' || _name == "UNTITLED") exitWith {};

// Is there any data for this vehicle?
_raw = profileNameSpace getVariable[_name, nil]; 
if (isNil "_raw") exitWith {};

// Grab the meta data
_meta = (_raw select 0) select 6;
_vehicle setVariable ["isSaved", true];

// Apply meta (if exists)
if (isNil "_meta") then {} else {
    
    _meta resize 7;

    _version = _meta select 0;
    _creator = _meta select 1;
    _prevFuel = _meta select 2;
    _prevAmmo = _meta select 3;
    _stats = _meta select 4;
    _binds = _meta select 5;
    _taunt = _meta select 6;

    if (!isnil "_version") then {

        _version = if (typename _version == "ARRAY") then { 0 } else { _version };

        if (_version < GW_VERSION) then {
            systemChat 'Warning: Vehicle saved on older version, re-save, clear, then load to avoid issues.';      
        };
    };

    if (!isNil "_creator") then {
        _vehicle setVariable ['creator', _creator, true];
    };

    // Restore previous fuel and ammo
    if (!isNil "_prevAmmo") then {
        _maxAmmo = _vehicle getVariable ["maxAmmo", 1];
        if (_prevAmmo > _maxAmmo) then {_prevAmmo = _maxAmmo; };
        _vehicle setVariable ["ammo", _prevAmmo];
    };

    if (!isNil "_prevFuel") then {

        _maxFuel = _vehicle getVariable ["maxFuel", 1];
        if (_prevFuel > _maxFuel) then {_prevFuel = _maxFuel; };
        if (_prevFuel > 1) then {
            _vehicle setFuel 1;
            _vehicle setVariable ["fuel", (_prevFuel - 1)];     
        } else {
            _vehicle setFuel _prevFuel;
        };
    };  

    // Iterate through and print each stat
    if (!isNil "_stats") then {       

        {
            if (isNil "_x") then {} else {                
                _vehicle setVariable [GW_STATS_ORDER select (_forEachIndex), (_stats select (_forEachIndex))];
            };
        } ForEach _stats;

    };

    if (!isNil "_binds") then {

        // Set default keybind order       
        _newBinds = +GW_BINDS_ORDER;

        // Override that order with the custom vehicle binds we have
        {
            _str = _x select 0;
            _tag = _x select 1;
            {
                if (_str == (_x select 0)) exitWith {
                    _newBinds set[_forEachIndex, [_str, _tag]];
                };

            } Foreach _newBinds;

        } count _binds;

        // SAVE TO VEHICLE
         _vehicle setVariable ["GW_Binds", _newBinds];       

    };

    if (!isNil "_taunt") then {
        _vehicle setVariable ["GW_Taunt", _taunt];
    };

};
