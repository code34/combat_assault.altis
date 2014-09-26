	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014 Nicolas BOITEUX

	CLASS OO_PATROLAIR
	
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

	CLASS("OO_PATROLAIR")
		PRIVATE VARIABLE("object","vehicle");
		PRIVATE VARIABLE("group","group");
		PRIVATE VARIABLE("code","sector");
		PRIVATE VARIABLE("array","around");
		PRIVATE VARIABLE("array","underalert");
		PRIVATE VARIABLE("code", "grid");
		PRIVATE VARIABLE("array", "target");
			

		PUBLIC FUNCTION("array","constructor") {
			MEMBER("vehicle", _this select 0);
			MEMBER("group", _this select 1);
			MEMBER("sector", _this select 2);
			_grid = ["new", [31000,31000,100,100]] call OO_GRID;
			MEMBER("grid", _grid);
			MEMBER("getSectorAround", nil);
			MEMBER("setCombatMode", nil);
		};

		PUBLIC FUNCTION("","getVehicle") FUNC_GETVAR("vehicle");
		PUBLIC FUNCTION("","getGroup") FUNC_GETVAR("group");
		PUBLIC FUNCTION("","getSector") FUNC_GETVAR("sector");
		PUBLIC FUNCTION("","getAround") FUNC_GETVAR("around");
		PUBLIC FUNCTION("","getUnderAlert") FUNC_GETVAR("underalert");


		PUBLIC FUNCTION("", "patrol") {
			private ["_group"];
			_group = MEMBER("group", nil);
			while { count (units _group) > 0 } do {
				MEMBER("getSectorUnderAlert", nil);
				MEMBER("getNextTarget", nil);
				MEMBER("revealTarget", nil);
				MEMBER("moveToNext", nil);
				sleep 0.1;
			};
			MEMBER("deconstructor", nil);
		};

		PUBLIC FUNCTION("", "getSectorAround") {
			private ["_around", "_sector"];
			_sector = "getSector" call MEMBER("sector", nil);
			_around = ["getSectorAllAround", [_sector, 6]] call MEMBER("grid", nil);
			MEMBER("around", _around);
		};

		PUBLIC FUNCTION("", "getSectorUnderAlert") {
			private ["_around", "_sectors", "_nextsector"];
			_sectors = [];
			{
				_nextsector = ["Get", str(_x)] call global_zone_hashmap;
				if!(isnil "_nextsector") then {
					if("getAlert" call _nextsector) then {
						_sectors = _sectors + [_nextsector];
					};
				};
				sleep 0.001;
			} foreach MEMBER("around", nil);
			MEMBER("underalert", _sectors);
		};

		PUBLIC FUNCTION("", "moveToNext") {
			private ["_group", "_vehicle", "_wp"];

			_vehicle = MEMBER("vehicle", nil);
			_group = MEMBER("group", nil);

			_wp = _group addWaypoint [MEMBER("target", nil), 25];
			_wp setWaypointPosition [MEMBER("target", nil), 25];
			_wp setWaypointType "HOLD";
			_wp setWaypointSpeed "FULL";
			_group setCurrentWaypoint _wp;

			while { (speed _vehicle > 70) } do {
				sleep 1;
			};
			deletewaypoint _wp;
		};

		PUBLIC FUNCTION("", "getNextTarget") {
			private ["_nextsector", "_position"];

			if(count MEMBER("underalert", nil) > 0) then {
				_nextsector = "getSector" call (MEMBER("underalert", nil) call BIS_fnc_selectRandom);
			} else {
				_nextsector = MEMBER("around", nil) call BIS_fnc_selectRandom;
			};
			_position = ["getPosFromSector", _nextsector] call MEMBER("grid", nil);
			MEMBER("target", _position);
		};

		PUBLIC FUNCTION("", "revealTarget") {
			private ["_list"];	

			_list = (position MEMBER("vehicle", nil)) nearEntities [["Man"], 400];
			{
				leader MEMBER("group", nil) reveal [_x, 4];
				sleep 0.01;
			}foreach _list;
		};

		PUBLIC FUNCTION("", "setCombatMode") {
			MEMBER("group", nil) setBehaviour "COMBAT";
			MEMBER("group", nil) setCombatMode "RED";
			MEMBER("group", nil) setSpeedMode "FULL";
		};		


		PUBLIC FUNCTION("","deconstructor") { 
			DELETE_VARIABLE("around");
			DELETE_VARIABLE("vehicle");
			DELETE_VARIABLE("group");
			DELETE_VARIABLE("sector");
			DELETE_VARIABLE("underalert");
			DELETE_VARIABLE("target");
		};
	ENDCLASS;