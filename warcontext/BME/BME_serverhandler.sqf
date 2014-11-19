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
		private ["_array", "_vehicle", "_name", "_position", "_netid", "_type"];
		
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

		switch (_type) do {
			case "chopper" : {
				_type = "B_Heli_Transport_01_camo_F";
			};

			case "tank" : {
				_type = "B_MBT_01_cannon_F";
			};

			case "tankaa" : {
				_type = "B_APC_Tracked_01_AA_F";
			};

			default {
				_type = "B_MBT_01_cannon_F";
			};
		};

		_vehicle = ["get", _name] call global_vehicles;
		if(isnil "_vehicle") then {
			_vehicle = ["new", [_type]] call OO_PLAYERVEHICLE;
			["put", [_name, _vehicle]] call global_vehicles;
		} else {
			["setType", _type] call _vehicle;
		};
		_vehicle = ["pop", [_position, _netid, _name]] spawn _vehicle;
	};		

	BME_netcode_server_wcdeath = {
		private ["_array", "_name", "_player", "_ratio", "_score", "_death", "_playertype", "_uid", "_killer", "_points", "_netid", "_rank", "_gamescore"];

		_array = _this select 0;
		_name = _array select 0;
		_playertype = _array select 1;
		_killer = _array select 2;
	
		wcdeathlistner = _array;
		["wcdeathlistner", "client"] call BME_fnc_publicvariable;

		["setTicket", _playertype] call global_ticket;

		_netid = -1;
		{	
			if(_name == name _x) then {
				_uid = getPlayerUID _x;
				_points = score _x;
				_netid = owner _x;	
				_player = _x;
			};
			sleep 0.0001;
		}forEach (allDead + playableUnits);
		if(_netid == -1) exitwith {};

		_score = ["get", _uid] call global_scores;
		if(isnil "_score") then {
			_score = ["new", [_uid]] call OO_SCORE;
			["put", [_uid, _score]] call global_scores;
		};

		"addDeath" call _score;
		["setKill", _points] call _score;
		//_ratio = "getRatio" call _score;
		_ratio = "getGameRatio" call _score;
		_number = "getNumber" call _score;
		_globalratio = "getGlobalRatio" call _score;
		_gamescore = "getScore" call _score;

		_rank = ["getRank", _globalratio] call _score;
		_player setrank _rank;

		playerstats = [_name, [_ratio, _globalratio, _number, _gamescore]];
		["playerstats", "client"] call BME_fnc_publicvariable;
	};		

	BME_netcode_server_wcteleport = {
		private ["_name", "_playerid", "_position", "_grid", "_sector", "_result", "_around"];

		_wcteleport = _this select 0;
		_name = _wcteleport select 0;

		{
			if (name _x == _name) then {
				_playerid = owner _x;
			};
			sleep 0.0001;
		}foreach playableUnits;

		_position = _wcteleport select 1;
		if(_position distance (getmarkerpos "respawn_west") < 600) exitwith {
			wcteleportack = [0,1];
			["wcteleportack", "client", _playerid] call BME_fnc_publicvariable;
		};
		if(surfaceIsWater _position) exitwith {
			wcteleportack = [0,2];
			["wcteleportack", "client", _playerid] call BME_fnc_publicvariable;
		};

		_grid = ["new", [31000,31000,100,100]] call OO_GRID;
		_sector = ["getSectorFromPos", _position] call _grid;

		_pos = ["getPosFromSector", _sector] call _grid;
		_list = _pos nearEntities [["Man"], 50];
		if(east countSide _list > 0) exitwith {
			wcteleportack = [0,0];
			["wcteleportack", "client", _playerid] call BME_fnc_publicvariable;
		};

		_result = _position;

		_around = ["getSectorAround", _sector] call _grid;
		{
			_sector = ["Get", str(_x)] call global_zone_hashmap;
			if(!isnil "_sector") then {
				if("getState" call _sector < 2) then {
					_result = [0,0];
				};
			};
		}foreach _around;

		wcteleportack = _result;
		["wcteleportack", "client", _playerid] call BME_fnc_publicvariable;
	};


	// return true when read
	true;