		private ["_player"];

		_player = cursorObject;

		if(isnull _player) exitWith {};
		if(isnil "_player") exitWith {};
		if!(_player isKindOf "Man") exitWith {};	
		if!(isplayer _object) exitWith {};
		if(player distance _player > 5) exitWith {};

		if(["addPlayer", name _player] call playersmarkers) then {
			hint format ["You give a BIG HUG to %1", name _player];
		};

		wcunblacklist = player;
		["wcunblacklist", "client", owner _player] call BME_fnc_publicvariable;

