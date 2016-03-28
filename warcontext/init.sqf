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
	WC_fnc_spawngroup	= compile preprocessFile "warcontext\scripts\WC_fnc_spawngroup.sqf";

	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_artillery.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_antiair.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_atc.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_bonusvehicle.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_convoy.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_controller.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_dogfight.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_hashmap.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_grid.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_group.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_mission.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_supply.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_patrol.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_patrolair.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_playervehicle.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_score.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_sector.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_ticket.sqf";

	[] execVM "real_weather\real_weather.sqf";

	{ _x hideObjectGlobal true } foreach (nearestTerrainObjects [getMarkerPos "base_lamp",[], 100]);
	_temp = "Land_LampAirport_F" createVehicle (getMarkerPos "base_lamp");

	// CONFIG VARIABLE 

	// square distance enemi unpop/pop
	// wcpopsquaredistance = 3;

	// enemies light vehicles type
	wclightvehicles = ["O_MRAP_02_hmg_F","O_MRAP_02_gmg_F","I_MRAP_03_hmg_F","I_MRAP_03_gmg_F", "B_G_Offroad_01_armed_F"];

	// enemies heavy vehicles type
	wcheavyvehicles = ["O_APC_Tracked_02_cannon_F","O_APC_Tracked_02_AA_F","O_MBT_02_cannon_F","O_APC_Wheeled_02_rcws_F","O_APC_Wheeled_02_rcws_F"];

	// enemies infantry squad
	wcinfantrysquads = ["OIA_InfSquad_Weapons","OIA_InfSquad", "OIA_InfTeam", "OIA_InfTeam_AA", "OIA_InfTeam_AT", "OI_ReconTeam"] ;

	//enemies infantry snipers
	wcinfantrysnipers = ["OI_SniperTeam"];

	//enemies chopper
	wcairchoppers = ["O_Heli_Attack_02_F", "O_Heli_Attack_02_black_F", "O_Heli_Light_02_F", "O_Heli_Light_02_v2_F"];

	// pop chopper probabilities by sector
	switch (wcpopchopperprobparam) do {
		case 1: {wcpopchopperprob = 0.9;};
		case 2: {wcpopchopperprob = 0.97;};
		case 3: {wcpopchopperprob = 1;};
		default {wcpopchopperprob = 0.97;};
	};

	// pop a convoy every x seconds
	switch (wcpopconvoyprobparam) do {
		case 1: {wcconvoytime = 1800;};
		case 2: {wcconvoytime = 3600;};
		case 3: {wcconvoytime = 0;};
		default {wcconvoytime = 1800;};
	};
	
	// pop ground vehicles probabilities by sector
	wcpopvehicleprob = 0.90;

	// pop sniper probabilities by sector
	wcpopsniperprob = 0.85;

	// pop artillery probabilities by sector
	wcpopartyprob = 0.7;

	// pop artillery probabilities by sector
	wcpopantiairprob = 0.7;

	// pop additional infantry group probabilty
	wcpopinfantryprob = 0.90;

	onPlayerDisconnected {
		private ["_name"];
		{
			if(name _x == _name) then {
				_x setdammage 1;
				deletevehicle _x;
			};
			sleep 0.001;
		}foreach playableUnits + allDead;
		_name = format["%1_OO_MRK_%2", _name, 1];
		deletemarker _name;
	};

	global_grid = ["new", [0,0, 31000,31000,100,100]] call OO_GRID;
	global_zone_hashmap  = ["new", []] call OO_HASHMAP;
	global_controller = ["new", []] call OO_CONTROLLER;
	global_scores = ["new", []] call OO_HASHMAP;
	global_vehicles = ["new", []] call OO_HASHMAP;
	global_ticket = ["new", wcnumberofticket] call OO_TICKET;
	global_atc = ["new", []] call OO_ATC;
	global_dogfight = ["new", [global_atc]] call OO_DOGFIGHT;

	"queueSector" spawn global_controller;
	"startZone" spawn global_controller;
	[] call WC_fnc_computezone;
	
	"start" spawn global_dogfight;
	"start" spawn global_atc;

	// init for slow server
	sleep 120;

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

	//end = "win";
	//["end", "all"] call BME_fnc_publicvariable;

	"End1" call BIS_fnc_endMissionServer;