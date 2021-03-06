//
//      Name: raceCamera
//      Desc: Preview camera used to display a race location
//      Return: None
//

if (isNil "GW_RACE_CAM_ACTIVE") then { GW_RACE_CAM_ACTIVE = false; };

setViewDistance 4000;
setObjectViewDistance 4000;

_arr = _this;

// Close if there's a camera already active
if (GW_RACE_CAM_ACTIVE) then {
	GW_RACE_CAM_ACTIVE = false;
	Sleep 1;
};

GW_RACE_CAM_ACTIVE = true;

// Close HUD if open
GW_HUD_ACTIVE = false;
GW_TIMER_ACTIVE = true;

_count = 0;
_currentPos = _arr select _count;
_prevPos = (_arr select ([ _count - 1, 0, (count _arr) -1, true] call limitToRange));
_nextPos = (_arr select ([ _count + 1, 0, (count _arr) -1, true] call limitToRange));
_dirTo = [_prevPos, _currentPos] call dirTo;
_startPos = [_currentPos, 100, dirTo] call relPos;

_count = 0;
_transition = 3;
_timeout = time;

GW_RACE_CAM = "camera" camCreate _startPos;
GW_RACE_CAM cameraeffect["internal","back"];
GW_RACE_CAM camSetTarget _currentPos;
GW_RACE_CAM camCommit 0;

_markers = [];
{
	_c = "Sign_Circle_F" createVehicleLocal _x;

	_cPos = _x;
	_nPos = _arr select ([ _forEachIndex + 1, 0, (count _arr) -1, true] call limitToRange);
	_dirTo = [_cPos, _nPos] call dirTo;

	_pos = getPos _c;
	_pos set [2, -5];
	_c setPos _pos;
	_c setDir _dirTo;


} foreach _arr;

tweenToPos = {
	
	params ['_p1', '_p2'];

	for "_i" from 0 to (_p1 distance _p2) step 100 do {

		_dirTo =  [_p1, _p2] call dirTo;
		_tweenPos = [_p1, _i, _dirTo] call relPos;
		
		GW_RACE_CAM camSetPos _tweenPos;
		GW_RACE_CAM camSetTarget _p2;
		GW_RACE_CAM camCommit 5;
	};
};

{
	_currentPos = _x;
	_prevPos = (_arr select ([ _forEachIndex - 1, 0, (count _arr) -1, true] call limitToRange));
	_nextPos = (_arr select ([ _forEachIndex + 1, 0, (count _arr) -1, true] call limitToRange));

	_dirTo = [_currentPos, _nextPos] call dirTo;

	for "_i" from 0 to (_currentPos distance _nextPos) step 10 do {

		_tweenPos = [_currentPos, _i, _dirTo] call relPos;
		_tweenPos set [2, 10];

		if ((_tweenPos distance _nextPos) < 10) exitWith {};

		GW_RACE_CAM camSetPos _tweenPos;
		GW_RACE_CAM camSetTarget _nextPos;
		GW_RACE_cAM camCommit 2;
		Sleep 2;

	};

	// for "_i" from 0 to 360 step 1 do {		

	// 	_theta = _i;
	// 	_phi = 1;
	// 	_rx = _r * (sin _theta) * (cos _phi);
	// 	_ry = _r * (cos _theta) * (cos _phi);
	// 	_rz = _r * (sin _phi);

	// 	_radiusPos = [(_nextPos select 0) + _rx, (_nextPos select 1) + _ry, 20];
	// 	GW_RACE_CAM camSetPos _radiusPos;
	// 	GW_RACE_CAM camSetTarget _nextPos;
	// 	GW_RACE_CAM camCommit 0.1;
	// 	Sleep 0.1;

	// };	
	
} foreach _arr;


// waitUntil {

// 	_count = _count + 0.01;
// 	_point = (count _arr) * _count;

// 	_index = 

	
// 	if (time - _timeout > _transition) then {

// 		_timeout = time;
// 		_count = [ _count + 1, 0, (count _arr) -1, true] call limitToRange;
// 		_currentPos = _arr select _count;
// 		_nextPos = (_arr select ([ _count + 1, 0, (count _arr) -1, true] call limitToRange));

// 		_transition = [(_currentPos distance _nextPos) / 15, 8, 25] call limitToRange;

// 		_dirTo = [_currentPos, _nextPos] call dirTo;
// 		_targetPos = [_nextPos, 20, _dirTo] call relPos;
// 		GW_RACE_CAM camSetTarget _nextPos;	

// 		_currentPos set [2, 10];
// 		GW_RACE_CAM camSetPos _currentPos;		
// 		GW_RACE_CAM camCommit _transition;

		

// 	};

// 	!GW_RACE_CAM_ACTIVE
// };

{
	deleteVehicle _x;
} foreach _markers;

