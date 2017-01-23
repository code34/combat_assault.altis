	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014-2017 Nicolas BOITEUX

	CLASS OO_CONVOY
	
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

	#include "oop.h"

	CLASS("OO_CONVOY")
		PRIVATE VARIABLE("array","startposition");
		PRIVATE VARIABLE("array","endposition");
		PRIVATE VARIABLE("object","vehicle");
		PRIVATE VARIABLE("code","marker");
		PRIVATE VARIABLE("group","group");

		PUBLIC FUNCTION("array","constructor") {
			private ["_array", "_startposition", "_endposition"];

			_startposition = _this;
			MEMBER("startposition", _startposition);

			_array = [];
			MEMBER("vehicle", objNull);
			MEMBER("setTarget", _startposition);
			MEMBER("popTruck", nil);
		};

		PUBLIC FUNCTION("","getVehicle") FUNC_GETVAR("vehicle");

		PUBLIC FUNCTION("", "startConvoy") {
			private ["_rate", "_vehicle", "_sector", "_text", "_position", "_group", "_counter"];
			
			wcconvoystart = true;
			["wcconvoystart", "client"] call BME_fnc_publicvariable;	

			_group = MEMBER("group", nil);
			_leader = leader _group;
			_vehicle = vehicle _leader;

			_rate = 0;
			while { ((alive _leader) and (vehicle _leader != _leader)) } do {
				if(speed _leader < 5) then {
					_rate = _rate + 1;
					_text = format["Truck - Expanding %1", _rate] +"%";
					["setText", _text] spawn MEMBER("marker", nil);
					if(_rate > 99) then {
						_leader setdammage 1;
					};
				} else {
					_rate = 0;
					["setText", "Truck"] spawn MEMBER("marker", nil);
				};
				sleep 1;
			};

			if(_rate > 99) then {
				_sector = ["getSectorFromPos", position _leader] call global_grid;
				wcconvoy = true;
				["wcconvoy", "client"] call BME_fnc_publicvariable;				
				["expandSector", _sector] call global_controller;
				["expandSectorAround", [_sector, floor(random 2)]] call global_controller;
				["setText", "Truck - Expanding done"] spawn MEMBER("marker", nil);
			} else {
				wcconvoy = false;
				["wcconvoy", "client"] call BME_fnc_publicvariable;				
				["setText", "Truck - Expanding failed"] spawn MEMBER("marker", nil);
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
			MEMBER("deconstructor", nil);
		};

		PUBLIC FUNCTION("array", "setTarget") {
			private ["_distance", "_endposition", "_markers", "_marker", "_position", "_bool", "_positions"];

			_position = _this;
			_positions = [];

			if(("countWest" call global_atc >  0) and (random 1> 1)) then {
				_markers = "getWest" call global_atc;
				_distance = 30000;
				{
					if ((getmarkerpos _x ) distance _position < _distance) then {
						_distance = (getmarkerpos _x ) distance _position;
						_marker = _x;
					};
					sleep 0.0001;
				}foreach _markers;
				_endposition = getmarkerpos _marker;				
			} else {
				"(getText (_x >> 'type') in ['NameVillage', 'NameCity', 'NameCityCapital', 'CityCenter']) && {(_positions pushBack getArray (_x >> 'position')) > -1}" configClasses (configFile >> "CfgWorlds" >> worldName >> "Names");
				_distance = 30000;
				{
					if(_x distance _position < _distance) then {
						_distance = _x distance _position;
						_endposition = _x;
					};
				} foreach _positions;
			};
			MEMBER("endposition", _endposition);
		};


		// Creer plusieurs trucks
		PRIVATE FUNCTION("", "popTruck") {
			 private ["_array", "_group", "_position", "_vehicle", "_type", "_leader"];

			_position = MEMBER("startposition", nil);
			_type = ["O_Truck_02_covered_F", "O_Truck_02_transport_F","O_Truck_03_transport_F","O_Truck_03_covered_F","O_Truck_03_repair_F","O_Truck_03_ammo_F","O_Truck_03_fuel_F"] call BIS_fnc_selectRandom;

			_position = [_position, 0,50,10,0,2000,0] call BIS_fnc_findSafePos;
			_array = [_position, random 359, _type, east] call bis_fnc_spawnvehicle;
			_vehicle = _array select 0;
			_vehicle setvariable ["isenemy", true];
			_group = _array select 2;
			_leader = leader _group;

			_mark = ["new", [position _leader, false]] call OO_MARKER;
			["attachTo", _leader] spawn _mark;
			["setText", "Convoy"] spawn _mark;
			["setColor", "ColorRed"] spawn _mark;
			["setType", "mil_arrow"] spawn _mark;
			["setSize", [0.5,0.5]] spawn _mark;
			MEMBER("marker", _mark);

			_array = [MEMBER("endposition", nil),  _group];
			MEMBER("moveTo", _array);
			MEMBER("vehicle", _vehicle);
			MEMBER("group", _group);
		};

		PUBLIC FUNCTION("", "removeVehicle") {
			private ["_vehicle"];
			
			_vehicle = MEMBER("vehicle", nil);
			{
				_x setdammage 1;
				deletevehicle _x;
				sleep 0.001;
			}foreach (crew _vehicle);
			_vehicle setdammage 1;
			deletevehicle _vehicle;
		};

		PUBLIC FUNCTION("array", "moveTo") {
			private ["_group", "_wp", "_position"];

			_position = _this select 0;
			_group = _this select 1;
			
			_wp = _group addwaypoint [_position, 0];
			_wp setWaypointPosition [_position, 5];
			_wp setWaypointType "MOVE";
			_wp setWaypointSpeed "FULL";
			_group setCurrentWaypoint _wp;
		};

		PUBLIC FUNCTION("","deconstructor") { 
			["delete", MEMBER("marker", nil)] call OO_MARKER;
			MEMBER("removeVehicle", nil);
			deletegroup MEMBER("group", nil);
			DELETE_VARIABLE("vehicles");
			DELETE_VARIABLE("startposition");
			DELETE_VARIABLE("endposition");
			DELETE_VARIABLE("group");
		};
	ENDCLASS;