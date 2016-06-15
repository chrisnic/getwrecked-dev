//
//      Name: fireGmg
//      Desc: Fires a burst of 20mm he grenades at the target
//      Return: None
//

params ['_gun', '_target', '_vehicle'];

_round = "G_40mm_HEDP";
_soundToPlay = "a3\sounds_f\weapons\Grenades\grenade_launcher_1.wss";
_fireSpeed = 0.3;
_projectileSpeed = 250;
_range = 400;

[_gun, [0,1.6,-0.5]] spawn muzzleEffect;

_targetPos = if (_target isEqualTo objNull) then { getPosASL _target } else { _target };
_gPos = _gun selectionPosition "otochlaven";
_gPos = _gun modelToWorld [-0.15,1.7,-0.72];

_heading = [_gPos,_targetPos] call BIS_fnc_vectorFromXToY;
_velocity = [_heading, _projectileSpeed] call BIS_fnc_vectorMultiply; 

_bullet = createVehicle [_round, _gPos, [], 0, "CAN_COLLIDE"];

if (GW_DEBUG) then { [_gPos, _targetPos, 0.01] spawn debugLine; };

[(ATLtoASL _gPos), (ATLtoASL _targetPos), "GMG"] call markIntersects;

_bullet setVectorDir _heading; 
_bullet setVelocity _velocity; 

playSound3D [_soundToPlay, _gun, false, (ASLtoATL visiblePositionASL _gun), 7, 1, 100];		

addCamShake [.5, 1,20];

true