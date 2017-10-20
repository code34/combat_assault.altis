	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014-2017 Nicolas BOITEUX

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
		PRIVATE VARIABLE("code","zone_hashmap");
		PRIVATE VARIABLE("code","player_hashmap");

		PUBLIC FUNCTION("array","constructor") {
			MEMBER("setPlayers", nil);

			MEMBER("zone_hashmap", global_zone_hashmap);

			_hashmap = ["new", []] call OO_HASHMAP;
			MEMBER("player_hashmap", _hashmap);

			_array = [];
			MEMBER("queuesector", _array);
		};

		PUBLIC FUNCTION("","getAirPlayers") FUNC_GETVAR("airplayers");
		PUBLIC FUNCTION("","getGroundPlayers") FUNC_GETVAR("groundplayers");

		PUBLIC FUNCTION("", "getPlayers") {
			(allPlayers - (entities "HeadlessClient_F"));
		};

		PUBLIC FUNCTION("string", "getPlayersOfType") {
			private ["_array"];
			_array = [];
			{
				if(typeof _x == _this) then {
					_array = _array + [_x];
				};
				sleep 0.0000001;
			}foreach playableUnits;
			_array;
		};

		PUBLIC FUNCTION("", "setPlayers") {
			private ["_groundplayers", "_airplayers"];

			_groundplayers = [];
			_airplayers = [];

			// tous les joueurs en dessous de 250m alt sont considérés comme au sol
			{
				if((getpos _x) select 2 < 250) then {
					_groundplayers = _groundplayers + [_x];
				} else {
					_airplayers = _airplayers + [_x];
				};
				sleep 0.0000001;
			} foreach playableunits;
			
			MEMBER("airplayers", _airplayers);
			MEMBER("groundplayers", _groundplayers);
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
				sleep 0.0000001;
			}foreach MEMBER("groundplayers", nil);
			_newsector;
		};

		PUBLIC FUNCTION("", "getNewSectorAround") {
			private ["_array", "_around", "_temp"];
			_around = [];
			_array = MEMBER("getNewSector", nil);		
			{
				_temp = ["getAllSectorsAroundSector", [_x, wcpopsquaredistance]] call global_grid;
				_around = _around + _temp;
				sleep 0.0000001;
			}foreach _array; 
			_around;
		};


		PUBLIC FUNCTION("array", "expandSector"){
			private ["_queue"];
			_queue = MEMBER("queuesector", nil) + [_this];
			MEMBER("queuesector", _queue);
		};

		PUBLIC FUNCTION("array", "getNumberNeighour"){
			private ["_cross", "_key", "_neighbour"];

			_key = _this;
			
			_cross = ["getSectorsCrossAroundSector", _key] call global_grid;
			_neighbour = 1;
			{
				_sector = ["get", str(_x)] call MEMBER("zone_hashmap",nil);
				if!(isnil "_sector") then {
					if("getState" call _sector < 2) then {
						_neighbour = _neighbour + 1;
					};
				};
				sleep 0.0000001;
			} foreach _cross;
			_neighbour;
		};

		PUBLIC FUNCTION("array", "canExpandToNeighbour"){	
			private ["_can", "_cross", "_key", "_boundaries", "_neighbour"];

			_key = _this;
			_can = true;
			_boundaries = MEMBER("getNumberNeighour", _key);
			if(_boundaries < 4) then {
				_cross = ["getSectorsCrossAroundSector", _key] call global_grid;
				{
					_boundaries = MEMBER("getNumberNeighour", _x);
					if(_boundaries > 3) then {_can = false;};
					sleep 0.0000001;
				}foreach _cross;
			} else {
				_can = false;
			};
			_can;
		};

		PUBLIC FUNCTION("array", "canExpandToNeighbour2"){
			private ["_count", "_key", "_around", "_temp"];
			_key = _this;
			_count = 1;
			_around = ["getSectorsCrossAroundSector", _key] call global_grid;
			{
				_temp = ["get", str(_x)] call MEMBER("zone_hashmap",nil);
				if!(isnil "_temp") then {
					_count = _count + 1;
				};
			}foreach _around;
			if(_count > 2) then {false;}else{true;};
		};

		PUBLIC FUNCTION("array", "isplayerAroundSector"){
			private ["_sector", "_cost", "_costmin"];

			_sector = _this;
			_costmin = 10;
			
			{
				_sector = ["getSectorFromPos", position _x] call global_grid;
				_cost = ["GetEstimateCost", [_sector, _key]] call global_grid;
				if(_cost < _costmin) then {_costmin = _cost;};
				sleep 0.0000001;
			}foreach MEMBER("groundplayers", nil);
			if(_costmin < 10) then {false;}else{true;};
		};

		PUBLIC FUNCTION("", "getSectorFarOfPlayers"){
			private ["_sector"];
			_sector = ("entrySet" call MEMBER("zone_hashmap",nil)) call BIS_fnc_selectRandom;
			if( !MEMBER("isplayerAroundSector", _sector))  then {
				sleep 10;
				_sector = MEMBER("getSectorFarOfPlayers", nil);
			};
			_sector;
		};

		PUBLIC FUNCTION("array", "canExpandToSector"){
			private ["_key", "_sector", "_cost", "_costmin", "_neighbour", "_return"];

			_key = _this;
			_costmin = 4;
			{
				_sector = ["getSectorFromPos", position _x] call global_grid;
				_cost = ["GetEstimateCost", [_sector, _key]] call global_grid;
				if(_cost < _costmin) then {_costmin = _cost;};
				sleep 0.0000001;
			}foreach MEMBER("groundplayers", nil);
			
			if(_costmin >3) then {
				if(MEMBER("canExpandToNeighbour2", _key)) then {
					_return = true;
				}else{
					_return = false;
				};
			} else {
				_return = false;
			};
			_return;
		};

		PUBLIC FUNCTION("array", "expandSectorAround"){
			private ["_around", "_sector", "_iteration", "_rate", "_x"];

			_sector = _this select 0;
			_iteration = _this select 1;
			_rate = (90 - (_this select 1)) / 100;
			if(_rate < 0) then {_rate = 0;};

			_around = ["getAllSectorsAroundSector", [_sector,3]] call global_grid;

			while { count _around > 0 } do {
				_x = _around call BIS_fnc_selectRandom;
				_around = _around - [_x];
				_rate = ["GetEstimateCost", [_x, _sector]] call global_grid;
				_rate = (_rate / 10) + 0.5;
				if((random 1 > _rate) and (_iteration > 0)) then {
					MEMBER("expandSector", _x);
					_iteration = _iteration - 1;					
				};
				sleep 0.0001;
			};
		};

		PUBLIC FUNCTION("array", "expandFriendlyAround"){
			private ["_sector", "_around", "_position"];
			_position = _this;
			_sector = ["getSectorFromPos", _position] call global_grid;

			_around = ["getAllSectorsAroundSector", [_sector,2]] call global_grid;

			{
				_sector = ["get", str(_x)] call MEMBER("zone_hashmap",nil);
				if(isnil "_sector") then {
					if(random 1 > 0.95) then {
						_position = ["getPosFromSector", _x] call global_grid;
						_sector = ["new", [str(_x), _position, global_grid]] call OO_SECTOR;
						"draw" call _sector;
						"setVictory" call _sector;
						["put", [str(_x), _sector]] call MEMBER("zone_hashmap",nil);
					};
				};
				sleep 0.0000001;
			}foreach _around;
		};		

		PUBLIC FUNCTION("code", "expandAlertAround"){
			private ["_sector", "_around"];
			
			_sector = _this;
			["setAlert", true] call _this;
			_sector = "getSector" call _this;

			_around = ["getAllSectorsAroundSector", [_sector,3]] call global_grid;

			{
				_sector = ["get", str(_x)] call MEMBER("zone_hashmap",nil);
				if!(isnil "_sector") then {
					if(("getState" call _sector) < 2) then {
						["setAlert", true] call _sector;
					};
				};
				sleep 0.0000001;
			}foreach _around;
		};

		PUBLIC FUNCTION("array", "deleteSector"){
			private ["_key", "_sector"];
			_key = _this;
			_sector = ["get", str(_key)] call MEMBER("zone_hashmap",nil);
			["remove", str(_key)] call MEMBER("zone_hashmap",nil);
			["delete", _sector] call OO_SECTOR;
		};

		PUBLIC FUNCTION("", "queueSector"){
			private ["_queue", "_key", "_position", "_sector", "_counter"];
			_counter = 0;
			while { true } do {
				waituntil { count MEMBER("queuesector", nil) > 0 };
				_key = MEMBER("queuesector", nil) select 0;
				_sector = ["get", str(_key)] call MEMBER("zone_hashmap",nil);
				if(isnil "_sector") then {
					_position = ["getPosFromSector", _key] call global_grid;
					//if((getmarkerpos "respawn_west" distance _position > 1300)) then {
						if(!surfaceIsWater _position) then {
							if(MEMBER("canExpandToSector", _key)) then {
								_sector = ["new", [_key, _position, global_grid]] call OO_SECTOR;
								"draw" call _sector;
								["put", [str(_key), _sector]] call MEMBER("zone_hashmap",nil);
								_counter = _counter + 1;
							};
						};
					//};
				};
				MEMBER("queuesector", nil) set [0, objnull]; 
				_queue = MEMBER("queuesector", nil) - [objnull];
				MEMBER("queuesector", _queue);
			};
		};

		PUBLIC FUNCTION("object", "getPlayerSector") {
			private ["_sector"];
			_sector = ["getSectorFromPos", position _this] call global_grid;
			_sector;
		};

		PUBLIC FUNCTION("object", "getPlayerSaveSector") {
			private ["_sector"];
			_sector = ["get", (name _this)] call MEMBER("player_hashmap",nil);
			if(isnil "_sector") then {_sector = [];};
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
			["put", [(name _player), _sector]] call MEMBER("player_hashmap",nil);
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
				sleep 0.0000001;
			}foreach MEMBER("getNewSectorAround", nil);
		};

		PUBLIC FUNCTION("", "startConvoy") {
			if(wcconvoytime > 0) then {
				while { true } do {
					if(count MEMBER("getPlayers", nil) > 0) then {
						MEMBER("spawnConvoy", nil);
					};
					sleep wcconvoytime;
				};
			};
		};		

		PUBLIC FUNCTION("", "spawnConvoy") {
			private ["_key", "_position", "_end", "_endposition", "_startposition", "_sector"];
			
			_sector = MEMBER("getSectorFarOfPlayers", nil);
			_startposition = ["getPosFromSector", "getSector" call _sector] call global_grid;
	
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
				sleep 0.0000001;
			}foreach ("entrySet" call MEMBER("zone_hashmap",nil));
			_victory;
		};

		PUBLIC FUNCTION("", "startZone") {
			private ["_sector"];
			while { true } do {
				MEMBER("setPlayers", nil);
				MEMBER("spawnSector", nil);
				sleep 0.0000001;
			};
		};
		
		PUBLIC FUNCTION("", "startParaDrop") {
			while { true } do {
				{
					if(random 1 > 0.95) then { "popParachute" call _x; };
					sleep 0.1;
				} foreach ("entrySet" call MEMBER("zone_hashmap",nil));
				sleep 60;
			};
		};

		PUBLIC FUNCTION("","deconstructor") { 
			DELETE_VARIABLE("queuesector");
			DELETE_VARIABLE("groundplayers");
			DELETE_VARIABLE("airplayers");
			DELETE_VARIABLE("zone_hashmap");
			DELETE_VARIABLE("player_hashmap");
		};
	ENDCLASS;