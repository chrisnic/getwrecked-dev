_s = [_this, 0, false, [objNull, []]] call filterParam;
_r = [_this, 1, 0, [0]] call filterParam;
_dir = [_this, 2, 0, [0]] call filterParam;

if (_s isEqualType true) exitWith { [0,0,0] };
_s = if (_s isEqualType objNull) then { 
	if (X_Client) exitWith { (ASLtoATL visiblePositionASL _s) };
	(ASLtoATL getPosASL _s) 
} else { _s };

_sx = _r * (sin _dir) * (cos 1);
_sy = _r * (cos _dir) * (cos 1);

[(_s select 0) + _sx, (_s select 1) + _sy, (_s select 2)]