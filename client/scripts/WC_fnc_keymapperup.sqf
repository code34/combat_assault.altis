	// -----------------------------------------------
	// Author:  code34 nicolas_boiteux@yahoo.fr
	// HANDLE KEYBOARD EVENTS

	#define DIK_TAB	0x0F
	
	private [
		"_handled",
		"_ctrl",
		"_dikCode",
		"_shift",
		"_ctrl",
		"_alt"
	];

	_ctrl		= _this select 0;
	_dikCode	= _this select 1;
	_shift		= _this select 2;
	_ctrl		= _this select 3;
	_alt		= _this select 4;
	_handled 	= false;

	if(_dikCode == DIK_TAB) then {
		wcboard = false;
		_handled = true;
	};

	_handled;