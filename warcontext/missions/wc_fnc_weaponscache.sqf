	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014-2018 Nicolas BOITEUX

	CLASS OO_MISSION
	
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

			private ["_type", "_position", "_run", "_counter", "_text", "_win", "_vehicle", "_mark"];

			_position = _this;
			_position = [_position, 0, 50, 1, 0, 3, 0 ] call BIS_fnc_findSafePos;
			
			_type = "Box_FIA_Wps_F";

			_vehicle = createVehicle [_type, _position,[], 0, "NONE"];
			MEMBER("target", _vehicle);

			// create mission marker
			_text= "Destroy " + getText (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "DisplayName");
			_type = "hd_unknown";
			_mark = [_text, _type];
			_mark = MEMBER("createMarker", _mark);

			_counter = 3600;
			_run = true;
			_win = false;

			while { _run } do {
				if(getdammage _vehicle > 0.7) then {
					_run = false;
					_win = true;
				};
				if(_position distance _vehicle > 200) then {
					_run = false;
					_win = true;
				};
				if(_counter < 1) then {
					_run = false;
				};
				_counter = _counter  - 1;
				sleep 1;
			};

			if(_win)	then {
				["setTicket", "mission"] call global_ticket;
				wcmissioncompleted = [true, _text];
				["wcmissioncompleted", "client"] call BME_fnc_publicvariable;
				while { count crew _vehicle > 0} do {
					sleep 30;
				};
			} else {
				wcmissioncompleted = [false, _text];
				["wcmissioncompleted", "client"] call BME_fnc_publicvariable;
			};
			deletevehicle _vehicle;