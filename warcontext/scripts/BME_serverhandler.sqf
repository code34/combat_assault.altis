	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2013-2018 Nicolas BOITEUX

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

	BME_netcode_server_wcunpackbase = {
		"unpackBase" call global_base;
	};

	BME_netcode_server_wcpackbase = {
		"packBase" call global_base;
	};

	BME_netcode_server_getairports = {
		["remoteSpawn", ["wcairports", "getAirports" call global_atc, "client"]] call global_bme;
	};

	BME_netcode_server_getfactorys = {
		["remoteSpawn", ["wcfactorys", "getFactorys" call global_factory, "client"]] call global_bme;
	};

	BME_netcode_server_gettickets = {
		"send" call global_ticket;
	};

	BME_netcode_server_bme_log = {
		bme_log = _this;
		diag_log format["BME: %1", bme_log];
	};

	BME_netcode_server_playervehicle = {
		private ["_alive", "_array", "_vehicle", "_name", "_position", "_netid", "_type", "_object"];
		
		_array = _this;
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
			["remoteSpawn", ["vehicleavalaible", _alive, "client", _netid]] call global_bme;
		} else {
			_object = ["pop", [_position, _netid, _name]] call _vehicle;
			"checkAlive" spawn _vehicle;
		};
	};		

	BME_netcode_server_wcdeath = {
		private ["_score", "_uid", "_killer", "_victim"];

		_victim = _this select 0;
		_killer = _this select 1;

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

	// return true when read
	true;