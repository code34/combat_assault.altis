	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2016-2017 Nicolas BOITEUX

	CLASS OO_BASEGENERATOR
	
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

	CLASS("OO_BASEGENERATOR")
		PRIVATE VARIABLE("array","position");
		PRIVATE VARIABLE("array","structures");
		PRIVATE VARIABLE("string","marker");
		PRIVATE VARIABLE("string","deploymarker");
		PRIVATE VARIABLE("object","base");
		PRIVATE VARIABLE("bool","packed");
		PRIVATE VARIABLE("code", "grid");

		PRIVATE VARIABLE("bool", "medicactive");
		PRIVATE VARIABLE("bool", "radaractive");
		PRIVATE VARIABLE("bool", "toweractive");
		PRIVATE VARIABLE("bool", "bunkeractive");
		PRIVATE VARIABLE("bool", "researchactive");


		PUBLIC FUNCTION("","constructor") {
			private ["_size", "_sectorsize", "_grid", "_position"];

			_size = getNumber (configfile >> "CfgWorlds" >> worldName >> "mapSize");
			_sectorsize = 12;
			_grid = ["new", [0,0, _size, _size,_sectorsize,_sectorsize]] call OO_GRID;
			MEMBER("grid", _grid);

			MEMBER("medicactive", false);
			MEMBER("radaractive", false);
			MEMBER("toweractive", false);
			MEMBER("bunkeractive", false);
			MEMBER("researchactive", false);

			_position = MEMBER("generateRandomPosition", nil);
			MEMBER("createMarker", _position);
			MEMBER("createDeployMarker", _position);
			MEMBER("buildTerrain", _position);
			MEMBER("buildHQ", _position);
			MEMBER("buildStructures", _position);
			MEMBER("packed", false);
		};

		PUBLIC FUNCTION("","getPosition") FUNC_GETVAR("position");

		PUBLIC FUNCTION("array", "setPosition"){
			MEMBER("position", _this);
		};

		PUBLIC FUNCTION("array", "buildTerrain"){
			{ _x hideObjectGlobal true } foreach (nearestTerrainObjects [_this,[], 150]);
		}; 

		PUBLIC FUNCTION("", "getRandomStructure"){
			private ["_kind", "_type"];

			_kind = "";
			_type = [
				["Land_Radar_Small_F", 0.97, MEMBER("radaractive", nil)],
				["Land_Cargo_Tower_V2_F", 0.97, MEMBER("toweractive", nil)],
				["Land_HBarrierTower_F", 0.93, MEMBER("toweractive", nil)],
				["Land_Cargo_Patrol_V1_F", 0.93, MEMBER("bunkeractive", nil)],
				["CamoNet_BLUFOR_F", 0.90, true],
				["Land_Medevac_house_V1_F", 0.9, MEMBER("medicactive", nil)],
				["Land_Research_house_V1_F", 0.9, MEMBER("researchactive", nil)],
				["Land_Cargo_House_V3_F", 0.7, true]
				];

			while { _kind isEqualTo ""} do {
				{
					if((random 1 > (_x select 1)) and (_x select 2)) then {
						_kind = _x select 0;
					};
				} foreach _type;
				sleep 0.1;
			};
			_kind;
		};

		PUBLIC FUNCTION("array", "buildStructures"){
			private ["_structures", "_position", "_sectors", "_grid", "_object"];

			_position = _this;
			_grid = MEMBER("grid", nil);
			_structures = [];

			_sectors = ["getAllSectorsAroundPos", [_position, 3]] call _grid;
			{
				_position = ["getPosFromSector", _x]  call _grid;
				_object = MEMBER("getRandomStructure", nil) createVehicle _position;
				_object setdir (selectRandom [0,90,180,270]);
				_structures = _structures + [_object];
				sleep 0.01;
			}foreach _sectors;
			MEMBER("structures", _structures);
		};

		PUBLIC FUNCTION("array", "buildHQ"){
			private ["_position", "_base"];

			_position = _this;

			_base = objNull;
			_base = "Land_Cargo_HQ_V2_F" createVehicle (_position findEmptyPosition [5,50]);
			[[_base, ["Pack Base", "client\scripts\packbase.sqf", nil, 1.5, false]],"addAction",true,true] call BIS_fnc_MP;
			_base addEventHandler ['HandleDamage', { false; }];
			
			"respawn_west" setmarkerpos _position;
			MEMBER("marker", nil) setMarkerPos _position;
			MEMBER("deploymarker", nil) setMarkerPos _position;
			MEMBER("position", _position);
			MEMBER("base", _base);
		};

		PUBLIC FUNCTION("", "deleteBase"){
			deleteVehicle MEMBER("base", nil);
			deleteMarker MEMBER("marker", nil);
		};

		PUBLIC FUNCTION("", "generateRandomPosition"){
			private ["_flag", "_sector", "_position", "_size", "_sectorsize"];
			
			_flag = false;
			_size = getNumber (configfile >> "CfgWorlds" >> worldName >> "mapSize");
			_sectorsize = 100;

			while { !_flag } do {
				_sector = [ceil (random (_size/_sectorsize)), ceil (random (_size/_sectorsize))];
				_position = ["getPosFromSector", _sector] call global_grid;
				if!(surfaceIsWater _position) then {
					if((_position isFlatEmpty  [100, -1, 0.05, 100, -1]) isEqualTo []) then {
						_flag = true;
					};
				};
				sleep 0.01;
			};
			_position;
		};

		PUBLIC FUNCTION("array", "createMarker"){
			private ["_marker"];
			_marker = createMarker ["globalbase", _this];
			_marker setMarkerText (toUpper ((["generateName", (ceil (random 3) + 1)] call global_namegenerator)  + " Base"));
			_marker setMarkerType "b_hq";
			MEMBER("marker", _marker);
		};

		PUBLIC FUNCTION("array", "createDeployMarker"){
			private ["_marker"];
			_marker = createMarker ["globalbasedeploy", _this];
			_marker setMarkerShape "ELLIPSE";
			_marker setMarkerBrush "border";
			_marker setMarkerSize [1500,1500];
			_marker setMarkerColorLocal "ColorBlue";
			MEMBER("deploymarker", _marker);
		};		

		PUBLIC FUNCTION("", "unpackBase"){
			private ["_position", "_base", "_newposition", "_dir", "_sectors", "_position"];

			_position = getMarkerPos "respawn_west";

			if(MEMBER("packed", nil)) then {
				MEMBER("packed", false);
				_dir = getDir MEMBER("base", nil);
				deleteVehicle MEMBER("base", nil);

				_position =  (_position findEmptyPosition [5,50]);
				if(_position isEqualTo []) exitWith {};

				MEMBER("buildHQ", _position);
				MEMBER("checkStructuresAvalaible", nil);
				MEMBER("buildStructures", _position);
			};
		};

		PUBLIC FUNCTION("", "checkStructuresAvalaible"){
			if (("countWest" call global_atc) > 0) then { MEMBER("toweractive", true); } else { MEMBER("toweractive", false); };
			if (("countWest" call global_atc) > 0) then { MEMBER("radaractive", true); } else { MEMBER("radaractive", false); };
			if (("countWest" call global_factory) > 0) then { MEMBER("bunkeractive", true); } else { MEMBER("bunkeractive", false); };
			if (("countWest" call global_factory) > 0) then { MEMBER("researchactive", true); } else { MEMBER("reserchactive", false); };
			if (("getTicket" call global_ticket) > 100) then { MEMBER("medicactive", true); } else { MEMBER("medicactive", false); };
		};

		PUBLIC FUNCTION("", "packBase"){
			private ["_position", "_base", "_newposition", "_mark", "_deploymark"];
			
			_position = getMarkerPos "respawn_west";

			if(!MEMBER("packed", nil)) then {
				MEMBER("packed", true);
				deleteVehicle MEMBER("base", nil);
				{deleteVehicle _x; sleep 0.1; } forEach MEMBER("structures", nil);

				_newposition =  (_position findEmptyPosition [0,15]);
				if(_newposition isEqualTo []) exitWith {};

				_base = "B_Truck_01_transport_F" createVehicle _newposition;
				[[_base, ["Unpack Base", "client\scripts\unpackbase.sqf", nil, 1.5, false]],"addAction",true,true] call BIS_fnc_MP;
				
				_mark = MEMBER("marker", nil);
				_deploymark = MEMBER("deploymarker", nil);

				[_base, _mark, _deploymark] spawn {
					while { alive (_this select 0)} do {
						(_this select 1) setMarkerPos (getpos (_this select 0));
						(_this select 2) setMarkerPos (getpos (_this select 0));
						"respawn_west" setmarkerpos (getpos (_this select 0));
						sleep 0.1;
					};
				};
				MEMBER("base", _base);
			};
		};		

		PUBLIC FUNCTION("","deconstructor") { 
			MEMBER("deleteBase", nil);
			DELETE_VARIABLE("position");
			DELETE_VARIABLE("marker");
			DELETE_VARIABLE("base");
		};
	ENDCLASS;