	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014-2017 Nicolas BOITEUX

	CLASS OO_SECTOR STRATEGIC GRID
	
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

	#include "oop.h"

	CLASS("OO_SECTOR")
		PRIVATE STATIC_VARIABLE("scalar","index");
		PRIVATE VARIABLE("bool","alert");
		PRIVATE VARIABLE("string","marker");
		PRIVATE VARIABLE("array","sector");
		PRIVATE VARIABLE("scalar","state");
		PRIVATE VARIABLE("array","position");
		PRIVATE VARIABLE("array","unitstype");
		PRIVATE VARIABLE("array","units");
		PRIVATE VARIABLE("bool","artilleryactive");
		PRIVATE VARIABLE("code","artillery");
		PRIVATE VARIABLE("bool","antiairactive");
		PRIVATE VARIABLE("code","antiair");
		PRIVATE VARIABLE("scalar","bucket");
		PRIVATE VARIABLE("code","this");

		PUBLIC FUNCTION("array","constructor") {
			private _index = MEMBER("index",nil);
			if (isNil "_index") then {_index = 0;};
			_index = _index + 1;
			MEMBER("index",_index);
			MEMBER("alert", false);
			MEMBER("marker", "");
			MEMBER("sector", _this select 0);
			MEMBER("position", _this select 1);
			MEMBER("state", 0);
			MEMBER("units", []);
			MEMBER("bucket", 0);
			private _sniper = 0;
			if(random 1 > wcpopsniperprob) then { _sniper = 1; };
			private _air = 0;
			if((random 1 > wcpopchopperprob) and (wcpopvehicleenemy)) then { _air = 1; };
			private _vehicle = 0;
			if((random 1 > wcpopvehicleprob) and (wcpopvehicleenemy)) then { _vehicle = 1;};
			private _infantry = 1;
			if(random 1 > wcpopinfantryprob) then { _infantry = 2;};
			private _type = [_infantry, _sniper, _vehicle, _air];
			MEMBER("unitstype", _type);
			if((random 1 > wcpopartyprob) and (wcpopvehicleenemy)) then { MEMBER("artilleryactive", true);} else {MEMBER("artilleryactive", false);};
			if(random 1 > wcpopantiairprob) then { MEMBER("antiairactive", true);} else {MEMBER("antiairactive", false);};
		};

		PUBLIC FUNCTION("","getIndex") FUNC_GETVAR("index");
		PUBLIC FUNCTION("","getSector") FUNC_GETVAR("sector");
		PUBLIC FUNCTION("","getMarker") FUNC_GETVAR("marker");
		PUBLIC FUNCTION("","getAlert") FUNC_GETVAR("alert");
		PUBLIC FUNCTION("","getArtillery") FUNC_GETVAR("artillery");
		PUBLIC FUNCTION("","getAntiAir") FUNC_GETVAR("antiair");
		PUBLIC FUNCTION("","getPosition") FUNC_GETVAR("position");
		PUBLIC FUNCTION("","getState") FUNC_GETVAR("state");
		PUBLIC FUNCTION("", "getThis") { MEMBER("this", nil); };

		// state (0:unspawn, 1:spawn, 2:completed) 
		PRIVATE FUNCTION("scalar", "setState") {
			MEMBER("state", _this);
		};

		PUBLIC FUNCTION("", "setSupply") {
			private _supplys = ["Land_i_House_Small_03_V1_F", "Land_Shed_Big_F", "Land_Hospital_main_F", "Land_u_Addon_02_V1_F", "Land_i_Barracks_V2_F", "Land_Lighthouse_small_F", "Land_Airport_Tower_F", "Land_Hangar_F", "Land_dp_bigTank_F", "Land_dp_mainFactory_F", "Land_dp_smallTank_F", "Land_dp_transformer_F", "Land_Factory_Main_F", "Land_FuelStation_Feed_F", "Land_fs_feed_F", "Land_IndPipe1_ground_F", "Land_HighVoltageEnd_F", "Land_HighVoltageTower_F", "Land_HighVoltageTower_largeCorner_F", "Land_ReservoirTank_Airport_F", "Land_ReservoirTank_V1_F", "Land_ReservoirTower_F", "Land_Tank_rust_F", "Land_TTowerBig_1_F", "Land_TBox_F", "Land_TTowerBig_2_F", "MetalBarrel_burning_F", "Land_MetalBarrel_F", "Land_Cargo_House_V1_F", "Land_Cargo_House_V2_F", "Land_Cargo_House_V3_F", "Land_Cargo_HQ_V1_F", "Land_Cargo_HQ_V2_F", "Land_Cargo_HQ_V3_F", "Land_Cargo_Patrol_V1_F", "Land_Cargo_Patrol_V2_F", "Land_Cargo_Patrol_V3_F", "Land_Cargo_Tower_V1_F", "Land_Cargo_Tower_V2_F", "Land_Cargo_Tower_V3_F", "Land_Radar_F", "Land_MilOffices_V1_F", "Land_Radar_Small_F", "Land_Dome_Small_F", "Land_Research_house_V1_F", "Land_Research_HQ_F", "Land_Offices_01_V1_F", "Land_dp_mainFactory_F", "Land_dp_smallFactory_F", "Land_Factory_Main_F", "Land_PowerLine_distributor_F", "Land_i_Shed_Ind_F", "Land_TTowerSmall_2_F"];
			private _list = nearestObjects [MEMBER("position", nil), _supplys,  50];
			sleep 0.5;
			{ ["new", _x] call OO_SUPPLY; }foreach _list;
		};

		PUBLIC FUNCTION("", "isArtillery") {
			private _result = false;
			private _artillery = objNull;
			if(MEMBER("artilleryactive", nil)) then {
				_artillery = "getVehicle" call MEMBER("artillery", nil);
				if!(isnil "_artillery") then {
					if(getdammage _artillery < 0.9) then { _result = true; };
				};
			};
			_result;
		};

		PUBLIC FUNCTION("", "isAntiAir") {
			private _result = false;
			private _antiair = objNull;
			if(MEMBER("antiairactive", nil)) then {
				_antiair = "getVehicle" call MEMBER("antiair", nil);
				if!(isnil "_antiair") then {
					if(getdammage _antiair < 0.9) then { _result = true; };
				};
			};
			_result;
		};		

		PUBLIC FUNCTION("", "popArtillery") {
			private _position = [MEMBER("position", nil), 3000,5000,10,0,3,0] call BIS_fnc_findSafePos;
			private _artillery = ["new", [_position]] call OO_ARTILLERY;
			MEMBER("artillery", _artillery);
		};

		PUBLIC FUNCTION("", "popAntiAir") {
			private _position = [MEMBER("position", nil), 1000,2000,10,0,3,0] call BIS_fnc_findSafePos;
			private _antiair = ["new", [_position]] call OO_ANTIAIR;
			MEMBER("antiair", _antiair);
		};

		PUBLIC FUNCTION("", "draw") {
			private _marker = createMarker [format["mrk%1", MEMBER("index", nil)], MEMBER("position", nil)];
			_marker setMarkerShape "RECTANGLE";
			_marker setmarkerbrush "Solid";
			_marker setmarkercolor "ColorRed";
			_marker setmarkersize [50,50];
			MEMBER("marker", _marker);
		};

		PUBLIC FUNCTION("", "unDraw") {
			deletemarker MEMBER("marker", nil);
		};

		PUBLIC FUNCTION("", "popSector") {
			private _unitstype = MEMBER("unitstype", nil);
			private _units = [];
			private _object = MEMBER("getThis", nil);
			private _type = [];

			if(MEMBER("artilleryactive", nil)) then { MEMBER("popArtillery", nil); };
			if(MEMBER("antiairactive", nil)) then { MEMBER("popAntiAir", nil); };

			for "_i" from 1 to (_unitstype select 0) step 1 do {
				{ _units pushBack _x;} foreach MEMBER("popInfantry", nil);
				sleep 0.01;
			};

			for "_i" from 1 to (_unitstype select 2) step 1 do {
				{ _units pushBack _x;} foreach MEMBER("popSniper", nil);
				sleep 0.01;
			};
										
			for "_i" from 1 to (_unitstype select 2) step 1 do {
				{ _units pushBack _x;} foreach MEMBER("popVehicle", nil);
				sleep 0.01;
			};
		
			for "_i" from 1 to (_unitstype select 3) step 1 do {
				MEMBER("popAir", nil);
				sleep 0.01;
			};
			_type = [ 1, (_unitstype select 1), (_unitstype select 2), 0];
			MEMBER("unitstype", _type);
			MEMBER("units", _units);
		};

		PUBLIC FUNCTION("", "unPopSector") {
			private _group = [];

			{
				_group pushBackUnique (group _x);
				_x removeEventHandler ["killed", 0];
				_x setdammage 1;
				deletevehicle _x;
				sleep 0.01;
			}foreach MEMBER("units", nil);

			{
				deleteGroup _x;
				sleep 0.01;
			}foreach _group;

			if(MEMBER("artilleryactive", nil)) then { ["delete", MEMBER("artillery", nil)] call OO_ARTILLERY; };
			if(MEMBER("antiairactive", nil)) then { ["delete", MEMBER("antiair", nil)] call OO_ANTIAIR; };
			MEMBER("units", []);
		};

		// recupere tous les sectors dans lesquels patrouilles les unites AI
		PUBLIC FUNCTION("", "occupedSector") {
			private _sectors = [];
			private _sector = [];
			{
				_sector = ["getSectorFromPos", position _x] call global_grid;
				_sectors pushBackUnique _sector;
				sleep 0.0001;
			}foreach MEMBER("units", nil);
			_sectors pushBackUnique MEMBER("sector", nil);
			_sectors;
		};

		PUBLIC FUNCTION("", "spawn") {
			MEMBER("state", 1);
			MEMBER("marker", nil) setmarkercolor "ColorOrange";
			MEMBER("popSector", nil);
			private _sector = MEMBER("sector", nil);
			private _sectors = [];
			private _position = MEMBER("position", nil);
			private _time = 0;
			private _deadcounter = 0;
			private _unpopsquaredistance = wcpopsquaredistance + 2;
			private _run = true;
			private _units = 0;
			private _cost = 0;
			private _cost2 = 0;
			private _mincost = 100;
			private _bucket = 0;
			private _player_sector = [];
			
			while { _run } do {
				_run = false;
				_units = 0;
				_mincost = 100;
				_bucket = 0;
				_sectors = MEMBER("occupedSector", nil);

				{
					if(side _x isEqualTo west) then {
						_player_sector = ["getSectorFromPos", position _x] call global_grid;
						{
							_cost = ["GetEstimateCost", [_player_sector, _x]] call global_grid;
							if(_cost < _mincost) then { _mincost = _cost;};
							sleep 0.0001;
						}foreach _sectors;
						_cost2 = ["GetEstimateCost", [_player_sector, _sector]] call global_grid;
						if(_cost2 < _unpopsquaredistance) then {_bucket = _bucket + 1;};
					};
					sleep 0.0001;
				}foreach playableunits;

				//stocke le nombre max de joueurs dans la zone pour calcul du prochain expand
				if(MEMBER("bucket", nil) < _bucket) then { MEMBER("bucket", _bucket);};

				// change la couleur du marker en fonction de si la patrouille est en alerte ou pas
				// conserve le sector comme actif
				if(MEMBER("alert", nil) and (_mincost < _unpopsquaredistance)) then {
					MEMBER("marker", nil) setmarkercolor "ColorYellow";
					_run = true;
				} else {
					if(_mincost < _unpopsquaredistance) then {
						MEMBER("marker", nil) setmarkercolor "ColorOrange";
						_run = true;
					};
				};

				// verifie si les unites patrouillant sont à moins de 2000m du sector
				// sinon les considère comme mortes
				{
					if((alive _x) and (_position distance _x < 2000)) then { _units = _units + 1;};
					sleep 0.01
				}foreach MEMBER("units", nil);

				// other way to write it
				//_units = {(alive _x) and (_position distance _x < 2000)} count MEMBER("units", nil);  // returns the number of alive units

				if(_units == 0) then { _run = false; };
				if(_units < 3)then { _deadcounter = _deadcounter + 1;};
				if(_deadcounter > 500) then { _units = 0; _run = false;};
				sleep 1;
			};

			if(_units == 0) then {
				MEMBER("setVictory", nil);
			} else {
				MEMBER("UnSpawn", nil);
			};
		};

		PUBLIC FUNCTION("", "setVictory") {
			MEMBER("marker", nil) setmarkercolor "ColorBlue";
			MEMBER("state", 2);
			["setTicket", "bluezone"] call global_ticket;
			["remoteSpawn", ["BME_netcode_client_wcsectorcompleted", MEMBER("getSector", nil), "client"]] call global_bme;
			private _position = [MEMBER("getPosition", nil), 0,50,5,0,3,0] call BIS_fnc_findSafePos;
			["new", _position] spawn OO_BONUSVEHICLE;
			MEMBER("unPopSector", nil);
			sleep 120;
			["deleteSector", MEMBER("getSector", nil)] call global_controller;
		};

		PUBLIC FUNCTION("bool", "setAlert") {
			MEMBER("alert", _this);
		};

		PUBLIC FUNCTION("", "UnSpawn") {
			MEMBER("marker", nil) setmarkercolor "ColorRed";
			MEMBER("unPopSector", nil);
			if(MEMBER("getAlert", nil)) then { 
				["setTicket", "redzone"] call global_ticket;
				["expandSectorAround", [MEMBER("getSector", nil), floor(random 2)]] call global_controller;
				["expandAlertAround", MEMBER("getThis", nil)] call global_controller;
			};
			MEMBER("state", 0);
			MEMBER("bucket", 0);
		};

		PRIVATE FUNCTION("", "popInfantry") {
			private _marker	=  MEMBER("marker", nil);	
			private _position 	= getmarkerpos _marker;
			private _markersize	= (getMarkerSize _marker) select 1;
			private _type = "";
		
			if(count wcrhsinfantrysquads == 0) then {
				_type = selectRandom wcinfantrysquads;
			} else {
				_type = selectRandom wcrhsinfantrysquads;
			};

			_position = _position findEmptyPosition [0,50];
			if(_position isEqualTo []) exitWith {[];};

			private _group = "";		
			if(count wcrhsinfantrysquads == 0) then {
				_group = [_position, east, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "infantry" >> _type)] call WC_fnc_spawngroup;
			} else {
				_group = [_position, east, _type] call WC_fnc_spawngroup;
			};
		
			{
				[_x, _type] spawn WC_fnc_setskill;
				sleep 0.1;
			}foreach (units _group);
			
			private _patrol = ["new", [_group, MEMBER("getThis", nil), _markersize]] call OO_PATROL;
			"patrol" spawn _patrol;
			units _group;
		};


		PUBLIC FUNCTION("", "popParachute") {
			private _marker	=  MEMBER("marker", nil);		
			private _markerpos 	= getmarkerpos _marker;
			private _markersize	= (getMarkerSize _marker) select 1;
			private _state 		= MEMBER("state", nil);
			private _type = "";

			if!(_state isEqualTo 1) exitWith {[];};
		
			if(count wcrhsinfantrysquads == 0) then {
				_type = selectRandom wcinfantrysquads;
			} else {
				_type = selectRandom wcrhsinfantrysquads;
			};
				
			private _group = "";
			if(count wcrhsinfantrysquads == 0) then {
				_group = [[0,0,0], east, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "infantry" >> _type)] call WC_fnc_spawngroup;
			} else {
				_group = [[0,0,0], east, _type] call WC_fnc_spawngroup;
			};
		
			private _chute = objNull;
			{
				[_x, _type] spawn WC_fnc_setskill;
				_chute = "Steerable_Parachute_F" createVehicle [0,0,0]; 
				_chute setPos [getPos _x select 0, getPos _x select 1, 200]; 
				_x moveIndriver _chute;
				sleep 0.1;
			}foreach (units _group);
			
			private _patrol = ["new", [_group, MEMBER("getThis", nil), _markersize]] call OO_PATROL;
			"patrol" spawn _patrol;
			{MEMBER("units", nil) pushBack _x;} foreach (units _group);
		};


		PRIVATE FUNCTION("", "popSniper") {
			private _marker 	=  MEMBER("marker", nil);		
			private _position 	= getmarkerpos _marker;
			private _markersize	= (getMarkerSize _marker) select 1;
			private _type = selectRandom wcinfantrysnipers;

			_position = _position findEmptyPosition [0,50];
			if(_position isEqualTo []) exitWith {[];};		

			private _group = [_position, east, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "infantry" >> _type)] call BIS_fnc_spawnGroup;
			{
				[_x, _type] spawn WC_fnc_setskill;
				sleep 0.1;
			}foreach (units _group);
		
			private _patrol = ["new", [_group, MEMBER("getThis", nil), _markersize]] call OO_PATROL;
			"patrol" spawn _patrol;
			units _group;
		};


		PRIVATE FUNCTION("", "popVehicle") {
			private _marker	=  MEMBER("marker", nil);
			private _position 	= getmarkerpos _marker;
			private _markersize	= (getMarkerSize _marker) select 1;
			private _vehicle = "";
			private _units = [];
			private _array = [];
			private _group = "";

			if(random 1 > 0.5) then {
				_vehicle = selectRandom wclightvehicles;
			} else {
				_vehicle = selectRandom wcheavyvehicles;
			};

			_position = _position findEmptyPosition [0,50];
			if(_position isEqualTo []) exitWith {[];};					
			
			_array = [_position, random 359, _vehicle, east] call bis_fnc_spawnvehicle;
			_vehicle = _array select 0;
			_group = _array select 2;
			
			[_vehicle] spawn WC_fnc_vehiclehandler;			
			private _patrol = ["new", [_vehicle, _group, MEMBER("getThis", nil)]] call OO_PATROLVEHICLE;
			"patrol" spawn _patrol;
			
			{
				_handle = [_x, ""] spawn WC_fnc_setskill;
				sleep 0.1;
			}foreach (units _group);
			_units = units _group + [_vehicle];
			_units;
		};

		PRIVATE FUNCTION("", "popAir") {
			if("countEast" call global_atc > 0) then {
				private _marker = selectRandom ("getEast" call global_atc);
				private _position = getmarkerpos _marker;
				_position = [_position select 0, _position select 1, 100];	
				private _list = _position nearEntities [["Man", "Tank"], 1500];
				sleep 0.2;
				if(west countside _list isEqualTo 0) exitwith {
					_patrol = ["new", [MEMBER("getThis", nil), _position]] call OO_PATROLAIR;
					"patrol" spawn _patrol;	
				};
			};
		};


		PUBLIC FUNCTION("","deconstructor") { 
			DELETE_VARIABLE("alert");
			DELETE_VARIABLE("bucket");
			DELETE_VARIABLE("index");
			deletemarker MEMBER("marker", nil);
			DELETE_VARIABLE("marker");
			DELETE_VARIABLE("sector");
			DELETE_VARIABLE("position");
			DELETE_VARIABLE("units");
			DELETE_VARIABLE("unitstype");
			DELETE_VARIABLE("state");
			DELETE_VARIABLE("artilleryactive");
			["delete", MEMBER("artillery", nil)] call OO_ARTILLERY;
			DELETE_VARIABLE("artillery");
			DELETE_VARIABLE("antiairactive");
			["delete", MEMBER("antiair", nil)] call OO_ANTIAIR;
			DELETE_VARIABLE("antiair");
			DELETE_VARIABLE("this");
		};
	ENDCLASS;