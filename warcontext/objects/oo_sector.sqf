	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014 Nicolas BOITEUX

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
		PRIVATE VARIABLE("code","grid");	
		PRIVATE VARIABLE("string","marker");
		PRIVATE VARIABLE("array","sector");
		PRIVATE VARIABLE("scalar","state");
		PRIVATE VARIABLE("array","position");
		PRIVATE VARIABLE("array","unitstype");
		PRIVATE VARIABLE("array","units");
		PRIVATE VARIABLE("bool","artilleryactive");
		PRIVATE VARIABLE("code","artillery");

		PUBLIC FUNCTION("array","constructor") {
			private["_air", "_index", "_sniper", "_type", "_vehicle"];

			_index = MEMBER("index",nil);
			if (isNil "_index") then {_index = 0;};
			_index = _index + 1;
			MEMBER("index",_index);

			MEMBER("sector", _this select 0);
			MEMBER("position", _this select 1);
			MEMBER("grid", _this select 2);

			MEMBER("state", 0);
			MEMBER("alert", false);

			if(random 1 > 0.85) then { _sniper = 1; } else { _sniper = 0;};
			if(random 1 > 0.93) then { _air = 1; } else { _air = 0; };
			if(random 1 > 0.90) then { _vehicle = 1;} else { _vehicle = 0};

			_type = [ 1, _sniper, _vehicle, _air];
			MEMBER("unitstype", _type);
			
			if(random 1 > 0.90) then { MEMBER("artilleryactive", true);} else {MEMBER("artilleryactive", false);};
			if(random 1 > 0.90) then { MEMBER("setMission", nil); };
		};

		PUBLIC FUNCTION("","getIndex") FUNC_GETVAR("index");
		PUBLIC FUNCTION("","getSector") FUNC_GETVAR("sector");
		PUBLIC FUNCTION("","getMarker") FUNC_GETVAR("marker");
		PUBLIC FUNCTION("","getAlert") FUNC_GETVAR("alert");
		PUBLIC FUNCTION("","getArtillery") FUNC_GETVAR("artillery");
		PUBLIC FUNCTION("","getPosition") FUNC_GETVAR("position");
		PUBLIC FUNCTION("","getState") FUNC_GETVAR("state");

		PUBLIC FUNCTION("", "getThis") {
			private ["_key", "_sector"];
			_key = MEMBER("sector", nil);
			_sector = ["Get", str(_key)] call global_zone_hashmap;
			_sector;
		};

		// 0 - unactivate
		// 1 - activate
		// 2 - done
		PRIVATE FUNCTION("scalar", "setState") {
			MEMBER("state", _this);
		};

		PUBLIC FUNCTION("", "setMission") {
			private ["_position"];
			_position = MEMBER("getPosition", nil);
			_mission = ["new", [_position]] spawn OO_MISSION;
		};

		PUBLIC FUNCTION("", "isArtillery") {
			private ["_artillery", "_result"];
			_result = false;
			if(MEMBER("artilleryactive", nil)) then {
				_artillery = "getVehicle" call MEMBER("artillery", nil);
				if!(isnil "_artillery") then {
					if(getdammage _artillery < 0.9) then { _result = true; } else { _result = false; };
				};
			};
			_result;
		};

		PUBLIC FUNCTION("", "popArtillery") {
			private ["_position", "_artillery"];
			_position = [MEMBER("position", nil), 3000,5000,10,0,2000,0] call BIS_fnc_findSafePos;

			_artillery = ["new", [_position]] call OO_ARTILLERY;
			MEMBER("artillery", _artillery);
		};

		PUBLIC FUNCTION("", "Draw") {
			private ["_marker"];
			_marker = createMarker [format["mrk%1", MEMBER("index", nil)], MEMBER("position", nil)];
			_marker setMarkerShape "RECTANGLE";
			_marker setmarkerbrush "Solid";
			_marker setmarkercolor "ColorRed";
			_marker setmarkersize [50,50];
			MEMBER("marker", _marker);
		};

		PUBLIC FUNCTION("", "UnDraw") {
			deletemarker MEMBER("marker", nil);
		};

		PUBLIC FUNCTION("", "popSector") {
			private ["_marker", "_object", "_units", "_unitstype", "_type"];

			_unitstype = MEMBER("unitstype", nil);
			_units = [];
			_object = MEMBER("getThis", nil);

			if(MEMBER("artilleryactive", nil)) then {
				MEMBER("popArtillery", nil);
			};

			for "_i" from 1 to (_unitstype select 0) step 1 do {
				_units = _units + MEMBER("popInfantry", nil);
				sleep 0.01;
			};

			for "_i" from 1 to (_unitstype select 2) step 1 do {
				_units = _units + MEMBER("popSniper", nil);
				sleep 0.01;
			};
										
			for "_i" from 1 to (_unitstype select 2) step 1 do {
				_units = _units + MEMBER("popVehicle", nil);
				sleep 0.01;
			};
		
			for "_i" from 1 to (_unitstype select 3) step 1 do {
				// air pop only one time
				MEMBER("popAir", nil);
				sleep 0.01;
			};

			_type = [ 1, (_unitstype select 1), (_unitstype select 2), 0];

			MEMBER("unitstype", _type);;
			MEMBER("units", _units);
		};

		PUBLIC FUNCTION("", "unPopSector") {
			private ["_group"];
			_group = [];

			{
				if!(group _x in _group) then {
					_group = _group + [group _x];
				};
				_x setdammage 1;
				deletevehicle _x;
				sleep 0.01;
			}foreach MEMBER("units", nil);

			{
				deleteGroup _x;
				sleep 0.01;
			}foreach _group;

			if(MEMBER("artilleryactive", nil)) then {
				["delete", MEMBER("artillery", nil)] call OO_ARTILLERY;
			};

			_units = [];
			MEMBER("units", _units);
		};

		PUBLIC FUNCTION("", "Spawn") {
			private ["_around", "_mincost", "_cost", "_run", "_grid", "_player_sector", "_sector", "_units", "_position", "_vehicle", "_type"];

			MEMBER("state", 1);
			MEMBER("marker", nil) setmarkercolor "ColorOrange";
			MEMBER("popSector", nil);

			_grid = MEMBER("grid", nil);
			_time = 0;

			_run = true;
			while { _run } do {
				_run = false;
				_units = 0;
				_mincost = 100;

				{
					_player_sector = ["getSectorFromPos", position _x] call _grid;
					_cost = ["GetEstimateCost", [_player_sector, MEMBER("sector", nil)]] call _grid;
					if(_cost < _mincost) then { _mincost = _cost;};
					sleep 0.01;
				}foreach playableunits;

				if(_mincost > 0 and _mincost <4) then {
					MEMBER("marker", nil) setmarkercolor "ColorOrange";
					_run = true;
				};
				if(_mincost == 0) then {
					MEMBER("marker", nil) setmarkercolor "ColorYellow";
					_run = true;
				};

				{
					if(alive _x) then { _units = _units + 1;};
					sleep 0.001
				}foreach MEMBER("units", nil);
				if(_units == 0) then { _run = false; };
				sleep 1;
			};
			
			if(_units == 0) then {
				MEMBER("setVictory", nil);
				MEMBER("unPopSector", nil);
			} else {
				MEMBER("UnSpawn", nil);
			};
		};

		PUBLIC FUNCTION("", "setVictory") {
			private ["_position"];
			MEMBER("marker", nil) setmarkercolor "ColorBlue";
			MEMBER("state", 2);
			["setTicket", "bluezone"] call global_ticket;
			_position = ["getPosFromSector", MEMBER("getSector",nil)] call MEMBER("grid", nil);
			_position = [_position, 0,50,10,0,2000,0] call BIS_fnc_findSafePos;
			["new", [_position]] spawn OO_BONUSVEHICLE;
		};

		PUBLIC FUNCTION("bool", "setAlert") {
			MEMBER("alert", _this);
		};

		PUBLIC FUNCTION("bool", "setAlertAround") {
			MEMBER("alert", _this);
			["expandAlertAround", MEMBER("getSector", nil)] call global_controller;
		};

		PUBLIC FUNCTION("", "UnSpawn") {
			MEMBER("marker", nil) setmarkercolor "ColorRed";
			MEMBER("unPopSector", nil);
			if(MEMBER("getAlert", nil)) then { 
				["expandSectorAround", MEMBER("getSector", nil)] call global_controller;
			};
			//MEMBER("setAlert", false);
			MEMBER("state", 0);
		};


		PRIVATE FUNCTION("", "popInfantry") {
			private ["_handle","_marker","_markersize","_markerpos","_type","_sector","_position","_group"];

			_marker	=  MEMBER("marker", nil);		
			_markerpos = getmarkerpos _marker;
			_markersize = (getMarkerSize _marker) select 1;
		
			_type = ["OIA_InfSquad_Weapons","OIA_InfSquad", "OIA_InfTeam", "OIA_InfTeam_AA", "OIA_InfTeam_AT", "OI_ReconTeam"] call BIS_fnc_selectRandom;
		
			_position = [_markerpos, random (_markersize -15), random 359] call BIS_fnc_relPos;
		
			_group = [_position, east, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "infantry" >> _type)] call BIS_fnc_spawnGroup;
		
			{
				_handle = [_x, _type] spawn WC_fnc_setskill;
				sleep 0.1;
			}foreach (units _group);
			
			_patrol = ["new", [_group, MEMBER("getThis", nil), _markersize]] call OO_PATROL;
			"patrol" spawn _patrol;

			units _group;
		};

		PRIVATE FUNCTION("", "popSniper") {
			private ["_handle","_marker","_markersize","_markerpos","_type","_sector","_position","_group"];

			_marker	=  MEMBER("marker", nil);		
			_markerpos = getmarkerpos _marker;
			_markersize = (getMarkerSize _marker) select 1;

			_type = "OI_SniperTeam";		
			_position = [_markerpos, random (_markersize -15), random 359] call BIS_fnc_relPos;
			_group = [_position, east, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "infantry" >> _type)] call BIS_fnc_spawnGroup;
		
			{
				_handle = [_x, _type] spawn WC_fnc_setskill;
				sleep 0.1;
			}foreach (units _group);
		
			_patrol = ["new", [_group, MEMBER("getThis", nil), _markersize]] call OO_PATROL;
			"patrol" spawn _patrol;
		
			units _group;
		};


		PRIVATE FUNCTION("", "popVehicle") {
			private ["_array","_handle","_marker","_markersize","_markerpos","_type","_sector","_position","_group","_units","_vehicle"];
		
			_marker			=  MEMBER("marker", nil);
			_markerpos 		= getmarkerpos _marker;
			_markersize		= (getMarkerSize _marker) select 1;
		
			if(random 1 > 0.5) then {
				//light vehicle
				_vehicle = ["O_MRAP_02_hmg_F","O_MRAP_02_gmg_F","I_MRAP_03_hmg_F","I_MRAP_03_gmg_F"] call BIS_fnc_selectRandom;
			} else {
				//heavy vehicle
				_vehicle = ["O_APC_Tracked_02_cannon_F","O_APC_Tracked_02_AA_F","O_MBT_02_cannon_F","O_APC_Wheeled_02_rcws_F","I_APC_Wheeled_03_cannon_F"] call BIS_fnc_selectRandom;
			};
		
			_position = [_markerpos, random (_markersize -15), random 359] call BIS_fnc_relPos;
			_position = [_position, 0,50,10,0,2000,0] call BIS_fnc_findSafePos;
		
			_array = [_position, random 359, _vehicle, east] call bis_fnc_spawnvehicle;
		
			_vehicle = _array select 0;
			_group = _array select 2;
			_vehicle setVehicleLock "LOCKED";

			_handle = [_vehicle] spawn WC_fnc_vehiclehandler;		
			_handle = [_group, MEMBER("position", nil), 400, MEMBER("getThis", nil)] spawn WC_fnc_patrol;
		
			{
				_handle = [_x, ""] spawn WC_fnc_setskill;
				sleep 0.1;
			}foreach (units _group);
		
			_units = units _group + [_vehicle];
			_units;
		};

		PRIVATE FUNCTION("", "popAir") {
			private ["_patrol"];

			_patrol = ["new", [MEMBER("getThis", nil)]] call OO_PATROLAIR;
			"patrol" spawn _patrol;
		};


		PUBLIC FUNCTION("","deconstructor") { 
			DELETE_VARIABLE("alert");
			DELETE_VARIABLE("grid");
			DELETE_VARIABLE("index");
			deletemarker MEMBER("marker", nil);
			DELETE_VARIABLE("marker");
			DELETE_VARIABLE("sector");
			DELETE_VARIABLE("position");
			DELETE_VARIABLE("units");
			DELETE_VARIABLE("unitstype");
			DELETE_VARIABLE("state");		
		};
	ENDCLASS;