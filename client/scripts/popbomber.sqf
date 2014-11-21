	private ["_continue", "_title"];

	_continue = false;
	{
		if(player distance getmarkerpos _x < 300) then {
			if(getmarkercolor _x == "ColorBlue") then {
				_continue = true;
			};
		};
	}foreach ["viking","hurricane","crocodile", "coconuts"], 

	if(!_continue) then {
		_title = "Vehicle Servicing";
		_text = "Not enough near of Airport";
		["hint", [_title, _text]] call hud;
	} else {
		[] call WC_fnc_teleportplane;
	};
	

