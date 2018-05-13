	private ["_list", "_title"];

	_list = (position player) nearEntities [["Man", "Tank"], 50];
	sleep 0.5;

	if(east countSide _list > 0) then {
		_title = localize "STR_SERVICING_TITLE";
		_text = localize "STR_SERVICING_TOOENEMY";
		["hint", [_title, _text]] call hud;
	} else {
		playervehicle = [name player, position player, "tankaa"];
		["playervehicle", "server"] call BME_fnc_publicvariable;
	};
	
