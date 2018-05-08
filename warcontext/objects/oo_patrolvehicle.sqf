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
			DEBUG(#, "OO_PATROLVEHICLE::constructor")
			MEMBER("vehicle",  _this select 0);
			MEMBER("group",  _this select 1);
			MEMBER("sector", _this select 2);
			MEMBER("around", []);
			MEMBER("underalert", []);
			MEMBER("target", []);
			MEMBER("alert", false);
			MEMBER("createMarker", _this select 0);
			MEMBER("getSectorAround", nil);
			MEMBER("setPatrolMode", nil);
		};

		PUBLIC FUNCTION("","getVehicle") FUNC_GETVAR("vehicle");
		PUBLIC FUNCTION("","getGroup") FUNC_GETVAR("group");
		PUBLIC FUNCTION("","getSector") FUNC_GETVAR("sector");
		PUBLIC FUNCTION("","getAround") FUNC_GETVAR("around");
		PUBLIC FUNCTION("","getUnderAlert") FUNC_GETVAR("underalert");

		PUBLIC FUNCTION("", "patrol") {
			DEBUG(#, "OO_PATROLVEHICLE::patrol")
			while { count (units MEMBER("group", nil)) > 0 } do {
				MEMBER("scanTargets", nil);
				MEMBER("getSectorUnderAlert", nil);
				MEMBER("getNextTarget", nil);
				MEMBER("moveToNext", nil);
				sleep 0.1;
			};
			MEMBER("deconstructor", nil);
		};

		PUBLIC FUNCTION("object", "createMarker") {
			DEBUG(#, "OO_PATROLVEHICLE::createMarker")
			private _mark = ["new", [position _this, false]] call OO_MARKER;
			["attachTo", _this] spawn _mark;
			private _name= getText (configFile >> "CfgVehicles" >> (typeOf _this) >> "DisplayName");
			["setText", _name] spawn _mark;
			["setColor", "ColorRed"] spawn _mark;
			["setType", "o_plane"] spawn _mark;
			["setSize", [0.8,0.8]] spawn _mark;
			MEMBER("marker", _mark);
		};

		PUBLIC FUNCTION("", "scanTargets") {
			DEBUG(#, "OO_PATROLVEHICLE::scanTargets")
			private _list = (position MEMBER("vehicle", nil)) nearEntities [["Man"], 200];
			private _list2 = (position MEMBER("vehicle", nil)) nearEntities [["Tank"], 200];
			sleep 1;
			{ _list append (crew _x); } foreach _list2;

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
			DEBUG(#, "OO_PATROLVEHICLE::getSectorAround")
			private _sector = "getSector" call MEMBER("sector",nil);
			private _around = ["getAllSectorsAroundSector", [_sector, 4]] call global_grid;
			MEMBER("around", _around);
		};

		// retrieve all sectors around under Alert state
		// if none return empty array
		PUBLIC FUNCTION("", "getSectorUnderAlert") {
			DEBUG(#, "OO_PATROLVEHICLE::getSectorUnderAlert")
			MEMBER("underalert", []);
			if(MEMBER("alert", nil)) then {
				{
					private _position = ["getPosFromSector", _x] call global_grid;
					private _list = _position nearEntities [["Man", "Tank"], 50];
					sleep 0.2;
					if(west countSide _list > 0) then { MEMBER("underalert", nil) pushBack _x; };
				} foreach MEMBER("around", nil);
			};
		};

		// movetoNext target position
		PUBLIC FUNCTION("", "moveToNext") {
			DEBUG(#, "OO_PATROLVEHICLE::moveToNext")
			private _move = false;
			private _wp = MEMBER("group", nil) addWaypoint [MEMBER("target", nil), 25];
			_wp setWaypointPosition [MEMBER("target", nil), 25];
			_wp setWaypointType "SAD";
			_wp setWaypointSpeed "FULL";
			MEMBER("group", nil) setCurrentWaypoint _wp;
			sleep 5;
			while { !_move } do {
				if(speed MEMBER("vehicle", nil) < 10) then {
					_move = true;
					sleep 5;
				} else {
					sleep 1;
				};
			};
			deletewaypoint _wp;
		};

		PUBLIC FUNCTION("", "getNextTarget") {
			DEBUG(#, "OO_PATROLVEHICLE::getNextTarget")
			private _sector = [];
			if(MEMBER("alert", nil)) then {
				_sector = selectRandom MEMBER("underalert", nil);
				MEMBER("setCombatMode", nil);
				MEMBER("revealTarget", nil);
			} else {
				_sector =selectRandom MEMBER("around", nil);
				MEMBER("setPatrolMode", nil);
			};
			private _position = ["getPosFromSector", _sector] call global_grid;
			MEMBER("target", _position);
		};

		PUBLIC FUNCTION("array", "estimateTarget") {
			DEBUG(#, "OO_PATROLVEHICLE::estimateTarget")
			private _position = (_this select 0) getHideFrom (_this select 1);
			private _realposition = position (_this select 1);
			_position distance _realposition;
		};

		PUBLIC FUNCTION("", "revealTarget") {
			DEBUG(#, "OO_PATROLVEHICLE::revealTarget")
			private _leader = (leader MEMBER("group", nil));
			private _list = (position MEMBER("vehicle", nil)) nearEntities [["Air", "Man", "Tank"], 600];
			private _array = [];
			sleep 0.5;
			{
				_array = [_leader, _x];
				if(MEMBER("estimateTarget", _array) < 2) then { _leader reveal [_x, 4]; };
				sleep 0.0001;
			}foreach _list;
		};

		PUBLIC FUNCTION("", "setPatrolMode") {
			DEBUG(#, "OO_PATROLVEHICLE::setPatrolMode")
			MEMBER("group", nil) setBehaviour "SAFE";
			MEMBER("group", nil) setCombatMode "GREEN";
			MEMBER("group", nil) setSpeedMode "FULL";
		};	

		PUBLIC FUNCTION("", "setCombatMode") {
			DEBUG(#, "OO_PATROLVEHICLE::setCombatMode")
			MEMBER("group", nil) setBehaviour "COMBAT";
			MEMBER("group", nil) setCombatMode "RED";
			MEMBER("group", nil) setSpeedMode "FULL";
		};		

		PUBLIC FUNCTION("","deconstructor") {
			DEBUG(#, "OO_PATROLVEHICLE::deconstructor")
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