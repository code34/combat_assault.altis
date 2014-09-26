	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014 Nicolas BOITEUX

	CLASS OO_CONTROLLER
	
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

	CLASS("OO_CONTROLLER")
		PRIVATE VARIABLE("array","groundplayers");
		PRIVATE VARIABLE("array","airplayers");
		PRIVATE VARIABLE("array","queuesector");
		PRIVATE VARIABLE("code","grid");
		PRIVATE VARIABLE("code","zone_hashmap");
		PRIVATE VARIABLE("code","player_hashmap");

		PUBLIC FUNCTION("array","constructor") {
			MEMBER("setPlayers", nil);
			_grid = ["new", [31000,31000,100,100]] call OO_GRID;
			MEMBER("grid", _grid);

			MEMBER("zone_hashmap", global_zone_hashmap);

			_hashmap = ["new", []] call OO_HASHMAP;
			MEMBER("player_hashmap", _hashmap);

			_array = [];
			MEMBER("queuesector", _array);
		};

		PUBLIC FUNCTION("","getAirPlayers") FUNC_GETVAR("airplayers");
		PUBLIC FUNCTION("","getGroundPlayers") FUNC_GETVAR("groundplayers");

		PUBLIC FUNCTION("", "getPlayers") {
			private ["_temp"];
			_temp = MEMBER("groundplayers", nil) + MEMBER("airplayers", nil);
			_temp;
		};

		PUBLIC FUNCTION("string", "getPlayersOfType") {
			private ["_array"];
			_array = [];
			{
				if(typeof _x == _this) then {
					_array = _array + [_x];
				};
				sleep 0.0001;
			}foreach playableUnits;
			_array;
		};

		PUBLIC FUNCTION("", "setGroundPlayers") {
			private ["_temp"];
				
			_temp = MEMBER("getPlayersOfType", "B_crew_F");
			_temp = _temp + MEMBER("getPlayersOfType", "B_Soldier_F");

			MEMBER("groundplayers", _temp);
		};

		PUBLIC FUNCTION("", "setAirPlayers") {
			private ["_temp"];
			_temp = MEMBER("getPlayersOfType", "B_Pilot_F");
			MEMBER("airplayers", _temp);
		};

		PUBLIC FUNCTION("", "setPlayers") {
			MEMBER("setGroundPlayers", nil);
			MEMBER("setAirPlayers", nil);
		};

		PUBLIC FUNCTION("", "getNewSector") {
			private ["_array", "_newsector", "_sector"];
			_newsector = [];
			{
				_sector = MEMBER("getPlayerNewSector", _x);
				if(count _sector > 0) then {
					_array = [_x, _sector];
					MEMBER("setPlayerSaveSector", _array);
					_newsector = _newsector + [_sector];
				};
				sleep 0.001;
			}foreach MEMBER("groundplayers", nil);
			_newsector;
		};

		PUBLIC FUNCTION("", "getNewSectorAround") {
			private ["_array", "_around", "_temp"];
			_around = [];
			_array = MEMBER("getNewSector", nil);		
			{
				_temp = ["getSectorAllAround", [_x, 3]] call MEMBER("grid", nil);
				_around = _around + _temp;
			}foreach _array; 
			_around;
		};


		PUBLIC FUNCTION("array", "expandSector"){
			private ["_queue"];
			_queue = MEMBER("queuesector", nil) + [_this];
			MEMBER("queuesector", _queue);
		};

		PUBLIC FUNCTION("array", "expandSectorAround"){
			private ["_around", "_sector"];

			_sector = _this;
			_around = ["getSectorAllAround", [_sector,3]] call MEMBER("grid", nil);

			{
				if(random 1 > 0.9) then {
					MEMBER("expandSector", _x);
				};
				sleep 0.001;
			}foreach _around;
		};

		PUBLIC FUNCTION("", "queueSector"){
			private ["_queue", "_key", "_position", "_sector"];
			while { true } do {
				waituntil { count MEMBER("queuesector", nil) > 0 };
				_key = MEMBER("queuesector", nil) select 0;
				_sector = ["get", str(_key)] call MEMBER("zone_hashmap",nil);
				if(isnil "_sector") then {
					_position = ["getPosFromSector", _key] call MEMBER("grid", nil);
					if(!surfaceIsWater _position) then {
						_sector = ["new", [_key, _position, MEMBER("grid", nil)]] call OO_SECTOR;
						"Draw" call _sector;
						["Put", [str(_key), _sector]] call MEMBER("zone_hashmap",nil);
					};
				};
				MEMBER("queuesector", nil) set [0, objnull]; 
				_queue = MEMBER("queuesector", nil) - [objnull];
				MEMBER("queuesector", _queue);
			};
		};

		PUBLIC FUNCTION("object", "getPlayerSector") {
			private ["_sector"];
			_sector = ["getSectorFromPos", position _this] call MEMBER("grid", nil);
			_sector;
		};

		PUBLIC FUNCTION("object", "getPlayerSaveSector") {
			private ["_sector"];
			_sector = ["Get", [name _this]] call MEMBER("player_hashmap",nil);
			_sector;
		};
	
		PUBLIC FUNCTION("object", "getPlayerNewSector") {
			private ["_sector", "_oldsector"];
			_sector = MEMBER("getPlayerSector", _this);
			_oldsector = MEMBER("getPlayerSaveSector", _this);
			if(str(_sector) == str(_oldsector)) then { [];} else {_sector;};
		};

		PUBLIC FUNCTION("array", "setPlayerSaveSector") {
			private ["_player", "_sector"];
			_player = _this select 0;
			_sector = _this select 1;
			if(["containsKey", [name _player]] call MEMBER("player_hashmap",nil)) then {
				["Set", [name _player, _sector]] call MEMBER("player_hashmap",nil);
			} else {
				["Put", [name _player, _sector]] call MEMBER("player_hashmap",nil);
			};
		};

		PUBLIC FUNCTION("", "spawnSector") {
			private ["_sector"];
			{
				_sector = ["get", str(_x)] call MEMBER("zone_hashmap",nil);
				if!(isnil "_sector") then {
					if("getState" call _sector == 0) then { 
						"Spawn" spawn _sector;
					};
				};
				0.001;
			}foreach MEMBER("getNewSectorAround", nil);
		};

		PUBLIC FUNCTION("", "spawnConvoy") {
			private ["_key", "_position", "_end", "_endposition", "_startposition", "_sector"];

			_sector = ("entrySet" call MEMBER("zone_hashmap",nil)) call BIS_fnc_selectRandom;
			_startposition = ["getPosFromSector", "getSector" call _sector] call MEMBER("grid",nil);
	
			_convoy = ["new", _startposition] call OO_CONVOY;
			"startConvoy" spawn _convoy;
		};

		PUBLIC FUNCTION("", "checkVictory") {
			private ["_victory"];
			_victory = true;
			{
				scopename "oo_check_victory";
				if("getState" call _x < 2) then { 
					_victory = false;
					breakout "oo_check_victory";
				};
				sleep 0.0001;
			}foreach ("entrySet" call MEMBER("zone_hashmap",nil));
			_victory;
		};

		PUBLIC FUNCTION("", "startConvoy") {
			while { true } do {
				MEMBER("spawnConvoy", nil);
				sleep 300;
			};
		};

		PUBLIC FUNCTION("", "startZone") {
			private ["_sector"];
			while { true } do {
				MEMBER("setGroundPlayers", nil);
				MEMBER("spawnSector", nil);
				sleep 0.001;
			};
		};

		PUBLIC FUNCTION("","deconstructor") { 
			DELETE_VARIABLE("queuesector");
			DELETE_VARIABLE("groundplayers");
			DELETE_VARIABLE("airplayers");
			DELETE_VARIABLE("grid");
			DELETE_VARIABLE("zone_hashmap");
			DELETE_VARIABLE("player_hashmap");
		};
	ENDCLASS;