// Tidy up, reset camera position
showChat true;		
GW_RACE_CAM_ACTIVE = false;
GW_TIMER_ACTIVE = false;
player cameraeffect["terminate","back"];
camdestroy GW_RACE_CAM;
titlecut["","PLAIN DOWN",0.1];



// GW_PREVIEW_CAM_TARGET = _this select 0;
// waitUntil { !isNil "GW_PREVIEW_CAM_TARGET" };

// // Collect camera defaults
// GW_PREVIEW_CAM_RANGE = [_this,1, 10, [0]] call filterParam;
// GW_PREVIEW_CAM_THETA = [_this,2, 0, [0]] call filterParam;
// GW_PREVIEW_CAM_PHI = [_this,3, 1, [0]] call filterParam;
// GW_PREVIEW_CAM_HEIGHT = [_this,4, 1, [0]] call filterParam;
// GW_PREVIEW_CAM_POS = if (typename GW_PREVIEW_CAM_TARGET == "OBJECT") then { (getPosASL GW_PREVIEW_CAM_TARGET) } else { GW_PREVIEW_CAM_TARGET };
// GW_PREVIEW_CAM_POS set[2, GW_PREVIEW_CAM_HEIGHT];

// // Create the camera
// GW_PREVIEW_CAM = "camera" camCreate GW_PREVIEW_CAM_POS;
// GW_PREVIEW_CAM camSetTarget GW_PREVIEW_CAM_POS;
// GW_PREVIEW_CAM cameraeffect["internal","back"];
// GW_PREVIEW_CAM camCommit 0;

// // Determine orbit position
// _theta = if (typename GW_PREVIEW_CAM_THETA == "STRING") then {  _th = parseNumber (GW_PREVIEW_CAM_THETA); GW_PREVIEW_CAM_THETA = 0; _th } else { random 360 };
// _r = 7;
// _phi = 1;
// _rx = _r * (sin _theta) * (cos _phi);
// _ry = _r * (cos _theta) * (cos _phi);
// _rz = _r * (sin _phi);

// // Apply to camera
// GW_PREVIEW_CAM camSetPos [(GW_PREVIEW_CAM_POS select 0) +_rx, (GW_PREVIEW_CAM_POS select 1) + _ry, GW_PREVIEW_CAM_HEIGHT];
// GW_PREVIEW_CAM_LASTPOS = [0,0,0];
// showCinemaBorder false;
// showChat false;

// for "_i" from 0 to 1 step 0 do {

// 	if (!GW_PREVIEW_CAM_ACTIVE) exitWith {};

// 	// If there's a target available
// 	if (!isNil "GW_PREVIEW_CAM_TARGET") then {	

// 		_pos = if (typename GW_PREVIEW_CAM_TARGET == "OBJECT") then { (getPosASL GW_PREVIEW_CAM_TARGET) } else { GW_PREVIEW_CAM_TARGET };
		
// 		GW_PREVIEW_CAM_POS = if (_pos distance GW_PREVIEW_CAM_POS > 15) then {
// 			99999 cutText ["", "BLACK IN", 0.35];  
// 			_theta = random 360;
// 			_pos			
// 		} else {
// 			GW_PREVIEW_CAM_POS
// 		};

// 	} else {
// 		99999 cutText ["", "BLACK OUT", 0.1];  		
// 		GW_PREVIEW_CAM_POS = GW_PREVIEW_CAM_LASTPOS;
// 	};

// 	if (!isNil "GW_PREVIEW_CAM_POS") then {

// 		if (typename GW_PREVIEW_CAM_POS != "OBJECT") then {

// 			// Loop, while updating orbit position
// 			_tx = GW_PREVIEW_CAM_POS select 0;
// 			_ty = GW_PREVIEW_CAM_POS select 1;
// 			_tz = GW_PREVIEW_CAM_HEIGHT;

// 			_theta = _theta + GW_PREVIEW_CAM_THETA;
// 			_theta = _theta mod 360;

// 			_rx = _r * (sin _theta) * (cos _phi);
// 			_ry = _r * (cos _theta) * (cos _phi);	

// 			GW_PREVIEW_CAM camSetPos [(GW_PREVIEW_CAM_POS select 0) + _rx, (GW_PREVIEW_CAM_POS select 1) + _ry, GW_PREVIEW_CAM_HEIGHT];
// 			GW_PREVIEW_CAM_LASTPOS = [(GW_PREVIEW_CAM_POS select 0) + _rx, (GW_PREVIEW_CAM_POS select 1) + _ry, GW_PREVIEW_CAM_HEIGHT];

// 			GW_PREVIEW_CAM camsetTarget [_tx, _ty, _tz];
// 			GW_PREVIEW_CAM camCommit 0;

// 		};

// 	};
	
// };


