	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2016 Nicolas BOITEUX

	CLASS OO_PATROLVEHICLE
	
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

	CLASS("OO_PATROLVEHICLE")
		PRIVATE VARIABLE("object","vehicle");
		PRIVATE VARIABLE("group","group");
		PRIVATE VARIABLE("code","sector");
		PRIVATE VARIABLE("array","around");
		PRIVATE VARIABLE("array","underalert");
		PRIVATE VARIABLE("array", "target");
		PRIVATE VARIABLE("code", "marker");
		PRIVATE VARIABLE("bool", "alert");

		PUBLIC FUNCTION("array","constructor") {				
			MEMBER("vehicle",  _this select 0);
			MEMBER("group",  _this select 1);
			MEMBER("sector", _this select 2);

			MEMBER("alert", false);
			MEMBER("setMarker", nil);
			MEMBER("getSectorAround", nil);
			MEMBER("setPatrolMode", nil);
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
				MEMBER("scanTargets", nil);
				MEMBER("getSectorUnderAlert", nil);
				MEMBER("getNextTarget", nil);
				MEMBER("moveToNext", nil);
				sleep 0.1;
			};
			MEMBER("deconstructor", nil);
		};

		PUBLIC FUNCTION("", "setMarker") {
			private ["_vehicle", "_mark"];
			_vehicle = MEMBER("vehicle", nil);
			_mark = ["new", [position _vehicle, false]] call OO_MARKER;
			["attachTo", _vehicle] spawn _mark;
			_name= getText (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "DisplayName");
			["setText", _name] spawn _mark;
			["setColor", "ColorRed"] spawn _mark;
			["setType", "o_plane"] spawn _mark;
			["setSize", [0.8,0.8]] spawn _mark;
			MEMBER("marker", _mark);
		};

		PUBLIC FUNCTION("", "scanTargets") {
			private ["_list", "_list2"];

			_list = (position MEMBER("vehicle", nil)) nearEntities [["Man"], 200];
			_list2 = (position MEMBER("vehicle", nil)) nearEntities [["Tank"], 200];
			sleep 1;
			{ _list = _list + crew _x; } foreach _list2;

			{
				if((leader MEMBER("group", nil)) knowsAbout _x > 0.40) then {
					["setAlertAround", true] call MEMBER("sector", nil);
					MEMBER("alert", true);
				};
				sleep 0.0001;
			}foreach _list;
		};		

		// get all sector around the base sector
		PUBLIC FUNCTION("", "getSectorAround") {
			private ["_around", "_sector"];
			_sector = "getSector" call MEMBER("sector",nil);
			_around = ["getAllSectorsAroundSector", [_sector, 4]] call global_grid;
			MEMBER("around", _around);
		};

		// retrieve all sectors around under Alert state
		// if none return empty array
		PUBLIC FUNCTION("", "getSectorUnderAlert") {
			private ["_sectors", "_position", "_list"];
			_sectors = [];

			if(MEMBER("alert", nil)) then {
				{
					_position = ["getPosFromSector", _x] call global_grid;
					_list = _position nearEntities [["Man", "Tank"], 50];

					sleep 0.2;
					if(west countSide _list > 0) then {
						_sectors = _sectors + [_x];
					};
				} foreach MEMBER("around", nil);
			};
			MEMBER("underalert", _sectors);
		};

		// movetoNext target position
		PUBLIC FUNCTION("", "moveToNext") {
			private ["_group", "_vehicle", "_wp", "_sector", "_move"];

			_vehicle = MEMBER("vehicle", nil);
			_group = MEMBER("group", nil);
			_move = false;
	
			_wp = _group addWaypoint [MEMBER("target", nil), 25];
			_wp setWaypointPosition [MEMBER("target", nil), 25];
			_wp setWaypointType "SAD";
			_wp setWaypointSpeed "FULL";
			_group setCurrentWaypoint _wp;

			sleep 5;

			while { !_move } do {
				//_sector = ["getSectorFromPos", position _vehicle] call global_grid;
				//if(_sector isEqualTo (["getSectorFromPos", position _vehicle] call global_grid)) then {
				//	_move = true;
				//};

				if(speed _vehicle < 10) then {
					_move = true;
					sleep 5;
				} else {
					sleep 1;
				};
			};
			deletewaypoint _wp;
		};

		PUBLIC FUNCTION("", "getNextTarget") {
			private ["_nextsector", "_position"];

			if(MEMBER("alert", nil)) then {
				_nextsector = MEMBER("underalert", nil) call BIS_fnc_selectRandom;
				MEMBER("setCombatMode", nil);
				MEMBER("revealTarget", nil);
			} else {
				_nextsector = MEMBER("around", nil) call BIS_fnc_selectRandom;
				MEMBER("setPatrolMode", nil);
			};
			_position = ["getPosFromSector", _nextsector] call global_grid;
			MEMBER("target", _position);
		};

		PUBLIC FUNCTION("array", "estimateTarget") {
			private ["_target", "_position", "_realposition", "_source"];
			_source = _this select 0;
			_target = _this select 1;
			
			_position = _source getHideFrom _target;
			_realposition = position _target;
			_position distance _realposition;
		};

		PUBLIC FUNCTION("", "revealTarget") {
			private ["_list", "_array", "_leader"];

			_leader = (leader MEMBER("group", nil));
			_list = (position MEMBER("vehicle", nil)) nearEntities [["Air", "Man", "Tank"], 600];
			sleep 0.5;
			{
				_array = [_leader, _x];
				if(MEMBER("estimateTarget", _array) < 2) then {
				 	_leader reveal [_x, 4];
				 };
				sleep 0.0001;
			}foreach _list;
		};

		PUBLIC FUNCTION("", "setPatrolMode") {
			MEMBER("group", nil) setBehaviour "SAFE";
			MEMBER("group", nil) setCombatMode "GREEN";
			MEMBER("group", nil) setSpeedMode "FULL";
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
			DELETE_VARIABLE("alert");
		};
	ENDCLASS;