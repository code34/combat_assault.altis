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

			private ["_type", "_position", "_run", "_counter", "_text", "_win", "_vehicle", "_count", "_mark"];

			_position = _this;
			_position = [_position, 0, 50, 1, 0, 3, 0 ] call BIS_fnc_findSafePos;
			
			_type = ["O_Truck_02_covered_F", "O_Truck_02_transport_F","O_Truck_03_transport_F","O_Truck_03_covered_F","O_Truck_03_repair_F","O_Truck_03_ammo_F","O_Truck_03_fuel_F"] call BIS_fnc_selectRandom;

			_vehicle = createVehicle [_type, _position,[], 0, "NONE"];
			_vehicle setvariable ["isenemy", true];

			MEMBER("target", _vehicle);

			// create mission marker
			_text= "Rob " + getText (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "DisplayName");
			_type = "hd_pickup";
			_mark = [_text, _type];
			_mark = MEMBER("createMarker", _mark);
			//["attachTo", _vehicle] spawn _mark;

			_counter = 3600;
			_run = true;	
			_win = false;

			while { _run } do {
				if(getdammage _vehicle > 0.7) then {
					_run = false;
				};
				if(_position distance _vehicle > 500) then {
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

			_counter = 0;

			while { _counter < 360 } do {
				if(count (crew _vehicle) == 0) then {
					_counter = _counter + 1;
				} else {
					_counter = 0;
				};
				sleep 1;
			};
			deletevehicle _vehicle;