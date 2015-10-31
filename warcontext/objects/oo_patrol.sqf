
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
		PRIVATE VARIABLE("bool","alert");
		PRIVATE VARIABLE("scalar","areasize");		
		PRIVATE VARIABLE("array","around");		
		PRIVATE VARIABLE("array","buildings");
		PRIVATE VARIABLE("bool","city");
		PRIVATE VARIABLE("group","group");
		PRIVATE VARIABLE("scalar","flank");
		PRIVATE VARIABLE("code","sector");
		PRIVATE VARIABLE("scalar","sizegroup");
		PRIVATE VARIABLE("object","target");
		PRIVATE VARIABLE("array","targets");

		PUBLIC FUNCTION("array","constructor") {
			MEMBER("group", _this select 0);
			MEMBER("sector", _this select 1);
			MEMBER("areasize", _this select 2);

			MEMBER("sizegroup", count units (_this select 0));
			MEMBER("getBuildings", nil);
			MEMBER("alert", false);
			MEMBER("setFlank", nil);
		};

		PUBLIC FUNCTION("","getGroup") FUNC_GETVAR("group");
		PUBLIC FUNCTION("","getTarget") FUNC_GETVAR("target");
		PUBLIC FUNCTION("","getSector") FUNC_GETVAR("sector");

		PUBLIC FUNCTION("", "setFlank") {
			if(random 1 > 0.5) then {
				MEMBER("flank", 110);
			} else {
				MEMBER("flank", -110);
			};
		};

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
			_positions = ["getPositionsBuilding", _sector] call global_grid;
			MEMBER("buildings", _positions);
			if(count _positions > 10) then {
				MEMBER("city", true);
			}else{
				MEMBER("city", false);
			};
		};

		PUBLIC FUNCTION("", "fireFlare") {
			private ["_flare", "_target", "_leader"];

			_leader = leader MEMBER("group", nil);
			_target = MEMBER("target", nil);

			if(_leader distance _target < 200) then {
				_flare = "F_40mm_White" createvehicle ((_target) ModelToWorld [0,0,200]); 
				_flare setVelocity [0,0,-10];
			};
		};

		PUBLIC FUNCTION("", "engageTarget") {
			private ["_target", "_isvehicle", "_isbuilding", "_isvisible", "_ishidden", "_needflare"];

			_target = MEMBER("target", nil);
			_isvehicle = !(_target isKindOf "MAN") ;
			_isbuilding = if((nearestbuilding _target) distance _target < 10) then { true; } else { false; };
			_isvisible = MEMBER("seeTarget", nil);
			_needflare = if((date select 3 > 21) or (date select 3 <6)) then { true; } else {false;};

			if(_isvehicle) then {
				MEMBER("setMoveMode", nil);
				MEMBER("moveAround", 50);
				MEMBER("putMine", nil);
			} else {
				if(_isbuilding) then {
					//hint "movebuilding";
					if(_isvisible) then {
						MEMBER("doFire", nil);
					};
					MEMBER("setCombatMode", nil);
					//MEMBER("setMoveMode", nil);
					MEMBER("moveInto", nearestbuilding _target);
				} else {
					if((_needflare) and (random 1 > 0.5)) then { MEMBER("fireFlare", nil);};
					if(_isvisible) then {
						//hint format ["moveto %1", MEMBER("target", nil)];
						MEMBER("setCombatMode", nil);
						MEMBER("doFire", nil);
						MEMBER("moveToTarget", nil);
					} else {
						//hint format ["movearound %1", MEMBER("target", nil)];
						MEMBER("setCombatMode", nil);
						MEMBER("moveAround", 25);
					};
				};
			};
			if(random 1 > 0.9) then {
				MEMBER("callArtillery", MEMBER("target", nil));
			};
		};


		PUBLIC FUNCTION("", "getNextTarget") {
			private ["_array", "_candidats", "_index", "_leader", "_target", "_min", "_oldtarget"];
			
			_leader = leader MEMBER("group", nil);
			_candidats = [];
			_target = MEMBER("target", nil);
			_oldtarget = objnull;
			
			{
				_array = [_leader, _x];
				_index = floor (MEMBER("estimateTarget", _array));
				_candidats = _candidats + [[_index, _x]];
				sleep 0.0001;
			}foreach MEMBER("targets", nil);

			if(!isnil "_target") then {
				if(alive _target) then {
					_oldtarget = MEMBER("target", nil);
					_array = [_leader, _oldtarget];
					_index = floor (MEMBER("estimateTarget", _array));
					_candidats = _candidats + [[_index, _oldtarget]];

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

			if(_oldtarget != _target) then {
				MEMBER("target", _target);
				MEMBER("setFlank", nil);
			};
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
			private ["_target", "_objects", "_see"];
			_see = false;
			_target =  MEMBER("target", nil);

			{
				if(alive _x) then {
					//_objects = lineIntersectsWith [eyePos _x, position _target];
					//if(count _objects == 0) then { _see = true;};
					_array = [_x, _target];
					if(MEMBER("estimateTarget", _array) < 2) then {_see = true;};
				};
				sleep 0.0001;
			} foreach units MEMBER("group", nil);
			_see;
		};		

		PUBLIC FUNCTION("array", "estimateTarget") {
			private ["_target", "_position", "_realposition", "_source"];
			_source = _this select 0;
			_target = _this select 1;
			
			_position = _source getHideFrom _target;
			_realposition = position _target;
			_position distance _realposition;
		};

		PUBLIC FUNCTION("", "doFire") {
			private ["_target", "_skill"];
			
			_target = MEMBER("target", nil);
			{
				_skill = MEMBER("getSkill", (_x distance _target));
				_x setskill ["aimingAccuracy", _skill];
				_x setskill ["aimingShake", _skill];
				_x dotarget _target;
				_x dofire _target;
				_x setUnitPos "Middle";
				sleep 0.0001;
			}foreach units MEMBER("group", nil);
		};

		PUBLIC FUNCTION("scalar", "getSkill") {
			private ["_skill", "_distance"];
			_distance = _this;
			if(_distance > 300) then {_distance = 300};
			_skill = wcskill * (1 - (_this / 300));
			_skill;
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

			_dir = _dir + MEMBER("flank", nil);
			if(_dir > 359) then {_dir = _dir - 360};
			if(_dir < 0) then {_dir = _dir + 360};

			_position = [position _target, _areasize, _dir] call BIS_fnc_relPos;
			MEMBER("moveTo", _position);
		};

		// put mine
		PUBLIC FUNCTION("", "putMine") {
			private ["_leader", "_target"];
			
			_target = MEMBER("target", nil);
			_leader = leader MEMBER("group", nil);

			if((_target distance _leader < 10) and (damage _target < 0.9)) then {
				createVehicle ["ATMine_Range_Ammo", position _target,[], 0, "can_collide"];
			};
		};		

		// moveTo position
		PUBLIC FUNCTION("array", "moveTo") {
			private ["_group", "_position", "_wp"];

			_position = _this;
			_group = MEMBER("group", nil);

			{
				_x domove _position;
				sleep 0.001;
			}foreach units _group;

			sleep 30;
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
				_key = ["getSectorFromPos", position _target] call global_grid;
				_sector = ["get", str(_key)] call global_zone_hashmap;
				if(!isnil "_sector") then {
					["setSuppression", true] call _artillery;
				} else {
					["setSuppression", false] call _artillery;
				};
				["callFireOnTarget", _target] call _artillery;
			};
		};

		// soldiers walk around the sector
		PUBLIC FUNCTION("", "walk") {
			private ["_around", "_areasize", "_basesector", "_counter", "_leader", "_position", "_group", "_formationtype", "_wp", "_sector"];
			
			_group = MEMBER("group", nil);
			_leader = leader _group;
			_areasize = MEMBER("areasize", nil);

			MEMBER("setSafeMode", nil);
			
			_formationtype = ["COLUMN", "STAG COLUMN","WEDGE","ECH LEFT","ECH RIGHT","VEE","LINE","FILE","DIAMOND"] call BIS_fnc_selectRandom;
			_group setFormation _formationtype;

			_position = position _leader;
			_basesector = "getSector" call MEMBER("sector", nil);
			
			while { (position _leader) distance _position < _areasize } do {
				_around = ["getSectorAllAround", [_basesector, 2]] call global_grid;
				_sector = _around call BIS_fnc_selectRandom;
				_position = ["getPosFromSector", _sector] call global_grid;
				_position = [_position, _areasize, random 359] call BIS_fnc_relPos;
				sleep 0.0001;
			};

			_wp = _group addWaypoint [_position, 10];
			_wp setWaypointPosition [_position, 10];
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
			MEMBER("group", nil) allowFleeing 0.1;
		};

		PUBLIC FUNCTION("", "setMoveMode") {
			MEMBER("group", nil) setBehaviour "AWARE";
			MEMBER("group", nil) setCombatMode "RED";
			MEMBER("group", nil) setSpeedMode "FULL";
			MEMBER("group", nil) allowFleeing 0.1;
		};		

		PUBLIC FUNCTION("", "setSafeMode") {
			MEMBER("group", nil) setBehaviour "SAFE";
			MEMBER("group", nil) setCombatMode "GREEN";
			MEMBER("group", nil) setSpeedMode "NORMAL";
			MEMBER("group", nil) allowFleeing 0.1;
		};

		PUBLIC FUNCTION("", "setCombatMode") {
			MEMBER("group", nil) setBehaviour "COMBAT";
			MEMBER("group", nil) setCombatMode "RED";
			MEMBER("group", nil) setSpeedMode "FULL";
			MEMBER("group", nil) allowFleeing 0.1;
		};

		PUBLIC FUNCTION("","deconstructor") { 
			DELETE_VARIABLE("alert");
			DELETE_VARIABLE("around");
			DELETE_VARIABLE("areasize");
			DELETE_VARIABLE("sizegroup");
			DELETE_VARIABLE("group");
			DELETE_VARIABLE("sector");
			DELETE_VARIABLE("target");
			DELETE_VARIABLE("targets");
			DELETE_VARIABLE("buildings");
			DELETE_VARIABLE("city");
			DELETE_VARIABLE("flank");
		};
	ENDCLASS;