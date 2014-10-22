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
		BME_netcode_nameofyourvariable = { code to execute on client side };
	*/

	// Example function hint message on client side
	BME_netcode_bme_message = {
		bme_message = _this select 0;
		hint bme_message;
	};

	BME_netcode_wcdeath = {
		private ["_player", "_killer", "_message"];
		_array = _this select 0;
		_player = _array select 0;
		_killer = _array select 2;

		if!(_killer == "") then {
			_message = "<t align='center'><t color='#FF9933'>"+_player + "</t> was killed by <t color='#FF9933'>"+_killer+"</t></t>";
		} else {
			_message = "<t align='center'><t color='#FF9933'>"+_player + "</t> was killed</t>";
		};
		killzone = killzone + [_message];
	};

	BME_netcode_wcticket = {
		private ["_value", "_type", "_ticket", "_credit"];
		_value = _this select 0;
		_ticket = _value select 0;
		_type = _value select 1;
		_credit = _value select 2;

		_index = round ((random 30) + 87);
		_entry = configFile >> "CfgMusic";
		_track = configName(_entry select _index);
		playMusic _track;
		["hintScore", [_ticket, _type, _credit]] call hud;
	};

	BME_netcode_wcteleportack = {
		_position = _this select 0;
		switch (format["%1", _position]) do {
			case "[0,0]": {
				_title = "Too near of enemy position";
				_text = "Choose a square far of enemy positions";
				["hint", [_title, _text]] call hud;
			};
			case "[0,1]": {
				_title = "Too near of base";
				_text = "Choose a square far of base";
				["hint", [_title, _text]] call hud;
			};
			case "[0,2]": {
				_title = "Too near of water";
				_text = "Choose a square far of water";
				["hint", [_title, _text]] call hud;
			};			
			default {
				wcteleportposition = _position;
			};
		};
	};

	BME_netcode_zonesuccess = {
		//playsound "zonesuccess";
	};

	BME_netcode_playerstats = {
		private ["_player", "_stats", "_done", "_value"];

		_player = (_this select 0) select 0;
		_stats = (_this select 0) select 1;
		_done = false;

		if(_player == name player) then {
			mystats = _stats;
		};		
		
		{
			if(_player == _x select 0) then {
				_value = [_player, _stats];
				localplayerstats set [_foreachindex, _value];
				_done = true;
			};
			sleep 0.01;
		}foreach localplayerstats;

		if!(_done) then {
			_value = [_player, _stats];
			localplayerstats = localplayerstats + [_value];
		};
		diag_log format ["%1", localplayerstats];
	};

	BME_netcode_end = {
		_end = _this select 0;
		if(_end == "win") then {
			["end1",false,2] call BIS_fnc_endMission;
		} else {
			["epicFail",false,2] call BIS_fnc_endMission;
		};
	};

	// return true when read
	true;