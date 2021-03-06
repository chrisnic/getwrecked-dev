//
//      Name: markAsKilledBy
//      Desc: Tags a vehicle as killed by the local player
//      Return: None
//

private ['_v', '_m'];
params ['_v'];

if (isNull _v) exitWith {};
if (!alive _v) exitWith {};

_m = if (isNil "_this select 1") then { "" } else { (_this select 1) };

// Don't tag our own vehicle
if (_v == GW_CURRENTVEHICLE) exitWith {};
if !(_v call isVehicle) exitWith {};

_v setVariable['killedBy', format['%1', [name player, _m, (GW_CURRENTVEHICLE getVariable ['name', '']), (typeOf GW_CURRENTVEHICLE) ] ], true];
_driver = driver _v;

if (isNil "GW_LASTTAGGEDMESSAGE") then { GW_LASTTAGGEDMESSAGE = time - 0.3; };
if (GW_DEBUG && (time - GW_LASTTAGGEDMESSAGE > 0.3)) then {
	systemChat format['Tagged %1', _v];
};
