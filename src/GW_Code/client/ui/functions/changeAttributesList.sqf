//
//      Name: changeAttributesList
//      Desc: Updates the list of attributes adjacent to the vehicle list in new/create menu
//      Return: None
//

private ['_control', '_index', '_class'];

disableSerialization;
_control = (_this select 0) select 0;
_index = (_this select 0) select 1;
_class = _control lnbData [_index, 2];
_cost = parseNumber (_control lnbData [_index, 1]);

[_class] spawn generateAttributesList;

_select = (findDisplay 96000 displayCtrl 96003);
_icon = (findDisplay 96000 displayCtrl 96004);

_unlocked = if (_cost == 0) then { true } else {
	if (_cost > 0 && _class in GW_UNLOCKED_ITEMS) exitWith { true };
	false
};

if (_unlocked) then {
	_select ctrlSetText "SELECT";
	_select ctrlCommit 0;
	_icon ctrlSetStructuredText parseText ( "" );
	_icon ctrlCommit 0;

} else {
	_costString = [_cost] call numberToCurrency;
	_select ctrlSetText format['$%1', _costString];
	_select ctrlCommit 0;
	_icon ctrlSetStructuredText parseText ( format["<img size='1.4' align='left' VALIGN='middle' image='%1' />", lockIcon] );
	_icon ctrlCommit 0;
};
