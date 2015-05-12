//
//      Name: fireHarpoon
//      Desc: Fires a hook that grabs and briefly disables vehicles
//      Return: None
//

private ["_obj"];

_obj = _this select 0;
_target = _this select 1;
_vehicle = _this select 2;

_inUse = _obj getVariable ['inUse', false];
if (_inUse) exitWith {};
_obj setVariable ['inUse', true];

_oPos = (_obj modelToWorldVisual [3,0,-0.7]);
_tPos = _target;
_heading = [ASLtoATL _oPos,ASLtoATL _tPos] call BIS_fnc_vectorFromXToY;
_velocity = [_heading, 50] call BIS_fnc_vectorMultiply; 
_hook = createVehicle ["Land_Tableware_01_fork_F", _oPos, [], 0, "CAN_COLLIDE"];

_hook addEventHandler['EpeContactStart', {
		
	_target = (_this select 1);
	_hook = (_this select 0);
	_isVehicle = _target getVariable ['isVehicle', false];	
	if (_isVehicle && _target != GW_CURRENTVEHICLE) exitWith {

		_hook removeEventHandler ['EpeContactStart', 0];		
		_sourceRope = _hook getVariable ['GW_ropeSource', nil];
		if (isNil "_sourceRope") exitWith {};

		playSound3D ["a3\sounds_f\sfx\vehicle_drag_end.wss", _target, false, (ASLtoATL visiblePositionASL _target), 10, 1, 100];
		playSound3D ["a3\sounds_f\sfx\special_sfx\sparkles_wreck_1.wss", _target, false, (ASLtoATL visiblePositionASL _target), 5, 1, 100];	

		_dist = _target distance GW_CURRENTVEHICLE;
		ropeCut [_sourceRope, _dist];
		deleteVehicle _hook;

		[       
	        [
	            _target,
	            "['EMP']",
	            (random 2)
	        ],
	        "addVehicleStatus",
	        _target,
	        false 
		] call gw_fnc_mp;  

		// [
		// 	[
		// 		_target,
		// 		2
		// 	],
		// 	"sparkEffect"
		// ] call gw_fnc_mp;

		[_target, (_TARGET worldToModelVisual (ASLtoATL visiblePositionASL _hook)) ,[0,0,-1]] ropeAttachTo _sourceRope;	
		
	};
}];

_rope = ropeCreate[_vehicle, (_vehicle worldToModelVisual (ASLtoATL visiblePositionASL _obj)), _hook, [0,0,0], 50];
_hook setVariable ['GW_ropeSource', _rope];

playSound3D [format["a3\sounds_f\weapons\Mortar\mortar_%1.wss", [(ceil (random 7) + 1), 2] call padZeros], _obj, false, _oPos, 10, 1, 100];


[_obj] spawn muzzleEffect;

_hook setVectorDir _heading;
_hook setVelocity _velocity;

[_hook, _velocity, _tPos] spawn {
	_lastPos = (ASLtoATL visiblePositionASL (_this select 0));
	waitUntil {		
		_lastPos = (ASLtoATL visiblePositionASL (_this select 0));
		(_this select 1) set [2, ((_this select 1) select 2) -0.05];				
		(_this select 0) setVelocity (_this select 1);
		(!alive (_this select 0))
	};
};

_hook spawn { Sleep 10; deleteVehicle _this; };

[_rope, _obj] spawn { 

	_timeout = time + 10;
	waitUntil {
		Sleep 0.1;
		((time > _timeout) || !(alive (_this select 0)) || !(alive GW_CURRENTVEHICLE))
	}; 	
 	ropeDestroy (_this select 0);
 	(_this select 1) setVariable ['inUse', false];
};

true
