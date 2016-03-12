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
	*/

	BME_fnc_publicvariable = {
		private ["_handlername", "_variable", "_destination", "_playerid"];

		_handlername 	= _this select 0;
		_variable 	= missionNamespace getVariable _handlername;
		_destination	= tolower(_this select 1);
		_playerid 	= _this select 2;
		
		if!(typename _handlername == "STRING") exitwith {"BME: wrong type variablename parameter, should be STRING" call BME_fnc_log;};
		if!(typename _destination == "STRING") exitwith {"BME: wrong type destination parameter, should be STRING" call BME_fnc_log;};
		if!(_destination in ["client", "server", "all"]) exitwith {"BME: wrong destination parameter should be client|server|all" call BME_fnc_log;};
		if(isnil "_variable") exitwith {format["BME:  Variable data for %1 handler is nil", _handlername] call BME_fnc_log;};

		bme_addqueue = [_handlername, _variable, _destination];

		switch (_destination) do {
			case "server": {
				publicvariableserver "bme_addqueue";
			};

			case "client": {
				if(!isnil "_playerid") then {
					_playerid publicvariableclient "bme_addqueue";
				} else {
					if((local player) and (isserver)) then {
						//(owner player) publicvariableclient "bme_addqueue";
						bme_addqueue call BME_fnc_addqueue;
					};
					publicvariable "bme_addqueue";
				};
			};

			default {
				if(isserver) then {
					if!(local player) then {
						publicvariableserver "bme_addqueue";
					};
				} ;
				if(local player) then {
					//(owner player) publicvariableclient "bme_addqueue";
					bme_addqueue call BME_fnc_addqueue;
				};
				publicvariable "bme_addqueue";
			};
		};
	};

	BME_fnc_addqueue = {
		private ["_destination", "_array"];

		_destination = _this select 2;

		// insert message in the queue if its for server or everybody
		if((isserver) and ((_destination == "server") or (_destination == "all"))) then {
			_array = [_this select 0, _this select 1, "server"];
			bme_queue pushBack _array;
		};
		
		// insert message in the queue if its for client or everybody
		if((local player) and ((_destination == "client") or (_destination == "all"))) then {	
			_array = [_this select 0, _this select 1, "client"];
			bme_queue pushBack _array;
		};
	};

	"bme_addqueue" addPublicVariableEventHandler {
		(_this select 1) call BME_fnc_addqueue;
	};
