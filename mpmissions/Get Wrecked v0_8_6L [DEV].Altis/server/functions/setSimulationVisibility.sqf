//
//      Name: setSimulationVisibility
//      Desc: Enable/disable simulation and visibility for a group or individual objects (combined call for reduced network load)
//      Return: None
//

private ['_o', '_a', '_s', '_v'];
params ['_o', '_a'];

_s = _a select 0;
_v = _a select 1;

[_o, _s] call setObjectSimulation;
[_o, _v] call setVisibleAttached;
