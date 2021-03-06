//
//      Name: returnToZone
//      Desc: Timeout to incentivize player returning to zone
//      Return: None
//

params ['_unit'];
if (isNull _unit) exitWith {};

_unit setVariable ["outofbounds", true];		

_timeout = time + 15;
_outOfBounds =_unit getVariable ["outofbounds", false];	

// Add ppEffects
"colorCorrections" ppEffectEnable true; 
"colorCorrections" ppEffectAdjust [1, 0.3, 0, [1,1,1,-0.1], [1,1,1,2], [-0.5,0,-1,5]]; 
"colorCorrections" ppEffectCommit 1;
"dynamicBlur" ppEffectEnable true; 
"dynamicBlur" ppEffectAdjust [1]; 
"dynamicBlur" ppEffectCommit 1; 
"filmGrain" ppEffectEnable true; 
"filmGrain" ppEffectAdjust [0.1, 0.5, 2, 0, 0, true];  
"filmGrain" ppEffectCommit 1;

waitUntil {

	_outOfBounds = _unit getVariable ["outofbounds", false];	
	_timeLeft = ceil (_timeout - time);
	_str = format[localize "str_gw_out_of_zone", _timeLeft];

	[_str, 0.5, warningIcon, colorRed, "warning"] spawn createAlert;     

	Sleep 0.5;

	(time > _timeout || !_outOfBounds || !alive _unit || isNil "GW_CURRENTZONE")
};

// Kill the player and vehicle if we're still out of zone
if (_outOfBounds) then {
	_name = (vehicle player) getVariable ['name', ''];
	['outofbounds', _name, 1] call logStat; 
	(vehicle player) call destroyInstantly;			 
};

// Restore all ppEffects
"colorCorrections" ppEffectEnable false; 
"dynamicBlur" ppEffectAdjust [0]; 
"dynamicBlur" ppEffectCommit 0.5; 
"filmGrain" ppEffectAdjust [0, 0, 0, 0, 0, true];  
"filmGrain" ppEffectCommit 0.5; 