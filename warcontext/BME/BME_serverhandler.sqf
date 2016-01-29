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
		private ["_alive", "_array", "_vehicle", "_name", "_position", "_netid", "_type", "_object", "_para"];
		
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
				_para = false;
			};

			case "achopper" : {
				_type = "B_Heli_Attack_01_F";
				_para = false;
			};

			case "bomber" : {
				_type = "B_Plane_CAS_01_F";
				_para = false;
			};

			case "fighter" : {
				_type = "I_Plane_Fighter_03_AA_F";
				_para = false;
			};			

			case "tank" : {
				_type = "B_MBT_01_cannon_F";
				_para = true;
			};

			case "tankaa" : {
				_type = "B_APC_Tracked_01_AA_F";
				_para = true;
			};

			case "ammobox" : {
				_type = "B_supplyCrate_F";
				_para = true;
			};

			default {
				_type = "B_MBT_01_cannon_F";
				_para = true;
			};
		};

		_vehicle = ["get", _name] call global_vehicles;
		if(isnil "_vehicle") then {
			_vehicle = ["new", [_type, _para]] call OO_PLAYERVEHICLE;
			["put", [_name, _vehicle]] call global_vehicles;
		} else {
			["setType", _type] call _vehicle;
			["setPara", _para] call _vehicle;
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
		private ["_array", "_name", "_player", "_gameranking", "_serverranking","_score", "_death", "_playertype", "_uid", "_killer", "_points", "_netid", "_rank", "_gamescore", "_matches"];

		_array = _this select 0;
		_name = _array select 0;
		_playertype = _array select 1;
		_killer = _array select 2;
	
		wcdeathlistner = _array;
		["wcdeathlistner", "client"] call BME_fnc_publicvariable;

		if(_playertype == "ammobox") then {_playertype = "soldier";};
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

		_gameranking = "getGameRanking" call _score;
		_serverranking = "getServerRanking" call _score;
		
		_matches = "getMatches" call _score;
		_gamescore = "getScore" call _score;

		_rank = ["getRank", _gameranking] call _score;
		_player setrank _rank;

		_kill = "getKill" call _score;
		_death = "getDeath" call _score;

		playerstats = [_name, [_gameranking, _serverranking, _matches, _gamescore, _kill, _death]];
		["playerstats", "client"] call BME_fnc_publicvariable;
	};		

	BME_netcode_server_wcteleport = {
		private ["_name", "_playerid", "_position", "_sector", "_result", "_around"];

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

		_sector = ["getSectorFromPos", _position] call global_grid;
		_pos = ["getPosFromSector", _sector] call global_grid;

		_list = _pos nearEntities [["Man"], 100];
		if(east countSide _list > 0) exitwith {
			wcteleportack = [0,0];
			["wcteleportack", "client", _playerid] call BME_fnc_publicvariable;
		};

		_result = _position;

		_around = ["getSectorAllAround", [_sector, 3]] call global_grid;
		//_around = ["getSectorAround", _sector] call global_grid;
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