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
		_title = "Vehicle Servicing";
		_text = "Not enough near of Airport";
		["hint", [_title, _text]] call hud;
	};

	playervehicle = [name player, position player, "achopper"];
	["playervehicle", "server"] call BME_fnc_publicvariable;

	
