
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

		PUBLIC FUNCTION("array","constructor") {
			MEMBER("group", _this select 0);
			MEMBER("sector", _this select 1);
			MEMBER("areasize", _this select 2);

			MEMBER("sizegroup", count units (_this select 0));
			_grid = ["new", [31000,31000,100,100]] call OO_GRID;
			MEMBER("grid", _grid);
			MEMBER("setAlert", nil);
		};

		PUBLIC FUNCTION("","getGrid") FUNC_GETVAR("grid");
		PUBLIC FUNCTION("","getGroup") FUNC_GETVAR("group");
		PUBLIC FUNCTION("","getTarget") FUNC_GETVAR("target");
		PUBLIC FUNCTION("","getSector") FUNC_GETVAR("sector");

		PUBLIC FUNCTION("", "patrol") {
			private ["_group", "_position"];
			_group = MEMBER("group", nil);
			while { count (units _group) > 0 } do {
				//MEMBER("setSafeMode", nil);
				//MEMBER("setCombatMode", nil);
				//MEMBER("walk", nil);
				//MEMBER("callArtillery", player);
				//MEMBER("setAlert", nil);
				//MEMBER("dropSmoke", nil);
				//MEMBER("dropFlare", nil);
				//MEMBER("moveTo", position player);
				//MEMBER("moveAround", 20);
				//MEMBER("moveInto", nearestBuilding player);
				//MEMBER("doFire", nil);
				//hint format ["estimate: %1", MEMBER("estimateTarget", player)];
				//hint format ["estimate: %1", MEMBER("seeTarget", player)];
				//hint format ["targets : %1", MEMBER("targets", nil)];
				//_position = "getPosition" call MEMBER("sector", nil);
				//MEMBER("getTargets", _position);
				//MEMBER("getNextTarget", nil);
				//MEMBER("engageTarget", nil);
				sleep 10;
			};
			MEMBER("deconstructor", nil);
		};

		PUBLIC FUNCTION("", "engageTarget") {
			private ["_target", "_isvehicle", "_isbuilding", "_isvisible", "_ishidden"];

			//_target = MEMBER("target", nil);
			_target = player;
			_isvehicle = !(_target  == vehicle _target);
			_isbuilding = if((nearestbuilding _target) distance _target < 10) then { true; } else { false; };
			_isvisible = MEMBER("seeTarget", _target);
			_ishidden = isHidden _target;

			if(_isvisible) then {
				MEMBER("doFire", nil);
			};
			if(_isbuilding) then {
				MEMBER("moveInto", nearestbuilding _target);
			};
			if(_isvehicle) then {
				MEMBER("moveAround", 50);
			};
			if(_ishidden) then {
				MEMBER("moveAround", 20);
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
			}foreach MEMBER("targets", nil);

			if(!isnil "_target") then {
				if(alive _target) then {
					_index = floor (MEMBER("estimateTarget", MEMBER("target", nil)));
					_candidats = _candidats + [[_index, MEMBER("target", nil)]];
				};
			};

			// over no target, not see
			_min = 1000;
			{
				if((_x select 0) < _min) then {
					_target = _x select 1;
					_min = _x select 0;
				};
			}foreach _candidats;
			MEMBER("target", _target);
		};		

		PUBLIC FUNCTION("", "revealTarget") {
			{
				leader MEMBER("group", nil) reveal [_x, 4];
				sleep 0.001;
			}foreach units MEMBER("targets", nil);
		};		

		PUBLIC FUNCTION("array", "getTargets") {
			private ["_position", "_list"];

			_position = _this;
			_list = _position nearEntities [["Man", "Tank"], 600];
			sleep 0.5;
			{
				if(side _x != west) then {
					_list set [_foreachindex, -1];
				};
			}foreach _list;
			_list = _list - [-1];
			MEMBER("targets", _list);
		};		

		PUBLIC FUNCTION("object", "seeTarget") {
			if(MEMBER("estimateTarget", _this) < 5) then { true; } else { false;};
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
			}foreach units MEMBER("group", nil);
			MEMBER("moveTo", position MEMBER("target", nil));
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
			private ["_areasize", "_position"];
			_areasize = _this;
			_position = [position MEMBER("target", nil), random (_areasize), random 359] call BIS_fnc_relPos;
			MEMBER("moveTo", _position);
		};

		// moveTo position
		PUBLIC FUNCTION("array", "moveTo") {
			private ["_group", "_position", "_wp"];

			_position = _this;
			_group = MEMBER("group", nil);
			_wp = _group addWaypoint [_position, 25];
			_wp setWaypointPosition [_position, 25];
			_wp setWaypointType "HOLD";
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
			private ["_alert"];
			_alert = false;

			{
				if((leader MEMBER("group", nil)) knowsAbout _x > 0.4) then {
					_alert = true;
				};
				sleep 0.0001;
			}foreach MEMBER("targets", nil);

			if!(MEMBER("isCompleteGroup", nil)) then {
				_alert = true;
			};
			
			if(_alert) then {
				["setAlert", true] call MEMBER("sector", nil);
			};
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
				["setTarget", _target] call _artillery;
				"autoSetAmmo" call _artillery;
				"doFire" call _artillery;
			};
		};		

		PUBLIC FUNCTION("", "walk") {
			private ["_areasize", "_leader", "_position", "_group", "_formationtype", "_wp"];
			
			_group = MEMBER("group", nil);
			_leader = leader _group;
			_areasize = MEMBER("areasize", nil);
			
			_formationtype = ["COLUMN", "STAG COLUMN","WEDGE","ECH LEFT","ECH RIGHT","VEE","LINE","FILE","DIAMOND"] call BIS_fnc_selectRandom;
			_group setFormation _formationtype;

			_position = "getPosition" call MEMBER("sector", nil);

			while { (position _leader) distance _position < 50 } do {
				_position = [_position, _areasize + (random 50), random 359] call BIS_fnc_relPos;
				sleep 0.1;
			};

			_wp = _group addWaypoint [_position, 25];
			_wp setWaypointPosition [_position, 25];
			_wp setWaypointType "GUARD";
			_wp setWaypointVisible true;
			_wp setWaypointSpeed "NORMAL";
			_wp setWaypointStatements ["true", "this setvariable ['complete', true]; false"];
			_group setCurrentWaypoint _wp;
			sleep 30;
			deletewaypoint _wp;
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
		};
	ENDCLASS;