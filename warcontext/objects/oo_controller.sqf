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
		PRIVATE VARIABLE("hashmap","zone_hashmap");
		PRIVATE VARIABLE("code","player_hashmap");

		PUBLIC FUNCTION("array","constructor") {
			DEBUG(#, "OO_CONTROLLER::constructor")
			MEMBER("groundplayers", []);
			MEMBER("airplayers", []);
			MEMBER("queuesector", []);
			MEMBER("setPlayers", nil);
			MEMBER("zone_hashmap", global_zone_hashmap);
			private _hashmap = ["new", []] call OO_HASHMAP;
			MEMBER("player_hashmap", _hashmap);
		};

		PUBLIC FUNCTION("","getAirPlayers") FUNC_GETVAR("airplayers");
		PUBLIC FUNCTION("","getGroundPlayers") FUNC_GETVAR("groundplayers");

		PUBLIC FUNCTION("", "getPlayers") {
			DEBUG(#, "OO_CONTROLLER::getPlayers")
			(allPlayers - (entities "HeadlessClient_F"));
		};

		PUBLIC FUNCTION("string", "getPlayersOfType") {
			DEBUG(#, "OO_CONTROLLER::getPlayersOfType")
			private _array = [];
			{
				if(typeOf _x == _this) then { _array pushBack _x; };
				sleep 0.0000001;
			}foreach playableUnits;
			_array;
		};

		PUBLIC FUNCTION("", "setPlayers") {
			DEBUG(#, "OO_CONTROLLER::setPlayers")
			{
				if((getpos _x) select 2 < 250) then {
					MEMBER("groundplayers", nil) pushBack _x;
				} else {
					MEMBER("airplayers", nil) pushBack _x;
				};
				sleep 0.0000001;
			} foreach playableunits;
		};

		PUBLIC FUNCTION("", "getNewSector") {
			DEBUG(#, "OO_CONTROLLER::getNewSector")
			private _newsector = [];
			private _sector = [];
			private _array = [];
			{
				_sector = MEMBER("getPlayerNewSector", _x);
				if(count _sector > 0) then {
					_array = [_x, _sector];
					MEMBER("setPlayerSaveSector", _array);
					_newsector pushBack _sector;
				};
				sleep 0.0000001;
			}foreach MEMBER("groundplayers", nil);
			_newsector;
		};

		PUBLIC FUNCTION("", "getNewSectorAround") {
			DEBUG(#, "OO_CONTROLLER::getNewSectorAround")
			private _around = [];
			{
				_around append (["getAllSectorsAroundSector", [_x, wcpopsquaredistance]] call global_grid);
				sleep 0.0000001;
			}foreach MEMBER("getNewSector", nil); 
			_around;
		};


		PUBLIC FUNCTION("array", "expandSector"){
			DEBUG(#, "OO_CONTROLLER::expandSector")
			MEMBER("queuesector", nil) pushBack _this;
		};

		PUBLIC FUNCTION("array", "getNumberNeighour"){
			DEBUG(#, "OO_CONTROLLER::getNumberNeighour")
			private _key = _this;
			private _neighbour = 1;
			private _sector = [];

			{
				_sector = MEMBER("zone_hashmap",nil) get str(_x);
				if!(isnil "_sector") then {
					if("getState" call _sector < 2) then {
						_neighbour = _neighbour + 1;
					};
				};
				sleep 0.0000001;
			} foreach (["getSectorsCrossAroundSector", _key] call global_grid);
			_neighbour;
		};

		PUBLIC FUNCTION("array", "canExpandToNeighbour"){
			DEBUG(#, "OO_CONTROLLER::canExpandToNeighbour")
			private _key = _this;
			private _can = true;
			private _boundaries = MEMBER("getNumberNeighour", _key);

			if(_boundaries < 4) then {
				{
					_boundaries = MEMBER("getNumberNeighour", _x);
					if(_boundaries > 3) then {_can = false;};
					sleep 0.0000001;
				}foreach (["getSectorsCrossAroundSector", _key] call global_grid);
			} else {
				_can = false;
			};
			_can;
		};

		PUBLIC FUNCTION("array", "canExpandToNeighbour2"){
			DEBUG(#, "OO_CONTROLLER::canExpandToNeighbour2")
			private _count = 1;
			private _sector = [];
			{
				_sector = MEMBER("zone_hashmap",nil) get str(_x);
				if!(isnil "_sector") then { _count = _count + 1; };
			}foreach (["getSectorsCrossAroundSector", _this] call global_grid);
			if(_count > 2) then {false;}else{true;};
		};

		PUBLIC FUNCTION("array", "isplayerAroundSector"){
			DEBUG(#, "OO_CONTROLLER::isplayerAroundSector")
			private _sector = [];
			private _cost = 0;	
			private _costmin = 10;
			private _key = _this;
			{
				_sector = ["getSectorFromPos", position _x] call global_grid;
				_cost = ["GetEstimateCost", [_sector, _key]] call global_grid;
				if(_cost < _costmin) then {_costmin = _cost;};
				sleep 0.0000001;
			}foreach MEMBER("groundplayers", nil);
			if(_costmin < 10) then {false;}else{true;};
		};

		PUBLIC FUNCTION("", "getSectorFarOfPlayers"){
			DEBUG(#, "OO_CONTROLLER::getSectorFarOfPlayers")
			private _key = selectRandom (keys MEMBER("zone_hashmap",nil));
			private _sector = MEMBER("zone_hashmap",nil) get _key;
			if( !MEMBER("isplayerAroundSector", "getSector" call _sector) ) then { _sector = MEMBER("getSectorFarOfPlayers", nil); };
			_sector;
		};

		PUBLIC FUNCTION("array", "canExpandToSector"){
			DEBUG(#, "OO_CONTROLLER::canExpandToSector")
			private _key = _this;
			private _costmin = 4;
			private _sector = [];
			private _cost = 0;
			private _return = false; 
			
			{
				_sector = ["getSectorFromPos", position _x] call global_grid;
				_cost = ["GetEstimateCost", [_sector, _key]] call global_grid;
				if(_cost < _costmin) then {_costmin = _cost;};
				sleep 0.0000001;
			}foreach MEMBER("groundplayers", nil);
			
			if(_costmin >3) then {
				if(MEMBER("canExpandToNeighbour2", _key)) then { _return = true; };
			};
			_return;
		};

		PUBLIC FUNCTION("array", "expandSectorAround"){
			DEBUG(#, "OO_CONTROLLER::expandSectorAround")
			private _sector = _this select 0;
			private _iteration = _this select 1;
			private _rate = (90 - (_this select 1)) / 100;
			private _around = ["getAllSectorsAroundSector", [_sector,3]] call global_grid;
			
			if(_rate < 0) then {_rate = 0;};
			while { count _around > 0 } do {
				_x = _around deleteAt (floor(random (count _around)));
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
			DEBUG(#, "OO_CONTROLLER::expandFriendlyAround")
			private _position = _this;
			private _sector = ["getSectorFromPos", _position] call global_grid;

			{
				_sector = MEMBER("zone_hashmap",nil) get str(_x);
				if(isnil "_sector") then {
					if(random 1 > 0.95) then {
						_position = ["getPosFromSector", _x] call global_grid;
						_sector = ["new", [str(_x), _position, global_grid]] call OO_SECTOR;
						"draw" call _sector;
						"setVictory" call _sector;
						MEMBER("zone_hashmap",nil) set [str(_x), _sector];
					};
				};
				sleep 0.0000001;
			}foreach (["getAllSectorsAroundSector", [_sector,2]] call global_grid);
		};		

		PUBLIC FUNCTION("code", "expandAlertAround"){
			DEBUG(#, "OO_CONTROLLER::expandAlertAround")
			["setAlert", true] call _this;
			private _sector = "getSector" call _this;
			{
				_sector = MEMBER("zone_hashmap",nil) get str(_x);
				if!(isnil "_sector") then {
					if(("getState" call _sector) < 2) then { ["setAlert", true] call _sector; };
				};
				sleep 0.0000001;
			}foreach (["getAllSectorsAroundSector", [_sector,3]] call global_grid);
		};

		PUBLIC FUNCTION("array", "deleteSector"){
			DEBUG(#, "OO_CONTROLLER::deleteSector")
			private _key = _this;
			private _sector = MEMBER("zone_hashmap",nil) get str(_key);
			MEMBER("zone_hashmap",nil) deleteAt str(_key);
			["delete", _sector] call OO_SECTOR;
		};

		PUBLIC FUNCTION("", "queueSector"){
			DEBUG(#, "OO_CONTROLLER::queueSector")
			private _key = [];
			private _position = [];
			private _sector = [];

			while { true } do {
				_key = MEMBER("queuesector", nil) deleteAt 0;
				if!(isNil "_key") then {
					_sector = MEMBER("zone_hashmap",nil) get str(_key);
					if(isnil "_sector") then {
						_position = ["getPosFromSector", _key] call global_grid;
						if(!surfaceIsWater _position) then {
							//if(MEMBER("canExpandToSector", _key)) then {
								_sector = ["new", [_key, _position, global_grid]] call OO_SECTOR;
								"draw" call _sector;
								MEMBER("zone_hashmap",nil) set [str(_key), _sector];
							//};
						};
					};
				};
			};
		};

		PUBLIC FUNCTION("object", "getPlayerSector") {
			DEBUG(#, "OO_CONTROLLER::getPlayerSector")
			["getSectorFromPos", position _this] call global_grid;
		};

		PUBLIC FUNCTION("object", "getPlayerSaveSector") {
			DEBUG(#, "OO_CONTROLLER::getPlayerSaveSector")
			private _sector = ["get", (name _this)] call MEMBER("player_hashmap",nil);
			if(isnil "_sector") then {_sector = [];};
			_sector;
		};
	
		PUBLIC FUNCTION("object", "getPlayerNewSector") {
			DEBUG(#, "OO_CONTROLLER::getPlayerNewSector")
			private _sector = MEMBER("getPlayerSector", _this);
			private _oldsector = MEMBER("getPlayerSaveSector", _this);
			if(str(_sector) == str(_oldsector)) then { [];} else {_sector;};
		};

		PUBLIC FUNCTION("array", "setPlayerSaveSector") {
			DEBUG(#, "OO_CONTROLLER::setPlayerSaveSector")
			["put", [(name (_this select 0)), (_this select 1)]] call MEMBER("player_hashmap",nil);
		};

		PUBLIC FUNCTION("", "spawnSector") {
			DEBUG(#, "OO_CONTROLLER::spawnSector")
			private _sector = [];
			{
				_sector = MEMBER("zone_hashmap",nil) get str(_x);
				if!(isnil "_sector") then {
					if("getState" call _sector == 0) then { "Spawn" spawn _sector; };
				};
				sleep 0.0000001;
			}foreach MEMBER("getNewSectorAround", nil);
		};

		PUBLIC FUNCTION("", "startConvoy") {
			DEBUG(#, "OO_CONTROLLER::startConvoy")
			if(wcconvoytime > 0) then {
				while { true } do {
					if(count MEMBER("getPlayers", nil) > 0) then { MEMBER("spawnConvoy", nil); };
					sleep wcconvoytime;
				};
			};
		};		

		PUBLIC FUNCTION("", "spawnConvoy") {
			DEBUG(#, "OO_CONTROLLER::spawnConvoy")
			private _sector = MEMBER("getSectorFarOfPlayers", nil);
			private _startposition = ["getPosFromSector", "getSector" call _sector] call global_grid;
			private _convoy = ["new", _startposition] call OO_CONVOY;
			"startConvoy" spawn _convoy;
		};

		PUBLIC FUNCTION("", "checkVictory") {
			DEBUG(#, "OO_CONTROLLER::checkVictory")
			private _victory = true;
			{
				scopename "oo_check_victory";
				private _sector = MEMBER("zone_hashmap",nil) get _x;
				if("getState" call _sector < 2) then { 
					_victory = false;
					breakout "oo_check_victory";
				};
				sleep 0.0000001;
			}foreach (keys MEMBER("zone_hashmap",nil));
			_victory;
		};

		PUBLIC FUNCTION("", "startZone") {
			DEBUG(#, "OO_CONTROLLER::startZone")
			while { true } do {
				MEMBER("setPlayers", nil);
				MEMBER("spawnSector", nil);
				sleep 0.0000001;
			};
		};
		
		PUBLIC FUNCTION("", "startParaDrop") {
			DEBUG(#, "OO_CONTROLLER::startParaDrop")
			while { true } do {
				{
					if(random 1 > 0.95) then { 
						private _sector = MEMBER("zone_hashmap",nil) get _x;
						"popParachute" call _sector;
					};
					sleep 0.1;
				}foreach (keys MEMBER("zone_hashmap",nil));
				sleep 60;
			};
		};

		PUBLIC FUNCTION("","deconstructor") {
			DEBUG(#, "OO_CONTROLLER::deconstructor")
			DELETE_VARIABLE("queuesector");
			DELETE_VARIABLE("groundplayers");
			DELETE_VARIABLE("airplayers");
			DELETE_VARIABLE("zone_hashmap");
			DELETE_VARIABLE("player_hashmap");
		};
	ENDCLASS;