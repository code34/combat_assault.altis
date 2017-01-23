	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2016 Nicolas BOITEUX

	CLASS OO_DEPLOY
	
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

	CLASS("OO_DEPLOY")
		PRIVATE VARIABLE("code","hashmap");
		PRIVATE VARIABLE("array","position");
		PRIVATE VARIABLE("array","sector");
		PRIVATE VARIABLE("object","ammobox");


		PUBLIC FUNCTION("array","constructor") {
			MEMBER("hashmap", global_zone_hashmap);
			MEMBER("computePosition", nil);
			MEMBER("ammobox", objNull);
		};

		PUBLIC FUNCTION("", "computePosition"){
			private ["_sector", "_position"];	

			if!(MEMBER("checkSectorActive", nil)) then {
				
				hint "I define a new position";

				_sector = MEMBER("defineSector", nil);
				_sector = MEMBER("findSpawnSector", _sector);
				_position = ["getPosFromSector",  _sector] call global_grid;
				
				MEMBER("createSpawn", _position);
				MEMBER("position", _position);
				MEMBER("sector", _sector);
			};
		};


		/*
			Nettoye le terrain et crée une ammobox
		*/
		PRIVATE FUNCTION("array", "createSpawn") {
			private ["_position", "_vehicle"];

			_position = _this;
			{ _x hideObjectGlobal true } foreach (nearestTerrainObjects [_position,[], 20]);
			deleteVehicle MEMBER("ammobox", nil);
			_position = _position findEmptyPosition [0,20];
			_vehicle = "B_supplyCrate_F" createVehicle _position;
			_tent = "CamoNet_BLUFOR_F" createVehicle _position;
			_tent setpos _position;

			["AmmoboxInit",[_vehicle,true,{true}]] spawn BIS_fnc_arsenal;
			MEMBER("ammobox", _vehicle);

			//_vehicle = "I_Heli_Transport_02_F" createVehicle _position;
			//_vehicle engineOn true;
			//_vehicle lock true;
			//_group = createGroup west;
			//_pilot = _group createunit ["B_Soldier_F", _position, [], 0, "FORM"];
			//_pilot moveInDriver _vehicle;
		};

		PUBLIC FUNCTION("", "getPosition"){
			MEMBER("position", nil);
		};

		/*
		Find a sector free of enemy around a sector at 7 squares of distance
		*/
		PRIVATE FUNCTION("array", "findSpawnSector") {
			private ["_sector"];
			_sector = _this;
			_find = false;
			_around = ["getAllSectorsAroundSector", [_sector, 5]] call global_grid;

			while { _find isEqualTo false } do {
				_sector = _around call BIS_fnc_selectRandom;
				if(MEMBER("checkSector", _sector)) then { 
					_find = true;
				}else{
					_around = _around - [_sector];
				};
				sleep 0.1;
			};
			_sector;
		};


		/*
		Check if enemy are in square around
		*/
		PUBLIC FUNCTION("", "checkSectorActive"){
			private ["_sector", "_activ", "_around"];
			
			_sector = MEMBER("sector", nil);
			if(isnil "_sector") exitWith { false; };
			
			_activ = false;
			_around = ["getAllSectorsAroundSector", [_sector, 5]] call global_grid;
			{
				_sector = ["Get", str(_x)] call global_zone_hashmap;
				if(!isnil "_sector") then {
					if("getState" call _sector < 2) then {
						_activ = true;
					};
				};
			}foreach _around;
			_activ;
		};

		/*
		Check if enemy are in square around
		*/
		PRIVATE FUNCTION("array", "checkSector"){
			private ["_sector", "_safe", "_around"];
			
			_sector = _this;
			_safe = true;

			_around = ["getAllSectorsAroundSector", [_sector, 2]] call global_grid;
			{
				_sector = ["Get", str(_x)] call global_zone_hashmap;
				if(!isnil "_sector") then {
					if("getState" call _sector < 2) then {
						_safe = false;
					};
				};
			}foreach _around;
			_safe;
		};

		/*
		Find a sector in hashmap with enemy
		*/
		PRIVATE FUNCTION("", "defineSector"){
			private ["_sector", "_list", "_flag", "_entry"];

			_list = "entrySet" call MEMBER("hashmap",nil);
			_flag = true;
			_sector = [];
			
			while { _flag } do {
				_entry = _list call BIS_fnc_selectRandom;
				if("getState" call _entry < 2) then { 
					_sector = "getSector" call _entry;
					_flag = false;
				} else {
					_list = _list - [_x];
				};
				sleep 0.0001;
			};
			_sector;
		};

		PUBLIC FUNCTION("","deconstructor") { 
			DELETE_VARIABLE("sector");
		};
	ENDCLASS;