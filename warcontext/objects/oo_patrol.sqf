
	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014 Nicolas BOITEUX

	CLASS OO_PATROL
	
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

	CLASS("OO_PATROL")
		PRIVATE VARIABLE("scalar","areasize");
		PRIVATE VARIABLE("bool","alert");
		PRIVATE VARIABLE("object","target");
		PRIVATE VARIABLE("array","targets");
		PRIVATE VARIABLE("group","group");
		PRIVATE VARIABLE("code","sector");
		PRIVATE VARIABLE("scalar","sizegroup");
		PRIVATE VARIABLE("code","grid");
		PRIVATE VARIABLE("array","buildings");
		PRIVATE VARIABLE("bool","city");

		PUBLIC FUNCTION("array","constructor") {
			MEMBER("group", _this select 0);
			MEMBER("sector", _this select 1);
			MEMBER("areasize", _this select 2);

			MEMBER("sizegroup", count units (_this select 0));
			_grid = ["new", [31000,31000,100,100]] call OO_GRID;
			MEMBER("grid", _grid);
			MEMBER("getBuildings", nil);
			MEMBER("alert", false);
		};

		PUBLIC FUNCTION("","getGrid") FUNC_GETVAR("grid");
		PUBLIC FUNCTION("","getGroup") FUNC_GETVAR("group");
		PUBLIC FUNCTION("","getTarget") FUNC_GETVAR("target");
		PUBLIC FUNCTION("","getSector") FUNC_GETVAR("sector");

		PUBLIC FUNCTION("", "patrol") {
			private ["_group", "_position"];
			_group = MEMBER("group", nil);
			_position = "getPosition" call MEMBER("sector",nil);

			while { count (units _group) > 0 } do {
				MEMBER("getTargets", _position);
				if(MEMBER("alert", nil)) then {
					MEMBER("attack", nil);
				} else {
					if(MEMBER("city", nil)) then {
						MEMBER("walkInBuildings", nil);
					} else {
						MEMBER("walk", nil);	
					};
				};
				sleep 0.1;
			};
			MEMBER("deconstructor", nil);
		};

		PUBLIC FUNCTION("", "attack") {
			private ["_group", "_position"];
			_group = MEMBER("group", nil);
			_position = "getPosition" call MEMBER("sector",nil);

			MEMBER("setCombatMode", nil);
			while { count (units _group) > 0 } do {
				MEMBER("getTargets", _position);
				MEMBER("getNextTarget", nil);
				MEMBER("engageTarget", nil);
				sleep 0.1;
			};			
		};

		PUBLIC FUNCTION("", "getBuildings") {
			private ["_sector", "_positions"];
			_sector = "getSector" call MEMBER("sector", nil);
			_positions = ["getPositionsBuilding", _sector] call MEMBER("grid", nil);
			MEMBER("buildings", _positions);
			if(count _positions > 10) then {
				MEMBER("city", true);
			}else{
				MEMBER("city", false);
			};
		};		

		PUBLIC FUNCTION("", "engageTarget") {
			private ["_target", "_isvehicle", "_isbuilding", "_isvisible", "_ishidden"];

			_target = MEMBER("target", nil);
			_isvehicle = (_target  != vehicle _target);
			_isbuilding = if((nearestbuilding _target) distance _target < 10) then { true; } else { false; };
			_isvisible = MEMBER("seeTarget", nil);

			if(_isvehicle) then {
				MEMBER("setMoveMode", nil);
				MEMBER("moveAround", 50);
			} else {
				if(_isbuilding) then {
					hint "movebuilding";
					if(_isvisible) then {
						MEMBER("doFire", nil);
					};
					MEMBER("setMoveMode", nil);
					MEMBER("moveInto", nearestbuilding _target);
				} else {
					if(_isvisible) then {
						hint "moveto";
						MEMBER("setCombatMode", nil);
						MEMBER("doFire", nil);
						MEMBER("moveToTarget", nil);
					} else {
						hint "movearound";
						MEMBER("setMoveMode", nil);
						MEMBER("moveAround", 25);
					};
				};
			};
			if(random 1 > 0.9) then {
				MEMBER("callArtillery", MEMBER("target", nil));
			};
		};


		PUBLIC FUNCTION("", "getNextTarget") {
			private ["_candidats", "_index", "_leader", "_target", "_min"];
			
			_leader = leader MEMBER("group", nil);
			_candidats = [];
			_target = MEMBER("target", nil);
			
			{
				_index = floor (MEMBER("estimateTarget", _x));
				_candidats = _candidats + [[_index, _x]];
				sleep 0.0001;
			}foreach MEMBER("targets", nil);

			if(!isnil "_target") then {
				if(alive _target) then {
					_index = floor (MEMBER("estimateTarget", MEMBER("target", nil)));
					_candidats = _candidats + [[_index, MEMBER("target", nil)]];
				};
			};

			// over no target, not see
			_min = 100000;
			{
				if((_x select 0) < _min) then {
					_target = _x select 1;
					_min = _x select 0;
				};
				sleep 0.0001;
			}foreach _candidats;
			MEMBER("target", _target);
		};		

		PUBLIC FUNCTION("", "revealTarget") {
			{
				leader MEMBER("group", nil) reveal [_x, 4];
				sleep 0.0001;
			}foreach units MEMBER("targets", nil);
		};		

		PUBLIC FUNCTION("array", "getTargets") {
			private ["_position", "_list"];

			_position = _this;
			_list = _position nearEntities [["Man", "Tank"], 800];
			sleep 0.5;
			{
				if(side _x != west) then {
					_list set [_foreachindex, -1];
				};
				sleep 0.0001;
			}foreach _list;
			_list = _list - [-1];
			MEMBER("targets", _list);
		};		

		PUBLIC FUNCTION("", "seeTarget") {
			private ["_leader", "_target", "_objects"];
			_leader = leader MEMBER("group", nil);
			_target =  MEMBER("target", nil);
			_objects = lineIntersectsWith [eyePos _leader, position _target];
			if(count _objects > 0) then {true;}else{false;};
		};		

		PUBLIC FUNCTION("object", "estimateTarget") {
			private ["_target", "_leader", "_position", "_realposition"];
			_target = _this;
			_leader = leader MEMBER("group", nil);	
			_position = _leader getHideFrom _target;
			_realposition = position _target;
			_position distance _realposition;
		};		

		PUBLIC FUNCTION("", "doFire") {
			{
				_x dofire MEMBER("target", nil);
				sleep 0.0001;
			}foreach units MEMBER("group", nil);
		};

		// moveInto Buildings
		PUBLIC FUNCTION("object", "moveInto") {
			private ["_building", "_index", "_positions"];

			_building = _this;
			_positions = [];
			_index = 0;

			while { format ["%1", _building buildingPos _index] != "[0,0,0]" } do {
				_positions = _positions + [(_building buildingPos _index)];
				_index = _index + 1;
				sleep 0.0001;
			};

			{
				_x domove (_positions call BIS_fnc_selectRandom);
				sleep 0.0001;
			}foreach units MEMBER("group", nil);
			sleep 30;
		};

		// move around target
		PUBLIC FUNCTION("", "moveToTarget") {
			private ["_position"];
			_position = position MEMBER("target", nil);
			MEMBER("moveTo", _position);
		};

		// move around target
		PUBLIC FUNCTION("scalar", "moveAround") {
			private ["_areasize", "_dir", "_leader", "_position", "_target"];
			
			_areasize = _this;
			_target = MEMBER("target", nil);
			_leader = leader MEMBER("group", nil);
			_dir = [_leader, _target] call BIS_fnc_dirTo;

			if(random 1 > 0.5) then {
				_dir = _dir + 90;
			} else {
				_dir = _dir - 90;
			};
			if(_dir > 359) then {_dir = _dir - 360};
			if(_dir < 0) then {_dir = _dir + 360};

			_position = [position _target, 50, _dir] call BIS_fnc_relPos;
			MEMBER("moveTo", _position);
		};

		// moveTo position
		PUBLIC FUNCTION("array", "moveTo") {
			private ["_group", "_position", "_wp"];

			_position = _this;
			_group = MEMBER("group", nil);
			_wp = _group addWaypoint [_position, 0];
			_wp setWaypointPosition [_position, 0];
			_wp setWaypointType "MOVE";
			_wp setWaypointSpeed "FULL";
			_group setCurrentWaypoint _wp;
			sleep 30;
			deletewaypoint _wp;
		};		

		PUBLIC FUNCTION("", "isCompleteGroup") {
			_count = MEMBER("sizegroup", nil);
			_count2 = count units (MEMBER("group", nil));
			if( _count == _count2) then { true; } else { false;};
		};

		PUBLIC FUNCTION("", "dropSmoke") {
			private ["_group", "_round"];
			_group = MEMBER("group", nil);

			_round = ceil(random 3);
			for "_x" from 0 to _round step 1 do {
				_smokeposition = [position (leader _group), 2, random 359] call BIS_fnc_relPos;
				_smoke = createVehicle ["G_40mm_Smoke", _smokeposition, [], 0, "NONE"];
			};
		};

		PUBLIC FUNCTION("", "dropFlare") {
			if((date select 3 < 4) or (date select 3 > 20)) then {

			};
		};		

		PUBLIC FUNCTION("", "setAlert") {
			["setAlertAround", true] call MEMBER("sector", nil);
			MEMBER("alert", true);
		};


		PUBLIC FUNCTION("", "scanTargets") {
			{
				if((leader MEMBER("group", nil)) knowsAbout _x > 0.40) then {
					MEMBER("setAlert", nil);
				};
				sleep 0.0001;
			}foreach MEMBER("targets", nil);
		};		

		PUBLIC FUNCTION("object", "callArtillery") {
			private ["_key", "_sector", "_artillery", "_target"];

			_target = _this;	
			_sector = MEMBER("sector", nil);

			if("isArtillery" call _sector) then { 
				_artillery = "getArtillery" call _sector;
				_key = ["getSectorFromPos", position _target] call MEMBER("grid", nil);
				_sector = ["Get", str(_key)] call global_zone_hashmap;
				if(!isnil "_sector") then {
					["setSuppression", true] call _artillery;
				} else {
					["setSuppression", false] call _artillery;
				};
				["callFireOnTarget", _target] call _artillery;
			};
		};		

		PUBLIC FUNCTION("", "walk") {
			private ["_areasize", "_counter", "_leader", "_position", "_group", "_formationtype", "_wp"];
			
			_group = MEMBER("group", nil);
			_leader = leader _group;
			_areasize = MEMBER("areasize", nil);

			MEMBER("setSafeMode", nil);
			
			_formationtype = ["COLUMN", "STAG COLUMN","WEDGE","ECH LEFT","ECH RIGHT","VEE","LINE","FILE","DIAMOND"] call BIS_fnc_selectRandom;
			_group setFormation _formationtype;

			_position = "getPosition" call MEMBER("sector", nil);

			while { (position _leader) distance _position < 20 } do {
				_position = [_position, _areasize, random 359] call BIS_fnc_relPos;
				sleep 0.0001;
			};

			_wp = _group addWaypoint [_position, 25];
			_wp setWaypointPosition [_position, 25];
			_wp setWaypointType "GUARD";
			_wp setWaypointVisible true;
			_wp setWaypointSpeed "LIMITED";
			_wp setWaypointStatements ["true", "this setvariable ['complete', true]; false"];
			_group setCurrentWaypoint _wp;

			_counter = 0;
			while { _counter < 300 } do {
				_leader = leader _group;
				if(format["%1",  _leader getVariable "complete"] == "true") then {
					_leader setvariable ['complete', false];
					_counter = 300;
				};
				if(format["%1",  _leader getVariable "combat"] == "true") then {
					if(random 1 > 0.8) then {MEMBER("dropSmoke", nil);};
					MEMBER("setAlert", nil);
					_counter = 300;
				};
				//if(!MEMBER("isCompleteGroup" ,nil)) then {
				//	if(random 1 > 0.8) then {MEMBER("dropSmoke", nil);};
				//	MEMBER("setAlert", nil);
				//	_counter = 300;
				//};
				if("getAlert" call MEMBER("sector", nil)) then {
					MEMBER("alert", true);
					_counter = 300;
				};
				MEMBER("scanTargets", nil);
				_counter = _counter + 1;
				sleep 0.1;
			};
			deletewaypoint _wp;
		};

		PUBLIC FUNCTION("", "walkInBuildings") {
			private ["_areasize", "_counter", "_leader", "_position", "_group", "_formationtype", "_wp"];
			
			_group = MEMBER("group", nil);
			_leader = leader _group;
			_areasize = MEMBER("areasize", nil);

			MEMBER("setBuildingMode", nil);
			{
				_x domove (MEMBER("buildings",nil) call BIS_fnc_selectRandom);
				sleep 0.0001;
			}foreach units MEMBER("group", nil);

			_counter = 0;
			while { _counter < 300 } do {
				_leader = leader _group;
				if(format["%1",  _leader getVariable "complete"] == "true") then {
					_leader setvariable ['complete', false];
					_counter = 300;
				};
				if(format["%1",  _leader getVariable "combat"] == "true") then {
					if(random 1 > 0.8) then {MEMBER("dropSmoke", nil);};
					MEMBER("setAlert", nil);
					_counter = 300;
				};
				//if(!MEMBER("isCompleteGroup" ,nil)) then {
				//	if(random 1 > 0.8) then {MEMBER("dropSmoke", nil);};
				//	MEMBER("setAlert", nil);
				//	_counter = 300;
				//};
				if("getAlert" call MEMBER("sector", nil)) then {
					MEMBER("alert", true);
					_counter = 300;
				};
				MEMBER("scanTargets", nil);
				_counter = _counter + 1;
				sleep 0.1;
			};
		};		

		PUBLIC FUNCTION("", "setBuildingMode") {
			MEMBER("group", nil) setBehaviour "SAFE";
			MEMBER("group", nil) setCombatMode "WHITE";
			MEMBER("group", nil) setSpeedMode "FULL";
		};

		PUBLIC FUNCTION("", "setMoveMode") {
			MEMBER("group", nil) setBehaviour "AWARE";
			MEMBER("group", nil) setCombatMode "RED";
			MEMBER("group", nil) setSpeedMode "FULL";
		};		

		PUBLIC FUNCTION("", "setSafeMode") {
			MEMBER("group", nil) setBehaviour "SAFE";
			MEMBER("group", nil) setCombatMode "GREEN";
			MEMBER("group", nil) setSpeedMode "NORMAL";
		};

		PUBLIC FUNCTION("", "setCombatMode") {
			MEMBER("group", nil) setBehaviour "COMBAT";
			MEMBER("group", nil) setCombatMode "RED";
			MEMBER("group", nil) setSpeedMode "FULL";
		};

		PUBLIC FUNCTION("","deconstructor") { 
			DELETE_VARIABLE("alert");
			DELETE_VARIABLE("areasize");
			DELETE_VARIABLE("sizegroup");
			DELETE_VARIABLE("group");
			DELETE_VARIABLE("sector");
			DELETE_VARIABLE("target");
			DELETE_VARIABLE("targets");
			DELETE_VARIABLE("grid");
			DELETE_VARIABLE("buildings");
			DELETE_VARIABLE("city");
		};
	ENDCLASS;