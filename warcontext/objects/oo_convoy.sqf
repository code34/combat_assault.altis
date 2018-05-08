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
		PRIVATE VARIABLE("string","locationname");

		PUBLIC FUNCTION("array","constructor") {
			MEMBER("locationname", "");
			MEMBER("startposition", _this);
			MEMBER("endposition", _this);
			MEMBER("vehicle", objNull);
			MEMBER("setTarget", _this);
			MEMBER("popTruck", nil);
		};

		PUBLIC FUNCTION("","getVehicle") FUNC_GETVAR("vehicle");

		PUBLIC FUNCTION("", "startConvoy") {	
			private _leader = leader MEMBER("group", nil);
			private _vehicle = vehicle _leader;
			private _rate = 0;
			private _text = "";
			
			["remoteSpawn", ["BME_netcode_client_wcconvoystart", true, "client"]] call global_bme;

			while { ((alive _leader) and !(vehicle _leader isEqualTo _leader)) } do {
				if(speed _leader < 5) then {
					_rate = _rate + 1;
					_text = format["Truck - Expanding %1", _rate] +"%";
					["setText", _text] spawn MEMBER("marker", nil);
					if(_rate > 99) then { _leader setdammage 1; };
				} else {
					_rate = 0;
					_text = format ["Truck - direction: %1", MEMBER("locationname", nil)];
					["setText", _text] spawn MEMBER("marker", nil);
				};
				sleep 1;
			};

			if(_rate > 99) then {
				private _sector = ["getSectorFromPos", position _leader] call global_grid;
				["remoteSpawn", ["BME_netcode_client_wcconvoy", true, "client"]] call global_bme;
				["expandSector", _sector] call global_controller;
				["expandSectorAround", [_sector, floor(random 2)]] call global_controller;
				["setText", "Truck - Expanding done"] spawn MEMBER("marker", nil);
			} else {
				["remoteSpawn", ["BME_netcode_client_wcconvoy", false, "client"]] call global_bme;
				["setText", "Truck - Expanding failed"] spawn MEMBER("marker", nil);
			};
		
			private _counter = 0;
			while { _counter < 360 } do {
				if(({alive _x} count (crew _vehicle)) == 0) then { 
					_counter = _counter + 1;
				} else {
					_counter = 0;
				};
				sleep 1;
			};
			MEMBER("deconstructor", nil);
		};

		PUBLIC FUNCTION("array", "setTarget") {
			private _position = _this;
			private _positions = [];
			private _distance = 30000;
			private _markers = [];
			private _marker = "";
			private _endposition = [];
			private _locationname = "";
			private _locations = [];

			if(("countWest" call global_atc >  0) and (random 1> 1)) then {
				_markers = "getWest" call global_atc;
				{
					if ((getmarkerpos _x ) distance _position < _distance) then {
						_distance = (getmarkerpos _x ) distance _position;
						_marker = _x;
					};
					sleep 0.0001;
				}foreach _markers;
				_endposition = getmarkerpos _marker;	
				_locationname = _marker;
			} else {
				"(getText (_x >> 'type') in ['NameVillage', 'NameCity', 'NameCityCapital', 'CityCenter']) && {(_positions pushBack getArray (_x >> 'position')) > -1}" configClasses (configFile >> "CfgWorlds" >> worldName >> "Names");			
				"(getText (_x >> 'type') in ['NameVillage', 'NameCity', 'NameCityCapital', 'CityCenter']) && {(_locations pushBack getText (_x >> 'name')) > -1}" configClasses (configFile >> "CfgWorlds" >> worldName >> "Names");
				_distance = 30000;
				{
					if((_x distance _position < _distance) and (_x distance _position > 3000)) then {
						_distance = _x distance _position;
						_endposition = _x;
						_locationname = _locations select _forEachIndex;
					};
				} foreach _positions;
			};

			if(_locationname isEqualTo "") then { _locationname = "unknown";};
			MEMBER("endposition", _endposition);
			MEMBER("locationname", _locationname);
		};


		// Creer plusieurs trucks
		PRIVATE FUNCTION("", "popTruck") {
			private _position = MEMBER("startposition", nil);
			private _type = selectRandom ["O_Truck_02_covered_F", "O_Truck_02_transport_F","O_Truck_03_transport_F","O_Truck_03_covered_F","O_Truck_03_repair_F","O_Truck_03_ammo_F","O_Truck_03_fuel_F"];
			_position = [_position, 0,50,10,0,2000,0] call BIS_fnc_findSafePos;
			private _array = [_position, random 359, _type, east] call bis_fnc_spawnvehicle;
			private _vehicle = _array select 0;
			private _group = _array select 2;
			MEMBER("createMarker",  leader _group);
			_vehicle setvariable ["isenemy", true];
			_array = [MEMBER("endposition", nil),  _group];
			MEMBER("moveTo", _array);
			MEMBER("vehicle", _vehicle);
			MEMBER("group", _group);
		};

		PRIVATE FUNCTION("object", "createMarker") {
			private _mark = ["new", [position _this, false]] call OO_MARKER;
			["attachTo", _this] spawn _mark;
			private _name= getText (configFile >> "CfgVehicles" >> (typeOf _this) >> "DisplayName");
			["setText", _name] spawn _mark;
			["setColor", "ColorRed"] spawn _mark;
			["setType", "o_support"] spawn _mark;
			["setSize", [0.5,0.5]] spawn _mark;
			MEMBER("marker", _mark);
		};

		PUBLIC FUNCTION("", "removeVehicle") {
			private _vehicle = MEMBER("vehicle", nil);
			{
				_x setdammage 1;
				deletevehicle _x;
				sleep 0.001;
			}foreach (crew _vehicle);
			_vehicle setdammage 1;
			deletevehicle _vehicle;
		};

		PUBLIC FUNCTION("array", "moveTo") {
			private _position = _this select 0;
			private _group = _this select 1;
			
			private _wp = _group addwaypoint [_position, 0];
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
			DELETE_VARIABLE("locationname");
		};
	ENDCLASS;