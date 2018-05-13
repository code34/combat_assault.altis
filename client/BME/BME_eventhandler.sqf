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
		private ["_variablename", "_variablevalue", "_destination", "_playerid"];

		_variablename 	= _this select 0;
		_variablevalue 	= missionNamespace getVariable _variablename;
		_destination	= tolower(_this select 1);
		_playerid 	= _this select 2;
		
		if(isnil "_destination") exitwith {"BME: missing destination parameter" call BME_fnc_log;};
		if(isnil "_variablevalue") exitwith {format["BME: variable %1 is nil", _variablename] call BME_fnc_log;};
		if!(typename _variablename == "STRING") exitwith {"BME: wrong type variablename parameter, should be STRING" call BME_fnc_log;};
		if!(typename _destination == "STRING") exitwith {"BME: wrong type destination parameter, should be STRING" call BME_fnc_log;};
		if!(_destination in ["client", "server", "all"]) exitwith {"BME: wrong destination parameter should be client|server|all" call BME_fnc_log;};

		bme_addqueue = [_variablename, _variablevalue, _destination];
		
		switch (_destination) do {
			case "server": {
				publicvariableserver "bme_addqueue";
			};

			case "client": {
				if(!isnil "_playerid") then {
					_playerid publicvariableclient "bme_addqueue";
				} else {
					if((local player) and (isserver)) then {
						(owner player) publicvariableclient "bme_addqueue";
					};
					publicvariable "bme_addqueue";
				};
			};

			default {
				if((local player) and (isserver)) then {
					(owner player) publicvariableclient "bme_addqueue";
				};
				publicvariable "bme_addqueue";
			};
		};
	};

	BME_fnc_addqueue = {
		private ["_destination"];

		_destination = _this select 2;

		// insert message in the queue if its for server or everybody
		if((isserver) and ((_destination == "server") or (_destination == "all"))) then {
			bme_queue pushBack _this;
		};
		
		// insert message in the queue if its for client or everybody
		if((local player) and ((_destination == "client") or (_destination == "all"))) then {	
			bme_queue pushBack _this;
		};
	};

	"bme_addqueue" addPublicVariableEventHandler {
		(_this select 1) call BME_fnc_addqueue;
	};
