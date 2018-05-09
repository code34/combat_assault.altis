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
			DEBUG(#, "OO_BASEGENERATOR::constructor")
			private _size = getNumber (configfile >> "CfgWorlds" >> worldName >> "mapSize");
			private _sectorsize = 12;
			private _grid = ["new", [0,0, _size, _size,_sectorsize,_sectorsize]] call OO_GRID;
			private _position = MEMBER("generateRandomPosition", nil);

			MEMBER("structures", []);
			MEMBER("grid", _grid);
			MEMBER("medicactive", false);
			MEMBER("radaractive", false);
			MEMBER("toweractive", false);
			MEMBER("bunkeractive", false);
			MEMBER("researchactive", false);
			MEMBER("createMarker", _position);
			MEMBER("createDeployMarker", _position);
			"respawn_west" setmarkerpos _position;
			MEMBER("position", _position);
			MEMBER("packed", false);
			MEMBER("packBase", nil);
		};

		PUBLIC FUNCTION("","getPosition") FUNC_GETVAR("position");

		PUBLIC FUNCTION("array", "setPosition"){
			DEBUG(#, "OO_BASEGENERATOR::setPosition")
			MEMBER("position", _this);
		};

		PUBLIC FUNCTION("array", "buildTerrain"){
			DEBUG(#, "OO_BASEGENERATOR::buildTerrain")
			{ _x hideObjectGlobal true } foreach (nearestTerrainObjects [_this,[], 150]);
		}; 

		PUBLIC FUNCTION("", "isAlive"){
			DEBUG(#, "OO_BASEGENERATOR::isAlive")
			alive MEMBER("base", nil);
		};

		PUBLIC FUNCTION("", "isPackedBase"){
			DEBUG(#, "OO_BASEGENERATOR::isPackedBase")
			MEMBER("packed", nil);
		};

		PUBLIC FUNCTION("", "getRandomStructure"){
			DEBUG(#, "OO_BASEGENERATOR::getRandomStructure")
			private _kind = "";
			private _type = [
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
			DEBUG(#, "OO_BASEGENERATOR::buildStructures")
			private _position = _this;
			private _grid = MEMBER("grid", nil);
			private _object = objNull;

			private _sectors = ["getAllSectorsAroundPos", [_position, 3]] call _grid;
			{
				_position = ["getPosFromSector", _x]  call _grid;
				_object = MEMBER("getRandomStructure", nil) createVehicle _position;
				_object setdir (selectRandom [0,90,180,270]);
				MEMBER("structures", nil) pushBack _object;
				sleep 0.01;
			}foreach _sectors;
			true;
		};

		PUBLIC FUNCTION("array", "buildHQ"){
			DEBUG(#, "OO_BASEGENERATOR::buildHQ")
			private _position = _this;
			private _base = objNull;

			_base = "Land_Cargo_HQ_V2_F" createVehicle (_position findEmptyPosition [5,50]);
			[[_base, ["Pack Base", "client\scripts\packbase.sqf", nil, 1.5, false]],"addAction",true,true] call BIS_fnc_MP;
			//_base addEventHandler ['HandleDamage', { false; }];
			
			"respawn_west" setmarkerpos _position;
			MEMBER("marker", nil) setMarkerPos _position;
			MEMBER("deploymarker", nil) setMarkerPos _position;
			MEMBER("position", _position);
			MEMBER("base", _base);
		};

		PUBLIC FUNCTION("", "deleteBase"){
			DEBUG(#, "OO_BASEGENERATOR::deleteBase")
			deleteVehicle MEMBER("base", nil);
			deleteMarker MEMBER("marker", nil);
		};

		PUBLIC FUNCTION("", "generateRandomPosition"){
			DEBUG(#, "OO_BASEGENERATOR::generateRandomPosition")
			private _flag = false;
			private _size = getNumber (configfile >> "CfgWorlds" >> worldName >> "mapSize");
			private _sectorsize = 100;
			private _sector = [];
			private _position = [];

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
			DEBUG(#, "OO_BASEGENERATOR::createMarker")
			private _marker = createMarker ["globalbase", _this];
			_marker setMarkerText (toUpper ((["generateName", (ceil (random 3) + 1)] call global_namegenerator)  + " Base"));
			_marker setMarkerType "b_hq";
			MEMBER("marker", _marker);
		};

		PUBLIC FUNCTION("array", "createDeployMarker"){
			DEBUG(#, "OO_BASEGENERATOR::createDeployMarker")
			private _marker = createMarker ["globalbasedeploy", _this];
			_marker setMarkerShape "ELLIPSE";
			_marker setMarkerBrush "FDiagonal";
			_marker setMarkerSize [1500 ,1500];
			_marker setMarkerColorLocal "ColorBlue";
			MEMBER("deploymarker", _marker);
		};		

		PUBLIC FUNCTION("", "unpackBase"){
			DEBUG(#, "OO_BASEGENERATOR::unpackBase")
			private _position = getMarkerPos "respawn_west";
			private _dir = 0;
			if(!MEMBER("packed", nil)) exitWith { };
			MEMBER("packed", false);
			_position =  (_position findEmptyPosition [5,50]);
			if(_position isEqualTo []) exitWith { MEMBER("packed", true);};
			_dir = getDir MEMBER("base", nil);
			deleteVehicle MEMBER("base", nil);
			MEMBER("buildHQ", _position);
			MEMBER("deploymarker", nil) setMarkerSize [1500 , 1500];
			["remoteSpawn", ["BME_netcode_client_notifyBaseUnpack", "", "client"]] call server_bme;
		};

		PUBLIC FUNCTION("", "packBase"){
			DEBUG(#, "OO_BASEGENERATOR::packBase")
			private _position = getMarkerPos "respawn_west";
			private _base = objNull;
			if(MEMBER("packed", nil)) exitWith { };
			MEMBER("packed", true);
			_position =  (_position findEmptyPosition [0,15]);
			if(_position isEqualTo []) exitWith {MEMBER("packed", false);};
			deleteVehicle MEMBER("base", nil);
			{deleteVehicle _x; sleep 0.1; } forEach MEMBER("structures", nil);
			_base = "B_Truck_01_transport_F" createVehicle _position;
			[[_base, ["Unpack Base", "client\scripts\unpackbase.sqf", nil, 1.5, false]],"addAction",true,true] call BIS_fnc_MP;
			MEMBER("base", _base);
			[_base, MEMBER("marker", nil)] spawn {
				while { alive (_this select 0)} do {
					(_this select 1) setMarkerPos (getpos (_this select 0));
					"respawn_west" setmarkerpos (getpos (_this select 0));
					sleep 0.1;
				};
			};
			MEMBER("deploymarker", nil) setMarkerSize [0,0];
			["remoteSpawn", ["BME_netcode_client_notifyBasePack", "", "client"]] call server_bme;
		};

		PUBLIC FUNCTION("", "checkStructuresAvalaible"){
			DEBUG(#, "OO_BASEGENERATOR::checkStructuresAvalaible")
			if (("countWest" call global_atc) > 0) then { MEMBER("toweractive", true); } else { MEMBER("toweractive", false); };
			if (("countWest" call global_atc) > 0) then { MEMBER("radaractive", true); } else { MEMBER("radaractive", false); };
			if (("countWest" call global_factory) > 0) then { MEMBER("bunkeractive", true); } else { MEMBER("bunkeractive", false); };
			if (("countWest" call global_factory) > 0) then { MEMBER("researchactive", true); } else { MEMBER("reserchactive", false); };
			if (("getTicket" call global_ticket) > 100) then { MEMBER("medicactive", true); } else { MEMBER("medicactive", false); };
		};

		PUBLIC FUNCTION("","deconstructor") {
			DEBUG(#, "OO_BASEGENERATOR::deconstructor")
			MEMBER("deleteBase", nil);
			DELETE_VARIABLE("position");
			DELETE_VARIABLE("marker");
			DELETE_VARIABLE("base");
		};
	ENDCLASS;