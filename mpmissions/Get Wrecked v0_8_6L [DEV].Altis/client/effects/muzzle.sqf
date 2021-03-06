//
//      Name: muzzleEffect
//      Desc: Small smoke burst at point to simulate gun firing
//     

params ['_source', '_offset'];

if (isNull _source) exitWith {};
_offset = if (isNil "_this select 1") then { [0,0,0] } else { (_this select 1) };
_offset = if (_offset isEqualType []) then { _offset } else { [0,0,0] };

_pos = (ASLtoATL visiblePositionASL _source);
_isVisible = [_pos, 1.3] call effectIsVisible;
if (!_isVisible) exitWith {};

_weh = 0.104;
_life= 1.3 + random 0.6;
	
drop [["\A3\data_f\ParticleEffects\Universal\Universal",16,12,8], "", 
"Billboard", 1, _life, _offset, [0, 5 + random 4, 0], 0, _weh, 0.08, 0.2,
[1.5, 5 + random 3], [[0.7, 0.7, 0.7, 0.2 + random 0.1], [0.8, 0.8, 0.8, 0]], 
[1/_life], 1, 0, "", "", _source,random 360];

drop [["\A3\data_f\ParticleEffects\Universal\Universal",16,12,8], "", 
"Billboard", 1, 0.3, _offset, [0, 0, 0], 0, _weh, 0.08, 0.5, [0.4, 2.5], 
[[0.3, 0.3, 0.3, 0],[0.5, 0.5, 0.5, 0.25], [0.7, 0.7, 0.7, 0]], [2], 1, 0, "", "", _source,random 360]
