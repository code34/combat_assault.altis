	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014 Nicolas BOITEUX
	
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.
	
	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	
	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>. 
	*/

	if (!isServer) exitWith{};

	private [
		"_around",
		"_end",
		"_key",
		"_globalindex",
		"_position",
		"_sector",
		"_exist"
	];

	call compilefinal preprocessFileLineNumbers "warcontext\scripts\paramsarray_parser.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\config.sqf";
	call compilefinal preprocessFileLineNumbers "client\objects\oo_marker.sqf";
	call compilefinal preprocessFileLineNumbers "client\BME\init.sqf";

	WC_fnc_setskill	 	= compile preprocessFile "warcontext\scripts\WC_fnc_setskill.sqf";
	WC_fnc_computezone	= compile preprocessFile "warcontext\scripts\WC_fnc_computezone.sqf";
	WC_fnc_patrol		= compile preprocessFile "warcontext\scripts\WC_fnc_patrol.sqf";
	WC_fnc_setskill		= compile preprocessFile "warcontext\scripts\WC_fnc_setskill.sqf";
	WC_fnc_vehiclehandler	= compile preprocessFile "warcontext\scripts\WC_fnc_vehiclehandler.sqf";

	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_artillery.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_atc.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_bonusvehicle.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_convoy.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_controller.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_dogfight.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_hashmap.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_grid.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_group.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_mission.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_node.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_patrol.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_patrolair.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_score.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_sector.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_ticket.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_tree.sqf";

	[] execVM "real_weather\real_weather.sqf";
	_temp = "Land_LampDecor_F" createVehicle (getMarkerPos "base_lamp");

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

	global_zone_hashmap  = ["new", []] call OO_TREE;
	global_controller = ["new", []] call OO_CONTROLLER;
	global_scores = ["new", []] call OO_TREE;
	global_ticket = ["new", []] call OO_TICKET;
	global_atc = ["new", []] call OO_ATC;
	global_dogfight = ["new", []] call OO_DOGFIGHT;
	
	"queueSector" spawn global_controller;
	"startZone" spawn global_controller;
	[global_zone_hashmap] call WC_fnc_computezone;
	
	"startPatrol" spawn global_dogfight;
	"start" spawn global_atc;

	// check all sector for victory
	sleep 30;
	"startConvoy" spawn global_controller;
	["setActive", true] call global_ticket;

	_end = false;
	while { !_end} do {
		if("checkVictory" call global_controller) then {
			_end = true;	
		};
		sleep 60;
	};

	// write scores on media
	{
		"flushBDD" call _x;
	} foreach ("entrySet" call global_scores);

	end = "win";
	["end", "all"] call BME_fnc_publicvariable;