	// -----------------------------------------------
	// Author: team  code34 nicolas_boiteux@yahoo.fr
	// Dynamic zone
	// -----------------------------------------------
	if (!isServer) exitWith{};

	private [
		"_around",
		"_key",
		"_globalindex",
		"_position",
		"_sector",
		"_exist"
	];

	call compilefinal preprocessFileLineNumbers "client\oo_marker.sqf";
	call compilefinal preprocessFileLineNumbers "client\BME\init.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\scripts\paramsarray_parser.sqf";

	WC_fnc_skill	 	= compile preprocessFile "warcontext\scripts\WC_fnc_setskill.sqf";
	WC_fnc_computezone	= compile preprocessFile "warcontext\scripts\WC_fnc_computezone.sqf";
	WC_fnc_patrol		= compile preprocessFile "warcontext\scripts\WC_fnc_patrol.sqf";
	WC_fnc_setskill		= compile preprocessFile "warcontext\scripts\WC_fnc_setskill.sqf";
	WC_fnc_vehiclehandler	= compile preprocessFile "warcontext\scripts\WC_fnc_vehiclehandler.sqf";

	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_artillery.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_hashmap.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_grid.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_sector.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_patrolair.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_bonusvehicle.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_dogfight.sqf";

	[] execVM "real_weather\real_weather.sqf";
	_temp = "Land_LampDecor_F" createVehicle (getMarkerPos "base_lamp");


	global_sector_attack = [];
	global_sector_done = [];
	global_new_zone = [];

	onPlayerDisconnected {
		private ["_name"];
		{
			if(name _x == _name) then {
				_x setdammage 1;
				deletevehicle _x;
			};
		}foreach playableUnits;
		_name = format["%1_OO_MRK_%2", _name, 1];
		deletemarker _name;
	};

	global_zone_hashmap  = [] call WC_fnc_computezone;
	global_zone_done = ["new", []] call OO_HASHMAP;
	global_player_hashmap = ["new", []] call OO_HASHMAP;

	_grid = ["new", [31000,31000,100,100]] call OO_GRID;

	_position = getmarkerpos "bonus";
	["new", [_position]] spawn OO_BONUSVEHICLE;

	//[] spawn WC_fnc_patrol_air2;
	_dogfight = ["new", []] call OO_DOGFIGHT;
	"startPatrol" spawn _dogfight;
	
	while { "Size" call global_zone_hashmap > 0 } do {
		{			
			if((side _x == west) and ((position _x) select 2 < 5)) then {
				_sector = ["getSectorFromPos", position _x] call _grid;
				if(["containsKey", [name _x]] call global_player_hashmap) then {
					_bck_sector = ["Get", [name _x]] call global_player_hashmap;
					if(format ["%1", _bck_sector] != format["%1", _sector]) then {
						["Set", [name _x, _sector]] call global_player_hashmap;
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
					["Put", [name _x, _sector]] call global_player_hashmap;
				};
			};
			sleep 0.001;
		} foreach playableunits;
		sleep 0.1;
	};

	end = "win";
	["end", "all"] call BME_fnc_publicvariable;