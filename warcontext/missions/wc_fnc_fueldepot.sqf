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

	private ["_position", "_run", "_vehicle", "_list", "_supply", "_text", "_mark", "_type"];

	_position = _this;
	_supply = ceil (random 100);

	_position = [_position, 0, 50, 1, 0, 3, 0 ] call BIS_fnc_findSafePos;
	_vehicle = createVehicle ["Land_FuelStation_Shed_F", _position,[], 0, "NONE"];
	_position = position _vehicle;

	_mark = ["new", [_position, false]] call OO_MARKER;
	_text = localize "STR_SUPPLYFULL";
	_type = "hd_end";
	["setText", _text] spawn _mark;
	["setColor", "ColorRed"] spawn _mark;
	["setType", _type] spawn _mark;
	["setSize", [1,1]] spawn _mark;

	_run = true;
	while { _run } do {
		if(damage _vehicle > 0.9) then {
			_run = false;
		};
			
		// fuel depot is empty, must bring a truck
		if(_supply < 20 ) then {
			_text = localize "STR_SUPPLYEMPTY";
		} else {
			_text = localize "STR_SUPPLYFULL";
		};
		["setText", _text] spawn _mark;

		_list = nearestObjects [_position, ["TRUCK"], 25];
		sleep 1;
		
		if(count _list > 0) then { 
			{
				if(_x getvariable ["isenemy", false]) then {
					_x setVariable ["isenemy", false];
					_text= "Bring completed: " + getText (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "DisplayName");
					["setTicket", "mission"] call global_ticket;
					["remoteSpawn", ["BME_netcode_client_wcmissioncompleted", [true, _text], "client"]] call server_bme;
					_supply = 100;
				} else {
					if(_supply > 20) then {
						_x call WC_fnc_servicing;
						_supply = _supply - 20;
					};
				};
				sleep 0.01;
			} foreach _list;
		};
		sleep 1;
	};