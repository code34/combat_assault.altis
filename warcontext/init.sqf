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
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_bonusvehicle.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_controller.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_dogfight.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_hashmap.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_grid.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_group.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_patrolair.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_sector.sqf";

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

	_dogfight = ["new", []] call OO_DOGFIGHT;
	"startPatrol" spawn _dogfight;

	global_controller = ["new", []] call OO_CONTROLLER;
	"startController" call global_controller;

	//end = "win";
	//["end", "all"] call BME_fnc_publicvariable;