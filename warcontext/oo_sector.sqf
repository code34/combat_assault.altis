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
		PRIVATE VARIABLE("array","position");
		PRIVATE VARIABLE("array","unitstype");
		PRIVATE VARIABLE("array","units");

		PUBLIC FUNCTION("array","constructor") {
			private["_air", "_index", "_type"];

			_index = MEMBER("index",nil);
			if (isNil "_index") then {_index = 0;};
			_index = _index + 1;
			MEMBER("index",_index);

			MEMBER("sector", _this select 0);
			MEMBER("position", _this select 1);
			MEMBER("grid", _this select 2);

			MEMBER("alert", false);

			if(random 1 > 0.97) then { _air = 1; } else { _air = 0; };
			_type = [ (1 + round (random 1)), round (random 0.75), _air];
			MEMBER("unitstype", _type);
		};

		PUBLIC FUNCTION("","getIndex") FUNC_GETVAR("index");
		PUBLIC FUNCTION("","getSector") FUNC_GETVAR("sector");
		PUBLIC FUNCTION("","getMarker") FUNC_GETVAR("marker");
		PUBLIC FUNCTION("","getAlert") FUNC_GETVAR("alert");

		PUBLIC FUNCTION("", "getThis") {
			private ["_key", "_sector"];
			_key = MEMBER("sector", nil);
			_sector = ["Get", [_key]] call global_zone_hashmap ;
			_sector;
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
			private ["_marker", "_object", "_units", "_unitstype"];

			_unitstype = MEMBER("unitstype", nil);
			_units = [];
			_object = MEMBER("getThis", nil);

			for "_i" from 1 to (_unitstype select 0) step 1 do {
				_units = _units + MEMBER("popInfantry", nil);
			};
										
			for "_i" from 1 to (_unitstype select 1) step 1 do {
				_units = _units + MEMBER("popVehicle", nil);
			};
		
			for "_i" from 1 to (_unitstype select 2) step 1 do {
				_units = _units + MEMBER("popAir", nil);
			};
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

			_units = [];
			MEMBER("units", _units);

		};

		PUBLIC FUNCTION("", "Spawn") {
			private ["_around", "_mincost", "_cost", "_run", "_grid", "_player_sector", "_sector", "_units", "_position"];

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
				MEMBER("marker", nil) setmarkercolor "ColorBlue";
				MEMBER("unPopSector", nil);
			} else {
				MEMBER("UnSpawn", nil);
			};
		};

		PUBLIC FUNCTION("bool", "setAlert") {
			MEMBER("alert", _this);
		};

		PUBLIC FUNCTION("", "UnSpawn") {
			global_sector_attack = global_sector_attack - [MEMBER("sector", nil)];
			global_sector_done = global_sector_done + [MEMBER("sector", nil)];
			MEMBER("marker", nil) setmarkercolor "ColorRed";
			MEMBER("unPopSector", nil);
			if(MEMBER("getAlert", nil)) then { MEMBER("expandSector", nil); };
			MEMBER("setAlert", false);
		};

		PUBLIC FUNCTION("", "expandSector"){
			private ["_around"];
			_around = ["getSectorAllAround", [MEMBER("sector", nil),3]] call _grid;
			{
				if(random 1 > 0.95) then {
					global_new_zone = global_new_zone + [_x];
				};
			}foreach _around;
		};


		PRIVATE FUNCTION("", "popInfantry") {
			private ["_handle","_marker","_markersize","_markerpos","_type","_sector","_position","_group"];

			_marker	=  MEMBER("marker", nil);		
			_markerpos = getmarkerpos _marker;
			_markersize = (getMarkerSize _marker) select 1;
		
			_type = ["OIA_InfSquad_Weapons","OIA_InfSquad", "OIA_InfTeam", "OIA_InfTeam_AA", "OIA_InfTeam_AT", "OI_SniperTeam", "OI_ReconTeam"] call BIS_fnc_selectRandom;
		
			_position = [_markerpos, random (_markersize -15), random 359] call BIS_fnc_relPos;
		
			_group = [_position, east, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "infantry" >> _type)] call BIS_fnc_spawnGroup;
		
			{
				_handle = [_x, _type] spawn WC_fnc_skill;
				sleep 0.1;
			}foreach (units _group);
		
			_handle = [_group, MEMBER("position", nil), _markersize, MEMBER("getThis", nil)] execVM "warcontext\WC_fnc_patrol.sqf";
		
			units _group;
		};


		PRIVATE FUNCTION("", "popVehicle") {
			private ["_array","_handle","_marker","_markersize","_markerpos","_type","_sector","_position","_group","_units","_vehicle"];
		
			_marker			=  MEMBER("marker", nil);
			_markerpos 		= getmarkerpos _marker;
			_markersize		= (getMarkerSize _marker) select 1;
		
			if(random 1 > 0.5) then {
				//light vehicle
				_vehicle = ["O_MRAP_02_F","O_MRAP_02_hmg_F","O_MRAP_02_gmg_F", "I_MRAP_03_F","I_MRAP_03_hmg_F","I_MRAP_03_gmg_F"] call BIS_fnc_selectRandom;
			} else {
				//heavy vehicle
				_vehicle = ["O_APC_Tracked_02_cannon_F","O_APC_Tracked_02_AA_F","O_MBT_02_cannon_F","O_MBT_02_arty_F","O_APC_Wheeled_02_rcws_F","I_APC_Wheeled_03_cannon_F"] call BIS_fnc_selectRandom;
			};
		
			_position = [_markerpos, random (_markersize -15), random 359] call BIS_fnc_relPos;
			_position = [_position, 0,50,10,0,2000,0] call BIS_fnc_findSafePos;
		
			_array = [_position, random 359, _vehicle, east] call bis_fnc_spawnvehicle;
		
			_vehicle = _array select 0;
			_group = _array select 2;
			_vehicle setVehicleLock "LOCKED";
		
			_handle = [_group, MEMBER("position", nil), 400, MEMBER("getThis", nil)] execVM "warcontext\WC_fnc_patrol.sqf";	
		
			{
				_handle = [_x, ""] spawn WC_fnc_skill;
				sleep 0.1;
			}foreach (units _group);
		
			_units = units _group + [_vehicle];
			_units;
		};

		PRIVATE FUNCTION("", "popAir") {
			private ["_array","_handle","_marker","_markersize","_markerpos","_type","_sector","_position","_group","_units","_vehicle"];
		
			_marker			=  MEMBER("marker", nil);
			_markerpos 		= getmarkerpos _marker;
			_markersize		= (getMarkerSize _marker) select 1;
		
			_vehicle = ["O_Heli_Light_02_F", "3O_Heli_Attack_02_F", "O_Heli_Attack_02_black_F", "O_Plane_CAS_02_F"] call BIS_fnc_selectRandom;
		
			_position = [_markerpos, random (_markersize -15), random 359] call BIS_fnc_relPos;
			_position = [_position, 0,50,10,0,2000,0] call BIS_fnc_findSafePos;
		
			_array = [_position, random 359, _vehicle, east] call bis_fnc_spawnvehicle;
		
			_vehicle = _array select 0;
			_group = _array select 2;
			_vehicle setVehicleLock "LOCKED";
		
			_handle = [_group, position (leader _group), 400, MEMBER("getThis", nil)] execVM "warcontext\WC_fnc_patrol.sqf";	
		
			{
				_handle = [_x, ""] spawn WC_fnc_skill;
				sleep 0.1;
			}foreach (units _group);
		
			_units = units _group + [_vehicle];
			_units;
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
		};
	ENDCLASS;