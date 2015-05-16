//
//      Name: fireHarpoon
//      Desc: Fires a hook that grabs and briefly disables vehicles
//      Return: None
//

private ["_obj"];

_obj = _this select 0;
_target = _this select 1;
_vehicle = _this select 2;

_oPos = (_obj modelToWorldVisual [5,0,-0.7]);
_tPos = _target;
_heading = [ASLtoATL _oPos,ASLtoATL _tPos] call BIS_fnc_vectorFromXToY;
_velocity = [_heading, 60] call BIS_fnc_vectorMultiply; 
_velocity = (_velocity) vectorAdd (velocity _vehicle);

_hook = createVehicle ["Land_Tableware_01_fork_F", _oPos, [], 0, "CAN_COLLIDE"];

_hook addEventHandler['EpeContact', {
		
	_target = (_this select 1);
	_hook = (_this select 0);
	_isVehicle = _target getVariable ['isVehicle', false];	
	if (_isVehicle && _target != GW_CURRENTVEHICLE) exitWith {

		_hook removeEventHandler ['EpeContact', 0];		
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
	            "['harpoon']",
	            3
	        ],
	        "addVehicleStatus",
	        _target,
	        false 
		] call gw_fnc_mp; 	

		_target setDammage (getDammage _target) + 0.025;

		[_target, 'HAR'] call markAsKilledBy;

		[_target, (_TARGET worldToModelVisual (ASLtoATL visiblePositionASL _hook)) ,[0,0,-1]] ropeAttachTo _sourceRope;	
		
	};
}];

_rope = ropeCreate[_vehicle, (_vehicle worldToModelVisual (ASLtoATL visiblePositionASL _obj)), _hook, [0,0,0], 60];
_hook setVariable ['GW_ropeSource', _rope];

playSound3D [format["a3\sounds_f\weapons\Mortar\mortar_%1.wss", [(ceil (random 7) + 1), 2] call padZeros], _obj, false, _oPos, 10, 1, 100];


[_obj] spawn muzzleEffect;
addCamShake [1, 1,20];
_hook setVectorDir _heading;
_hook setVelocity _velocity;

[_hook, _velocity, _tPos] spawn {
	_lastPos = (ASLtoATL visiblePositionASL (_this select 0));
	_timeout = time + 15;
	waitUntil {		
		Sleep 0.25;
		_lastPos = (ASLtoATL visiblePositionASL (_this select 0));
		(_this select 1) set [2, ((_this select 1) select 2) -5];				
		// (_this select 0) setVelocity (_this select 1);
		((!alive (_this select 0)) || (time > _timeout))
	};
};

_hook spawn { Sleep 15; deleteVehicle _this; };

[_rope, _obj] spawn { 

	_timeout = time + 15;
	waitUntil {
		Sleep 0.1;
		((time > _timeout) || !(alive (_this select 0)) || !(alive GW_CURRENTVEHICLE))
	}; 	
 	ropeDestroy (_this select 0);
};

true
