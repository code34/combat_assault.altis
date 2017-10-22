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
		BME_netcode_nameofyourvariable = { code to execute on client side };
	*/

	// Example function hint message on client side
	BME_netcode_client_bme_message = {
		bme_message = _this;
		hint bme_message;
	};

	BME_netcode_client_wcairports = {
		wcairports = _this;
	};

	BME_netcode_client_wcfactorys = {
		wcfactorys = _this;
	};
	
	BME_netcode_client_vehicleavalaible = {
		"Vehicle servicing" hintC format ["Vehicle will be avalaible in %1 seconds", _this];
	};

	BME_netcode_client_wcunblacklist = {
		wcblacklist = wcblacklist - [name _this];
		diag_log format ["You unblacklist by a BIG HUG : %1 %2", name _this, _this];
	};

	BME_netcode_client_wcbonusvehicle = {
		private ["_name", "_sector", "_message"];
		_sector = ["getSectorFromPos", position _this] call client_grid ;
		_name= getText (configFile >> "CfgVehicles" >> (typeOf _this) >> "DisplayName");
		_message = "<t align='center'><t color='#FF9933'>"+ _name + "</t> " + localize "STR_DROPPED_TEXT" + format [" %1", _sector] + "</t>";
		killzone pushBack _message;
	};

	BME_netcode_client_wcconvoystart = {
		private ["_message"];
		_message = "<t color='#FF9933'>"+ localize "STR_ENEMYCONVOY_TEXT" + "</t> " + localize "STR_SPOTTED_TEXT" + "<br/>";
		rollmessage pushBack _message;
		_message = "<t align='center'><t color='#FF9933'>"+ localize "STR_ENEMYCONVOY_TEXT" + "</t> " + localize "STR_SPOTTED_TEXT" + "</t>";
		killzone pushBack _message;
	};

	BME_netcode_client_wccommanderoff = {
		private ["_message"];
		_message = "<t color='#FF9933'>"+ localize "STR_COMMANDEROFF_TEXT" + "</t><br/>";
		rollmessage pushBack _message;
		_message = "<t align='center'><t color='#FF9933'>"+ localize "STR_COMMANDEROFF_TEXT" + "</t> ";
		killzone pushBack _message;	
	};

	BME_netcode_client_wcaircraftstart = {
		private ["_message"];
		_message = "<t color='#FF9933'>An Enemy Aircraft</t> has been discovered<br/>";
		rollmessage pushBack _message;
		_message = "<t align='center'><t color='#FF9933'>An Enemy Aircraft</t> has been discovered</t>";
		killzone pushBack _message;
	};

	BME_netcode_client_wcartillerystart = {
		private ["_message"];
		_message = "<t color='#FF9933'>An Enemy Artillery</t> has been discovered<br/>";
		rollmessage pushBack _message;
		_message = "<t align='center'><t color='#FF9933'>An Enemy Artillery</t> has been discovered</t>";
		killzone pushBack _message;
	};

	BME_netcode_client_wcsectorcompleted = {
		private ["_message"];
		_message = format ["<t color='#FF9933'>Sector %1%2</t> has been completed<br/>", _this select 0, _this select 1];
		rollmessage pushBack _message;
		_message = format["<t align='center'><t color='#FF9933'>Sector %1%2</t> has been completed</t>",_this select 0, _this select 1];
		killzone pushBack _message;
	};	

	BME_netcode_client_wcconvoy = {
		private ["_message"];
		if(_this) then {
			_message = "<t color='#FF9933'>Enemy convoy</t> - expanding done<br/>";
			rollmessage pushBack _message;
			_message = "<t align='center'><t color='#FF9933'>Enemy convoy</t> - expanding done</t>";
			killzone pushBack _message;
		} else {
			_message = "<t color='#FF9933'>Enemy Convoy</t> - expanding failed<br/>";
			rollmessage pushBack _message;
			_message = "<t align='center'><t color='#FF9933'>Enemy Convoy</t> - expanding failed</t>";
			killzone pushBack _message;
		};
	};

	BME_netcode_client_vehiclegetin = {
		player moveindriver _this;
		waituntil {speed _this > 60};
		_reload = ["new", _this] call OO_RELOADPLANE;
		"start" spawn _reload;
	};

	BME_netcode_client_wcaideath = {
		private ["_unit", "_killer", "_message", "_weapon", "_displayname", "_playerkill", "_playerdeath"];
		
		_array = _this;
		_unit = _array select 0;
		_killer = _array select 1;
		_weapon = _array select 2;
		_playerkill =_array select 3;
		_playerdeath = _array select 4;
		_displayname =  (getText (configfile >> "CfgWeapons" >> _weapon >> "displayName"));

		if!(_killer == "") then {
			_message = "<t color='#FF9933'>"+_killer + "</t>  ["+_displayname+"] <t color='#FF9933'>"+_unit+"</t><br/>";
			if(_killer == name player) then {
				playerkill = _playerkill; 
				playerdeath = _playerdeath;
			};
		} else {
			_message = "<t color='#FF9933'>"+_unit + "</t> was killed<br/>";
		};
		rollmessage pushBack _message;		
	};

	BME_netcode_client_wcdeath = {
		private ["_victim", "_killer", "_message", "_message2", "_displayname", "_weapon", "_name"];
		
		_victim = _this select 0;
		_killer = _this select 1;
		_weapon = currentWeapon _killer;

		if(_killer isKindOf "Man") then {
			_name = name _killer;
			if( toUpper(_name) isEqualTo "ERROR: NO UNIT") then { 
				_name = ["Francois Hollande", "Angela Merkel", "Barak Obama", "Vladimir Poutine", "Donald Trump", "Netarion", "Jp", "Snow Queen", "Ben Laden", "America Fist", "Donald Trump", "Bachar el-Assad"] call BIS_fnc_selectRandom;
			};
		} else {
			_name= getText (configFile >> "CfgVehicles" >> (typeOf _killer) >> "DisplayName");
		};

		if((isplayer _victim) and (isplayer _killer)) then {
			if((name player == name _victim) and !(name _victim in wcblacklist)) then {
				if((name _killer) != (name player)) then {
					wcblacklist = wcblacklist + [name _killer];
				};
			};

			if((name player == name _killer) and !(name _killer in wcblacklist)) then {
				if((name _victim) != (name player)) then {
					wcblacklist = wcblacklist + [name _victim];
				};
			};
		};

		if!(_name isEqualTo "") then {
			if(_victim isEqualTo _killer) then {
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
				_message2 = "<t color='#FF9933'>"+name _victim + "</t> "+_message+"<br/>";
				_message = "<t align='center'><t color='#FF9933'>"+name _victim + "</t> "+_message + "</t>";
			} else {
				_displayname =  (getText (configfile >> "CfgWeapons" >> _weapon >> "displayName"));
				if(_displayname == "") then {
					_displayname = "was killed";
				} else {
					_displayname = "["+_displayname+"]";
				};
				_message = "<t align='center'><t color='#FF9933'>"+_name + "</t>  "+_displayname+" <t color='#FF9933'>"+ name _victim +"</t></t><br/>";
				_message2 = "<t color='#FF9933'>"+_name + "</t>  "+_displayname+" <t color='#FF9933'>"+ name _victim +"</t><br/>";			
			};
		} else {
			_message = "<t align='center'><t color='#FF9933'>"+ name _victim + "</t> was killed</t>";
			_message2 = "<t color='#FF9933'>"+ name _victim + "</t> was killed<br/>";
		};
		killzone pushBack _message;
		rollmessage pushBack _message2;
	};

	BME_netcode_client_wcmissioncompleted = {
		private ["_message"];
		if(_this select 0) then {
			_message = "<t align='center'>Mission <t color='#FF9933'>Completed</t>: "+(_this select 1)+"</t><br/>";
		} else {
			_message = "<t align='center'>Mission <t color='#ff0000'>Failed</t>: "+(_this select 0)+"</t><br/>";
		};
		killzone pushBack _message;
	};

	BME_netcode_client_wcticket = {
		wcticket = _this;
	};

	BME_netcode_client_wcteleportack = {
		private ["_returncode", "_position"];

		_returncode = _this select 0;
		_position = _this select 1;

		switch (_returncode) do {
			case 0 : {
				wcteleportposition = _position;
			};

			case 1 : {
				_title = "Too near of enemy position";
				_text = "Choose a sector far of enemies position";
				["hint", [_title, _text]] call hud;
				
				_position = ["getSectorCenterPos", _position] call client_grid;

				_mark = ["new", [_position, true]] call OO_MARKER;
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

				_mark = ["new", [_position, true]] call OO_MARKER;
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

				_mark = ["new", [_position, true]] call OO_MARKER;
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

	// variable send by the server
	// playerstats = [_name, [_gameranking, _serverranking, _matches, _gamescore, _kill, _death]];
	BME_netcode_client_playerstats = {
		private ["_score", "_rank"];
		_score = _this;
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

	BME_netcode_client_end = {
		if(toLower(_this select 0) isEqualTo "win") then {
			["end1",false,2] call BIS_fnc_endMission;
		} else {
			["epicFail",false,2] call BIS_fnc_endMission;
		};
	};

	// return true when read
	true;