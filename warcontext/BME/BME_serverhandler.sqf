	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2013 Nicolas BOITEUX

	Bus Message Exchange (BME)
	
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

	Usage: 
		BME_netcode_server_nameofyourvariable = { code to execute on server side };
	*/

	// Example function write log on server side
	BME_netcode_server_bme_log = {
		bme_log = _this select 0;
		diag_log format["BME: %1", bme_log];
	};

	BME_netcode_server_playervehicle = {
		private ["_alive", "_array", "_vehicle", "_name", "_position", "_netid", "_type", "_object"];
		
		_array = _this select 0;
		_name = _array select 0;
		_position = _array select 1;
		_type = _array select 2;

		{	
			if(_name == name _x) then {
				_netid = owner _x;	
			};
			sleep 0.0001;
		}forEach playableunits;

		_vehicle = ["get", _name] call global_vehicles;
		if(isnil "_vehicle") then {
			_vehicle = ["new", _type] call OO_PLAYERVEHICLE;
			["put", [_name, _vehicle]] call global_vehicles;
		} else {
			["setType", _type] call _vehicle;
		};

		_alive = "getAlive" call _vehicle;
		
		if(_alive > 0) then {
			"sanity" call _vehicle;
			vehicleavalaible = _alive;
			["vehicleavalaible", "client", _netid] call BME_fnc_publicvariable;
		} else {
			_object = ["pop", [_position, _netid, _name]] call _vehicle;
			"checkAlive" spawn _vehicle;
		};
	};		

	BME_netcode_server_wcdeath = {
		private ["_score", "_uid", "_killer", "_victim"];

		_victim = (_this select 0) select 0;
		_killer = (_this select 0) select 1;

		if((isplayer _killer) && !(_victim isEqualTo _killer)) then {
			_uid = getPlayerUID _killer;

			_score = ["get", _uid] call global_scores;
			if(isnil "_score") then {
				_score = ["new", [_uid]] call OO_SCORE;
				["put", [_uid, _score]] call global_scores;
			};
			"killPlayer" call _score;
			"addKill" call _score;
			["publicScore", _killer] call _score;
		};

		if (isplayer _victim) then {
			_uid = getPlayerUID _victim;
			_score = ["get", _uid] call global_scores;

			if(isnil "_score") then {
				_score = ["new", [_uid]] call OO_SCORE;
				["put", [_uid, _score]] call global_scores;
			};
			"addDeath" call _score;
			["publicScore", _victim] call _score;
		};
	};		

	BME_netcode_server_wcteleport = {
		private ["_playername", "_playerid", "_position", "_sector", "_result", "_around", "_side", "_list", "_pos"];

		_playername = (_this select 0) select 0;
		_position = (_this select 0) select 1;
		_position =  _position findEmptyPosition [0,20];
		if(_position isEqualTo []) then {(_this select 0) select 1;};

		_side = west;

		{
			if (name _x == _playername) then { _playerid = owner _x; _side = side _x;};
			sleep 0.0001;
		}foreach playableUnits;

		// si trop pret de la base - teleport impossible
		//if(_position distance (getmarkerpos "respawn_west") < 600) exitwith {
		//	wcteleportack = [2, _position];
		//	["wcteleportack", "client", _playerid] call BME_fnc_publicvariable;
		//};

		// si dans l'eau - teleport impossible
		if(surfaceIsWater _position) exitwith {
			wcteleportack = [3, _position];
			["wcteleportack", "client", _playerid] call BME_fnc_publicvariable;
		};

		_sector = ["getSectorFromPos", _position] call global_grid;
		_pos = ["getPosFromSector", _sector] call global_grid;

		_list = _pos nearEntities [["Man"], 100];
		sleep 0.5;
		if(east countSide _list > 0) exitwith { wcteleportack = [1, _position]; ["wcteleportack", "client", _playerid] call BME_fnc_publicvariable; };

		_result = [0, _position];
		_around = ["getAllSectorsAroundSector", [_sector, 1]] call global_grid;
		{
			_sector = ["Get", str(_x)] call global_zone_hashmap;
			if(!isnil "_sector") then {
				if("getState" call _sector < 2) then {
					_result = [1, _position];
				};
			};
		}foreach _around;

		wcteleportack = _result;
		["wcteleportack", "client", _playerid] call BME_fnc_publicvariable;
	};


	// return true when read
	true;