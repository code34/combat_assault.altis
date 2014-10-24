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

	BME_netcode_server_wcdeath = {
		private ["_array", "_name", "_player", "_ratio", "_score", "_death", "_playertype", "_uid", "_killer", "_points"];

		_array = _this select 0;
		_name = _array select 0;
		_playertype = _array select 1;
		_killer = _array select 2;
	
		["setTicket", _playertype] call global_ticket;

		{	
			if(_name == name _x) then {
				_uid = getPlayerUID _x;
				_points = score _x;	
			};
			sleep 0.0001;
		}forEach (allDead + playableUnits);

		_score = ["get", _uid] call global_scores;
		if(isnil "_score") then {
			_score = ["new", [_uid]] call OO_SCORE;
			["Put", [_name, _score]] call global_scores;
		};

		"addDeath" call _score;
		["setScore", _points] call _score;
		_ratio = "getRatio" call _score;

		playerstats = [_name, _ratio];
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

	BME_netcode_server_wcteleporttank = {
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

		_around = ["getSectorAllAround", [_sector, 3]] call _grid;
		{
			_sector = ["Get", str(_x)] call global_zone_hashmap;
			if(!isnil "_sector") then {
				if("getState" call _sector < 2) then {
					_result = [0,0];
				};
			};
			sleep 0.0001;
		}foreach _around;
		wcteleportack = _result;
		["wcteleportack", "client", _playerid] call BME_fnc_publicvariable;
	};

	BME_netcode_server_wcteleportchopper = {
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

		_around = ["getSectorAllAround", [_sector, 3]] call _grid;
		{
			_sector = ["Get", str(_x)] call global_zone_hashmap;
			if(!isnil "_sector") then {
				if("getState" call _sector < 2) then {
					_result = [0,0];
				};
			};
			sleep 0.0001;
		}foreach _around;
		wcteleportack = _result;
		["wcteleportack", "client", _playerid] call BME_fnc_publicvariable;
	};	

	// return true when read
	true;