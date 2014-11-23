	private ["_list", "_title"];

	_list = (position player) nearEntities [["Man", "Tank"], 50];
	sleep 0.5;

	if(east countSide _list > 0) then {
		_title = "Vehicle Servicing";
		_text = "Too near of enemy position";
		["hint", [_title, _text]] call hud;
	} else {
		playervehicle = [name player, position player, "tank"];
		["playervehicle", "server"] call BME_fnc_publicvariable;
	};
	
