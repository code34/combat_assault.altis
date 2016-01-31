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
	
	BME_netcode_vehicleavalaible = {
		private ["_alive"];
		_alive = _this select 0;
		["hint", ["Vehicle servicing", format ["Vehicle will be avalaible in %1 seconds", _alive]]] call hud;
	};

	BME_netcode_wcconvoystart = {
		private ["_message"];
		
		_message = "<t color='#FF9933'>"+ localize "STR_ENEMYCONVOY_TEXT" + "</t> " + localize "STR_SPOTTED_TEXT" + "<br/>";
		rollmessage = rollmessage + [_message];
		_message = "<t align='center'><t color='#FF9933'>"+ localize "STR_ENEMYCONVOY_TEXT" + "</t> " + localize "STR_SPOTTED_TEXT" + "</t>";
		killzone = killzone + [_message];
	};

	BME_netcode_wcaircraftstart = {
		private ["_message"];
	
		_message = "<t color='#FF9933'>An Enemy Aircraft</t> has been discovered<br/>";
		rollmessage = rollmessage + [_message];
		_message = "<t align='center'><t color='#FF9933'>An Enemy Aircraft</t> has been discovered</t>";
		killzone = killzone + [_message];
	};

	BME_netcode_wcartillerystart = {
		private ["_message"];
	
		_message = "<t color='#FF9933'>An Enemy Artillery</t> has been discovered<br/>";
		rollmessage = rollmessage + [_message];
		_message = "<t align='center'><t color='#FF9933'>An Enemy Artillery</t> has been discovered</t>";
		killzone = killzone + [_message];
	};

	BME_netcode_wcsectorcompleted = {
		private ["_sector", "_message"];
		_sector = _this select 0;
		
		_message = format ["<t color='#FF9933'>Sector %1%2</t> has been completed<br/>", _sector select 0, _sector select 1];
		rollmessage = rollmessage + [_message];
		_message = format["<t align='center'><t color='#FF9933'>Sector %1%2</t> has been completed</t>",_sector select 0, _sector select 1];
		killzone = killzone + [_message];
	};	

	BME_netcode_wcconvoy = {
		private ["_expand", "_message", "_message2"];
		
		_expand = _this select 0;
		if(_expand) then {
			_message = "<t color='#FF9933'>Enemy convoy</t> - expanding done<br/>";
			_message2 = "<t align='center'><t color='#FF9933'>Enemy convoy</t> - expanding done</t>";
		} else {
			_message = "<t color='#FF9933'>Enemy Convoy</t> - expanding failed<br/>";
			_message2 = "<t align='center'><t color='#FF9933'>Enemy Convoy</t> - expanding failed</t>";
		};
		rollmessage = rollmessage + [_message];
		killzone = killzone + [_message2];
	};

	BME_netcode_vehiclegetin = {
		private ["_vehicle"];
		_vehicle = _this select 0;
		player moveindriver _vehicle;
		waituntil {speed _vehicle > 60};
		_reload = ["new", _vehicle] call OO_RELOADPLANE;
		"start" spawn _reload;
	};

	BME_netcode_wcaideath = {
		private ["_unit", "_killer", "_message", "_weapon", "_displayname", "_playerkill", "_playerdeath"];
		
		_array = _this select 0;
		_unit = _array select 0;
		_killer = _array select 1;
		_weapon = _array select 2;
		_playerkill =_array select 3;
		_playerdeath = _array select 4;
		_displayname =  (getText (configfile >> "CfgWeapons" >> _weapon >> "displayName"));
		diag_log format ["%1", _array];

		if!(_killer == "") then {
			_message = "<t color='#FF9933'>"+_killer + "</t>  ["+_displayname+"] <t color='#FF9933'>"+_unit+"</t><br/>";
			if(_killer == name player) then {
				playerkill = _playerkill; 
				playerdeath = _playerdeath;
			};
		} else {
			_message = "<t color='#FF9933'>"+_unit + "</t> was killed<br/>";
		};
		rollmessage = rollmessage + [_message];		
	};

	BME_netcode_wcdeathlistner = {
		private ["_unit", "_killer", "_message", "_message2", "_displayname", "_weapon"];
		_array = _this select 0;
		_unit = _array select 0;
		_killer = _array select 2;
		_weapon = _array select 3;

		if!(_killer == "") then {
			if(_unit == _killer) then {
				_message = [
					"was killed by a flying melon", 
					"was killed like a jackass", 
					"was killed in total humiliation", 
					"was killed like a moron", 
					"was killed like a geek", 
					"was killed like an hero", 
					"was killed by masturbation", 
					"was killed jumping over his weapon", 
					"was killed by internal explosion", 
					"was killed by a dancing cow", 
					"was killed by a zombie", 
					"was killed by a brain dammage", 
					"was killed. WTF ????", 
					"was killed by a dubstep song", 
					"was killed by Altis life outage", 
					"was killed over feeding",  
					"was killed. Good lesson", 
					"was killed drinking again", 
					"was killed by his weapon",
					"was killed by a payable DLC",
					"was killed by a BIS jackass",
					"was killed by Angela Merkel",
					"was killed by Francois Hollande",
					"was killed by Barack Obama",
					"was killed by Vladimir Poutine",
					"was killed by Jean Claude Juncker"
				] call BIS_fnc_selectRandom;
				_message2 = "<t color='#FF9933'>"+_unit + "</t> "+_message+"<br/>";
				_message = "<t align='center'><t color='#FF9933'>"+_unit + "</t> "+_message + "</t>";
			} else {
				_displayname =  (getText (configfile >> "CfgWeapons" >> _weapon >> "displayName"));
				if(_displayname == "") then {
					_displayname = "was killed";
				} else {
					_displayname = "["+_displayname+"]";
				};
				_message = "<t align='center'><t color='#FF9933'>"+_killer + "</t>  "+_displayname+" <t color='#FF9933'>"+_unit+"</t></t><br/>";
				_message2 = "<t color='#FF9933'>"+_killer + "</t>  "+_displayname+" <t color='#FF9933'>"+_unit+"</t><br/>";			
			};
		} else {
			_message = "<t align='center'><t color='#FF9933'>"+_unit + "</t> was killed</t>";
			_message2 = "<t color='#FF9933'>"+_unit + "</t> was killed<br/>";
		};
		killzone = killzone + [_message];
		rollmessage = rollmessage + [_message2];
	};

	BME_netcode_wcmissioncompleted = {
		private ["_array", "_message", "_win", "_text"];
		_array = _this select 0;
		
		_win = _array select 0;
		_text = _array select 1;

		if(_win) then {
			_message = "<t align='center'>Mission <t color='#FF9933'>Completed</t>: "+_text+"</t><br/>";
		} else {
			_message = "<t align='center'>Mission <t color='#ff0000'>Failed</t>: "+_text+"</t><br/>";
		};
		killzone = killzone + [_message];
	};

	BME_netcode_wcticket = {
		private ["_value", "_type", "_ticket", "_credit"];
		_value = _this select 0;
		_ticket = _value select 0;
		_type = _value select 1;
		_credit = _value select 2;
		wcticket = _ticket;

		_index = round ((random 30) + 87);
		_entry = configFile >> "CfgMusic";
		_track = configName(_entry select _index);
		playMusic _track;
		["hintScore", [_ticket, _type, _credit]] call hud;
	};

	BME_netcode_wcteleportack = {
		private ["_returncode", "_position"];

		_returncode = (_this select 0) select 0;
		_position = (_this select 0) select 1;

		switch (_returncode) do {
			case 0 : {
				wcteleportposition = _position;
			};

			case 1 : {
				_title = "Too near of enemy position";
				_text = "Choose a sector far of enemies position";
				["hint", [_title, _text]] call hud;
				
				_position = ["getSectorCenterPos", _position] call client_grid;

				_mark = ["new", [_position, false]] call OO_MARKER;
				["setText", "enemies"] spawn _mark;
				["setType", "hd_warning"] spawn _mark;
				["setSize", [1,1]] spawn _mark;
				["setColor", "ColorRed"] spawn _mark;
				["blink", [1,0.3]] call _mark;
				["delete", _mark] call OO_MARKER;
			};

			case 2 : {
				_title = "Too near of base";
				_text = "Choose a square far of base";
				["hint", [_title, _text]] call hud;

				_position = ["getSectorCenterPos", _position] call client_grid;

				_mark = ["new", [_position, false]] call OO_MARKER;
				["setText", "Too near base"] spawn _mark;
				["setType", "hd_warning"] spawn _mark;
				["setSize", [1,1]] spawn _mark;
				["setColor", "ColorRed"] spawn _mark;
				["blink", [1,0.3]] call _mark;
				["delete", _mark] call OO_MARKER;
			};

			case 3 : {
				_title = "Too near of water";
				_text = "Choose a square far of water";
				["hint", [_title, _text]] call hud;

				_position = ["getSectorCenterPos", _position] call client_grid;

				_mark = ["new", [_position, false]] call OO_MARKER;
				["setText", "Water"] spawn _mark;
				["setType", "hd_warning"] spawn _mark;
				["setSize", [1,1]] spawn _mark;
				["setColor", "ColorRed"] spawn _mark;
				["blink", [1,0.3]] call _mark;
				["delete", _mark] call OO_MARKER;
			};

			default {
				wcteleportposition = position player;
			};
		};
	};

	BME_netcode_playerstats = {
		private ["_score", "_rank"];
		_score = _this select 0;
		if((_score select 0) == name player) then { 
			playerkill = ((_score select 1) select 4);
			playerdeath = ((_score select 1) select 5);
		};

		["addScore", _score] call scoreboard;
		_rank = ["getRankText", ((_score select 1) select 0)] call scoreboard;
		{
			if((_score select 0) == name _x) then { _x setrank _rank; };
		}foreach alldead;
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