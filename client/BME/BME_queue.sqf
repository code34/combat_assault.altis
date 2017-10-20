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
	*/

	private ["_code", "_destination", "_garbage", "_message", "_variable", "_handlername"];

	while { true } do {
		_message = bme_queue deleteAt 0;
		if(!isnil "_message") then {

			_handlername	= _message select 0;
			_variable	= _message select 1;
			_destination 	= _message select 2;
			_code 		= nil;

			if(isserver and ((_destination == "server") or (_destination == "all"))) then {
				_code = (missionNamespace getVariable (format ["BME_netcode_server_%1", _handlername]));
				if!(isnil "_code") then {
					_garbage = [_variable] spawn _code;
				} else {
					hintc format["BME: server handler function for %1 doesnt exist", _handlername] call BME_fnc_log;
				};
			};

			if(local player and ((_destination == "client") or (_destination == "all"))) then {
				_code = (missionNamespace getVariable (format ["BME_netcode_%1", _handlername]));
				if!(isnil "_code") then {
					_garbage = [_variable] spawn _code;
				} else {
					hintc format["BME: client handler function for %1 doesnt exist", _handlername] call BME_fnc_log;
				};
			};
		};
		sleep 0.1;
	};

