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
		PRIVATE VARIABLE("object","base");
		PRIVATE VARIABLE("bool","packed");
		PRIVATE VARIABLE("code", "grid");

		PUBLIC FUNCTION("","constructor") {
			
			_size = getNumber (configfile >> "CfgWorlds" >> worldName >> "mapSize");
			_sectorsize = 10;
			_grid = ["new", [0,0, _size, _size,_sectorsize,_sectorsize]] call OO_GRID;
			MEMBER("grid", _grid);

			_position = MEMBER("generateRandomPosition", nil);
			MEMBER("createMarker", _position);
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
			private ["_position", "_positions", "_grid"];
			_position = _this;
			{ _x hideObjectGlobal true } foreach (nearestTerrainObjects [_position,[], 150]);
		}; 

		PUBLIC FUNCTION("array", "buildStructures"){
			private ["_type", "_structures", "_position", "_sectors", "_grid"];

			_position = _this;
			_grid = MEMBER("grid", nil);
			_structures = [];

			_type = ["Land_Cargo_House_V3_F","Land_Cargo_House_V3_F","Land_Cargo_Patrol_V1_F", "Land_Cargo_House_V3_F","Land_Cargo_House_V3_F", "Land_Cargo_Patrol_V1_F", "Land_Medevac_house_V1_F", "Land_Medevac_house_V1_F", "Land_Medevac_house_V1_F", "Land_Medevac_house_V1_F", "Land_HBarrierTower_F", "CamoNet_BLUFOR_F", "Land_Research_house_V1_F"];
			_sectors = ["getAllSectorsAroundPos", [_position, 3]] call _grid;
			{
				//_positions = _positions + [["getPosFromSector", _x]  call _grid];
				_position = ["getPosFromSector", _x]  call _grid;
				_object = (selectRandom _type)  createVehicle _position;
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
			private ["_position", "_marker"];
			_position = _this;
			_marker = createMarker ["globalbase", _position];
			_marker setMarkerText (toUpper ((["generateName", (ceil (random 3) + 1)] call global_namegenerator)  + " Base"));
			_marker setMarkerType "b_hq";
			MEMBER("marker", _marker);
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
				MEMBER("buildStructures", _position);
			};
		};

		PUBLIC FUNCTION("", "packBase"){
			private ["_position", "_base", "_newposition"];
			
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
				[_base, _mark] spawn {
					while { alive (_this select 0)} do {
						(_this select 1) setMarkerPos (getpos (_this select 0));
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