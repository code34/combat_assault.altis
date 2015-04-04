	private ["_list", "_title"];

	_continue = false;
	{
		if(player distance getmarkerpos _x < 300) then {
			if(getmarkercolor _x == "ColorBlue") then {
				_continue = true;
			};
		};
	}foreach ["viking","hurricane","crocodile", "coconuts", "liberty"];

	if(!_continue) exitwith {
		_title = localize "STR_SERVICING_TITLE";
		_text = localize "STR_SERVICING_NEARAIRPORT";
		["hint", [_title, _text]] call hud;
	};

	playervehicle = [name player, position player, "chopper"];
	["playervehicle", "server"] call BME_fnc_publicvariable;

	

