	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014-2018 Nicolas BOITEUX

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
		PRIVATE VARIABLE("array", "target");
		PRIVATE VARIABLE("code", "marker");
			
		PUBLIC FUNCTION("array","constructor") {
			MEMBER("popMember",  _this select 1);
			MEMBER("sector", _this select 0);
			MEMBER("getSectorAround", nil);
			MEMBER("setCombatMode", nil);
		};

		PUBLIC FUNCTION("array", "popMember") {
			private _x = (_this select 0) + random 100;
			private _y = (_this select 1) + random 100;
			private _z = (_this select 2) + random 200;

			private _array = [[ _x, _y, _z], 0, selectRandom wcairchoppers, east] call bis_fnc_spawnvehicle;
			{
				[_x, ""] spawn WC_fnc_setskill;
				sleep 0.1;
			}foreach (units (_array select 2));
			
			(_array select 0) setVehicleLock "LOCKED";
			[(_array select 0)] spawn WC_fnc_vehiclehandler;
			
			MEMBER("createMarker", (_array select 0));
			MEMBER("vehicle", (_array select 0));
			MEMBER("group", (_array select 2));
		};

		PUBLIC FUNCTION("","getVehicle") FUNC_GETVAR("vehicle");
		PUBLIC FUNCTION("","getGroup") FUNC_GETVAR("group");
		PUBLIC FUNCTION("","getSector") FUNC_GETVAR("sector");
		PUBLIC FUNCTION("","getAround") FUNC_GETVAR("around");
		PUBLIC FUNCTION("","getUnderAlert") FUNC_GETVAR("underalert");

		PUBLIC FUNCTION("", "patrol") {
			while { count (units MEMBER("group", nil)) > 0 } do {
				MEMBER("getSectorUnderAlert", nil);
				MEMBER("getNextTarget", nil);
				MEMBER("moveToNext", nil);
				MEMBER("checkAlt", nil);
				sleep 0.1;
			};
			MEMBER("deconstructor", nil);
		};

		PUBLIC FUNCTION("object", "createMarker") {
			private _mark = ["new", [position _this, false]] call OO_MARKER;
			["attachTo", _this] spawn _mark;
			private _name= getText (configFile >> "CfgVehicles" >> (typeOf _this) >> "DisplayName");
			["setText", _name] spawn _mark;
			["setColor", "ColorRed"] spawn _mark;
			["setType", "o_plane"] spawn _mark;
			["setSize", [0.8,0.8]] spawn _mark;
			MEMBER("marker", _mark);
		};

		PUBLIC FUNCTION("", "checkAlt") {
			if((position MEMBER("vehicle", nil)) select 2 < 10) then {
				{
					_x setdammage 1;
					sleep 0.01;
				}foreach units MEMBER("group", nil);
			};
		};

		// get all sector around the base sector
		PUBLIC FUNCTION("", "getSectorAround") {
			private _sector = "getSector" call MEMBER("sector", nil);
			private _around = ["getAllSectorsAroundSector", [_sector, 6]] call global_grid;
			MEMBER("around", _around);
		};

		// retrieve all sectors around under Alert state
		// if none return empty array
		PUBLIC FUNCTION("", "getSectorUnderAlert") {
			private _nextsector = [];
			MEMBER("underalert", []);
			{
				_nextsector = ["get", str(_x)] call global_zone_hashmap;
				if!(isnil "_nextsector") then {
					if("getAlert" call _nextsector) then {
						MEMBER("underalert", []) pushBack _nextsector;
					};
				};
				sleep 0.01;
			} foreach MEMBER("around", nil);
		};

		// movetoNext target position
		PUBLIC FUNCTION("", "moveToNext") {
			private _vehicle = MEMBER("vehicle", nil);
			private _group = MEMBER("group", nil);
			private _move = false;
			private _sector = [];

			private _wp = _group addWaypoint [MEMBER("target", nil), 25];
			_wp setWaypointPosition [MEMBER("target", nil), 25];
			_wp setWaypointType "HOLD";
			_wp setWaypointSpeed "FULL";
			_group setCurrentWaypoint _wp;

			sleep 5;
			
			while { !_move } do {
				_sector = ["getSectorFromPos", position _vehicle] call global_grid;
				sleep (random 5);
				if(_sector isEqualTo (["getSectorFromPos", position _vehicle] call global_grid)) then {
					_move = true;
				};
				if(speed _vehicle < 10) then {
					_move = true;
				};
			};
			deletewaypoint _wp;
		};

		PUBLIC FUNCTION("", "getNextTarget") {
			private _sector = [];
			if(count MEMBER("underalert", nil) > 0) then {
				_sector = "getSector" call (selectRandom MEMBER("underalert", nil));
				MEMBER("revealTarget", nil);
			} else {
				_sector = selectRandom MEMBER("around", nil);
			};
			_sector = ["getPosFromSector", _sector] call global_grid;
			MEMBER("target", _sector);
		};

		PUBLIC FUNCTION("", "revealTarget") {
			private _list = (position MEMBER("vehicle", nil)) nearEntities [["Man", "Tank"], 600];
			sleep 0.5;
			{
				(leader MEMBER("group", nil)) reveal [_x, 4];
				sleep 0.01;
			}foreach _list;
		};

		PUBLIC FUNCTION("", "setCombatMode") {
			MEMBER("group", nil) setBehaviour "COMBAT";
			MEMBER("group", nil) setCombatMode "RED";
			MEMBER("group", nil) setSpeedMode "FULL";
		};		

		PUBLIC FUNCTION("","deconstructor") { 
			["delete", MEMBER("marker", nil)] call OO_MARKER;
			deletevehicle MEMBER("vehicle", nil);
			{
				_x setdammage 1;
				deletevehicle _x;
				sleep 0.1;
			}foreach units MEMBER("group", nil);
			deletegroup MEMBER("group", nil);
			DELETE_VARIABLE("marker");
			DELETE_VARIABLE("around");
			DELETE_VARIABLE("vehicle");
			DELETE_VARIABLE("group");
			DELETE_VARIABLE("sector");
			DELETE_VARIABLE("underalert");
			DELETE_VARIABLE("target");
		};
	ENDCLASS;