	// -----------------------------------------------
	// Author: team  code34 nicolas_boiteux@yahoo.fr
	// Dynamic zone
	// -----------------------------------------------
	if (!isServer) exitWith{};

	private [
		"_around",
		"_key",
		"_grid",
		"_globalindex",
		"_position",
		"_positions",
		"_sector",
		"_exist"
	];

	call compilefinal preprocessFileLineNumbers "client\oo_marker.sqf";
	call compilefinal preprocessFileLineNumbers "client\BME\init.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\scripts\paramsarray_parser.sqf";

	WC_fnc_skill	 	= compile preprocessFile "warcontext\scripts\WC_fnc_setskill.sqf";
	WC_fnc_computezone	= compile preprocessFile "warcontext\scripts\WC_fnc_computezone.sqf";
	WC_fnc_patrol		= compile preprocessFile "warcontext\scripts\WC_fnc_patrol.sqf";
	WC_fnc_patrol_air	= compile preprocessFile "warcontext\scripts\WC_fnc_patrol_air.sqf";
	WC_fnc_setskill		= compile preprocessFile "warcontext\scripts\WC_fnc_setskill.sqf";
	WC_fnc_vehiclehandler	= compile preprocessFile "warcontext\scripts\WC_fnc_vehiclehandler.sqf";

	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_hashmap.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_grid.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_sector.sqf";

	[] execVM "real_weather\real_weather.sqf";

	global_sector_attack = [];
	global_sector_done = [];
	global_new_zone = [];

	global_zone_hashmap  = [] call WC_fnc_computezone;
	_player_hashmap = ["new", []] call OO_HASHMAP;

	_grid = ["new", [31000,31000,100,100]] call OO_GRID;
		
	while { true } do {
		{			
			if(side _x == west) then {
				_sector = ["getSectorFromPos", position _x] call _grid;
				if(["containsKey", [name _x]] call _player_hashmap) then {
					_bck_sector = ["Get", [name _x]] call _player_hashmap;
					if(format ["%1", _bck_sector] != format["%1", _sector]) then {
						["Set", [name _x, _sector]] call _player_hashmap;
						_around = ["getSectorAllAround", [_sector, 3]] call _grid;

						{
							if!(_x in global_sector_attack) then {
								if(["containsKey", [_x]] call global_zone_hashmap ) then {
									global_sector_attack = global_sector_attack + [_x];
									_sector = ["Get", [_x]] call global_zone_hashmap ;
									"Spawn" spawn _sector;
								};
							};
							sleep 0.001;
						}foreach _around;						
					};
				} else {
					["Put", [name _x, _sector]] call _player_hashmap;
				};
			};
			sleep 0.001;
		} foreach playableunits;
		while { count global_new_zone > 0 } do {
			_key = global_new_zone select 0;
			_exist = ["containsKey", [_key]] call global_zone_hashmap;

			if!(_exist) then {
				_position = ["getPosFromSector", _key] call _grid;
				if(!surfaceIsWater _position) then {
					_sector = ["new", [_key, _position, _grid]] call OO_SECTOR;
					"Draw" call _sector;
					["Put", [_key, _sector]] call global_zone_hashmap;
				};
			};
			global_new_zone set [0,-1];
			global_new_zone = global_new_zone - [-1];
		};
		sleep 0.1;
	};
