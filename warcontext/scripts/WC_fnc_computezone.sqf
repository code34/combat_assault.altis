	// -----------------------------------------------
	// code34 nicolas_boiteux@yahoo.fr
	// -----------------------------------------------
	if (!isServer) exitWith{};

	private [
		"_around",
		"_buildzone",
		"_key",
		"_tree",
		"_index", 
		"_exist",
		"_grid",
		"_basepos", 
		"_housezone",
		"_sector",
		"_position",
		"_positions",
		"_sectors"
	];

	_tree = _this select 0;
	_grid = ["new", [31000,31000,100,100]] call OO_GRID;
	
	_housezone = [];
	while { count _housezone < 30 } do {
		_sector = [ceil (random 300), ceil (random 300)];
		_position = ["getPosFromSector", _sector] call _grid;
		if(getmarkerpos "respawn_west" distance _position > 1300) then {
			if!(surfaceIsWater _position) then {
				_housezone = _housezone + [_sector];
			};
		};
	};

	for "_x" from 0 to 10 step 1 do {
		_key = _housezone call BIS_fnc_selectRandom;
		["expandSector", _key] call global_controller;
		["expandSectorAround", _key] call global_controller;
	};

	{
		if(random 1 > 0.75) then {
			_position = getmarkerpos _x;
			_sector = ["getSectorFromPos", _position] call _grid;
			["expandSector", _sector] call global_controller;
			["expandSectorAround", _sector] call global_controller;
		};
	} foreach ["viking","hurricane","crocodile", "coconuts", "liberty"];

	//_tree;