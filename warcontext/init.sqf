	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014-2018 Nicolas BOITEUX
	
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
		"_sectorsize",
		"_exist"
	];

	call compilefinal preprocessFileLineNumbers "warcontext\scripts\paramsarray_parser.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\config.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\scripts\BME_serverhandler.sqf";

	WC_fnc_setskill	 	= compileFinal preprocessFileLineNumbers "warcontext\scripts\WC_fnc_setskill.sqf";
	WC_fnc_computezone		= compileFinal preprocessFileLineNumbers "warcontext\scripts\WC_fnc_computezone.sqf";
	WC_fnc_patrol			= compileFinal preprocessFileLineNumbers "warcontext\scripts\WC_fnc_patrol.sqf";
	WC_fnc_setskill		= compileFinal preprocessFileLineNumbers "warcontext\scripts\WC_fnc_setskill.sqf";
	WC_fnc_vehiclehandler	= compileFinal preprocessFileLineNumbers "warcontext\scripts\WC_fnc_vehiclehandler.sqf";
	WC_fnc_spawngroup		= compileFinal preprocessFileLineNumbers "warcontext\scripts\WC_fnc_spawngroup.sqf";
	WC_fnc_servicing		= compileFinal preprocessFileLineNumbers "warcontext\scripts\WC_fnc_servicing.sqf";
	WC_fnc_fueldepot		= compileFinal preprocessFileLineNumbers "warcontext\missions\WC_fnc_fueldepot.sqf";

	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_artillery.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_antiair.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_atc.sqf";
	call compilefinal preprocessFileLineNumbers "client\objects\oo_bme.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_bonusvehicle.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_convoy.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_controller.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_dogfight.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_hashmap.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_factory.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_grid.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_group.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_mission.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_supply.sqf";
	call compilefinal preprocessFileLineNumbers "client\objects\oo_marker.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_patrol.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_patrolair.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_patrolvehicle.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_playervehicle.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_score.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_sector.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_ticket.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_queue.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_pathfinding.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_basegenerator.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_namegenerator.sqf";

	if(!local player) then {
		global_bme = "new" call OO_BME;
		"bme_addqueue" addPublicVariableEventHandler {
			["addReceiveQueue", _this select 1] call global_bme;
		};
	};

	_size = getNumber (configfile >> "CfgWorlds" >> worldName >> "mapSize");
	_sectorsize = 100;
	
	global_grid = ["new", [0,0, _size, _size,_sectorsize,_sectorsize]] call OO_GRID;
	global_namegenerator = "new" call OO_NAMEGENERATOR;

	[] execVM "real_weather\real_weather.sqf";

	// generate random position for base
	global_base  = "new" call OO_BASEGENERATOR;

	// CONFIG VARIABLE 

	// square distance enemi unpop/pop
	// wcpopsquaredistance = 3;

	wcserverpassword = "serverisme";

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

	// antiair vehicles
	wcantiairvehicles = ["O_APC_Tracked_02_AA_F"];

	// artillery vehicles
	wcartilleryvehicles = ["O_MBT_02_arty_F"];

	// plane dogfight
	wcplanevehicles = ["O_Plane_CAS_02_F"];

	switch (wcpopvehicleenemyparam ) do {
		case 1 :{wcpopvehicleenemy = true; };
		case 2: {wcpopvehicleenemy = false;};
		default {wcpopvehicleenemy = true;};
	};

	// pop chopper probabilities by sector
	switch (wcpopchopperprobparam) do {
		case 1: {wcpopchopperprob = 0.9;};
		case 2: {wcpopchopperprob = 0.97;};
		case 3: {wcpopchopperprob = 1;};
		default {wcpopchopperprob = 0.97;};
	};

	// pop a convoy every x seconds
	switch (wcpopconvoyprobparam) do {
		case 1: {wcconvoytime = 180;};
		case 2: {wcconvoytime = 300;};
		case 3: {wcconvoytime = 1800;};
		case 4: {wcconvoytime = 0;};
		default {wcconvoytime = 180;};
	};
	
	// pop ground vehicles probabilities by sector
	wcpopvehicleprob = 0.85;

	// pop sniper probabilities by sector
	wcpopsniperprob = 0.85;

	// pop artillery probabilities by sector
	wcpopartyprob = 0.98;

	// pop artillery probabilities by sector
	wcpopantiairprob = 0.85;

	// pop additional infantry group probabilty
	wcpopinfantryprob = 0.90;

	//////////////////////
	// Do not edit below :)
	//////////////////////

	_vehicleslist = "((getNumber (_x >> 'scope') >= 2) && (getNumber (_x >> 'side') in [0,2]) && (getText (_x >> 'vehicleClass') in ['rhs_vehclass_apc'] ))" configClasses (configFile >> "CfgVehicles");
	if(count _vehicleslist > 0) then {
		wclightvehicles = [];
		{ wclightvehicles = wclightvehicles + [ configName _x]; } foreach _vehicleslist;			
	};


	_vehicleslist = "((getNumber (_x >> 'scope') >= 2) && (getNumber (_x >> 'side') in [0,2]) && (getText (_x >> 'vehicleClass') in ['rhs_vehclass_tank'] ))" configClasses (configFile >> "CfgVehicles");
	if(count _vehicleslist > 0) then {
		wcheavyvehicles = [];
		{ wcheavyvehicles = wcheavyvehicles + [ configName _x]; } foreach _vehicleslist;
	};

	_vehicleslist = "((getNumber (_x >> 'scope') >= 2) && (getNumber (_x >> 'side') in [0,2]) && (getText (_x >> 'vehicleClass') in ['rhs_vehclass_helicopter'] ))" configClasses (configFile >> "CfgVehicles");
	if(count _vehicleslist > 0) then {
		wcairchoppers = [];
		{ wcairchoppers = wcairchoppers + [ configName _x]; } foreach _vehicleslist;
	};

	_vehicleslist = "((getNumber (_x >> 'scope') >= 2) && (getNumber (_x >> 'side') in [0,2]) && (getText (_x >> 'vehicleClass') in ['rhs_vehclass_aircraft'] ))" configClasses (configFile >> "CfgVehicles");
	if(count _vehicleslist > 0) then {
		wcplanevehicles = [];
		{ wcplanevehicles = wcplanevehicles + [ configName _x]; } foreach _vehicleslist;
	};

	/*
	configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry"
	configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry_emr"
	configfile >> "CfgGroups" >> "East" >> "rhs_faction_vdv" >> "rhs_group_rus_vdv_infantry"
	configfile >> "CfgGroups" >> "East" >> "rhs_faction_vdv" >> "rhs_group_rus_vdv_infantry_flora"
	configfile >> "CfgGroups" >> "East" >> "rhs_faction_vdv" >> "rhs_group_rus_vdv_infantry_mflora"
	configfile >> "CfgGroups" >> "East" >> "rhs_faction_vdv" >> "rhs_group_rus_vdv_infantry_recon"
	*/
	
	wcrhsinfantrysquads = [];

	"wcrhsinfantrysquads pushBack _x" configClasses (configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry");
	"wcrhsinfantrysquads pushBack _x" configClasses (configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry_emr");
	"wcrhsinfantrysquads pushBack _x" configClasses (configfile >> "CfgGroups" >> "East" >> "rhs_faction_vdv" >> "rhs_group_rus_vdv_infantry");
	"wcrhsinfantrysquads pushBack _x" configClasses (configfile >> "CfgGroups" >> "East" >> "rhs_faction_vdv" >> "rhs_group_rus_vdv_infantry_flora");
	"wcrhsinfantrysquads pushBack _x" configClasses (configfile >> "CfgGroups" >> "East" >> "rhs_faction_vdv" >> "rhs_group_rus_vdv_infantry_mflora");
	"wcrhsinfantrysquads pushBack _x" configClasses (configfile >> "CfgGroups" >> "East" >> "rhs_faction_vdv" >> "rhs_group_rus_vdv_infantry_recon");

	onPlayerDisconnected {
		private ["_name"];
		{
			if(name _x == _name) then {
				_x setdammage 1;
				deletevehicle _x;
			};
			sleep 0.001;
		}foreach allPlayers;
		_name = format["%1_OO_MRK_%2", _name, 1];
		deletemarker _name;
	};

	onPlayerConnected {
		"send" call global_ticket;
	};


	global_zone_hashmap  = ["new", []] call OO_HASHMAP;
	global_controller = ["new", []] call OO_CONTROLLER;
	global_scores = ["new", []] call OO_HASHMAP;
	global_vehicles = ["new", []] call OO_HASHMAP;
	global_ticket = ["new", wcnumberofticket] call OO_TICKET;
	global_atc = "new" call OO_ATC;
	global_factory = "new" call OO_FACTORY;
	global_dogfight = ["new", [global_atc]] call OO_DOGFIGHT;

	"queueSector" spawn global_controller;
	"startZone" spawn global_controller;
	"startParaDrop" spawn global_controller;

	 (_size/_sectorsize) call WC_fnc_computezone;

	"start" spawn global_dogfight;
	"start" spawn global_atc;
	"start" spawn global_factory;

	// init for slow server
	sleep 10;

	"startConvoy" spawn global_controller;
	["setActive", true] call global_ticket;

	[] spawn {
		private ["_list"];
		
		while { true } do {	
			_list = nearestObjects [getMarkerPos "respawn_west", ["TRUCK", "CAR", "TANK"], 25];
			sleep 1;
			if(count _list > 0) then { 
				{
					_x call WC_fnc_servicing;
				} foreach _list;
			};
			sleep 30;
		};
	};

	// put every players in the same group
	[] spawn {
		private ["_group"];
		_group = createGroup west;

		while { true } do {
			allPlayers joinSilent _group;
			sleep 5;
		};
	};

	_end = false;
	while { !_end} do {
		if("checkVictory" call global_controller) then {
			{
				"flushBDD" call _x;
			} foreach ("entrySet" call global_scores);
			"End1" call BIS_fnc_endMissionServer;
			_end = true;
		};
		if("getTicket" call global_ticket < 1)then {
			{
				"flushBDD" call _x;
			} foreach ("entrySet" call global_scores);
			"epicFail" call BIS_fnc_endMissionServer;
			_end = true;
		};
		sleep 30;
	};

	// Kick player before missions restart
	serverCommand format ["#login %1", wcserverpassword];
	{
		serverCommand format ["#kick %1",_name];
	} forEach allPlayers;