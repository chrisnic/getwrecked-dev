//
//      Name: addVehicleStatus
//      Desc: Adds a status buff to the target vehicle for a duration, then removes it
//      Return: None
//

private["_vehicle", "_status", "_duration"]; 

_vehicle = _this select 0;
_status = _this select 1;
_duration = _this select 2;

if (isNull _vehicle) exitWith {};
if (!alive _vehicle) exitWith {};

// If we're not dealing with the local vehicle, go find it
if (!local _vehicle) exitWith {
	[       
		_this,
		"addVehicleStatus",
		_vehicle,
		false 
	] call gw_fnc_mp; 
};

if (typename _status == "STRING") then { _status = (call compile _status); };

[_vehicle, _status, _duration] spawn {
	
	private ['_v', '_sL', '_aS'];

	_v = (_this select 0);
	_sL = _v getVariable ["status",[]];
	_aS = [];

	// Add the status, avoiding double-ups
	{
		_sL = (_sL - [_x]) + [_x];
		_aS = (_aS - [_x]) + [_x];

		[_x, (_this select 2)] call triggerVehicleStatus;

		false
	} count (_this select 1) > 0;

	_v setVariable ["status", _sL, true];

	// Some states last indefinitely (cloaking for example)
	if ((_this select 2) >= 9999) exitWith {};
	Sleep (_this select 2);
	
	// If the status still exists remove it
	_sL = _v getVariable ["status", []];
	if (count _sL == 0) exitWith {};
	_sL = _sL - _aS;
	_v setVariable ["status",_sL, true];

};