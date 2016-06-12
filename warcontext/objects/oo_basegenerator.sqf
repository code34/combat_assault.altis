	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2016 Nicolas BOITEUX

	CLASS OO_BASEGENERATOR
	
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

	CLASS("OO_BASEGENERATOR")
		PRIVATE VARIABLE("array","position");
		PRIVATE VARIABLE("array", "structures");
		PRIVATE VARIABLE("array", "vehicles");
		PRIVATE VARIABLE("string","marker");

		PUBLIC FUNCTION("array","constructor") {
			MEMBER("position", _this);
			MEMBER("createMarker", _this);
		};

		PUBLIC FUNCTION("","getPosition") FUNC_GETVAR("position");

		PUBLIC FUNCTION("array", "setPosition"){
			MEMBER("position", _this);
		};

		PUBLIC FUNCTION("array", "createMarker"){
			_position = _this;
			_marker = createMarker ["globalbase", _position];
			_marker setMarkerText (toUpper ((["generateName", (ceil (random 4) + 1)] call global_namegenerator)  + " Base"));
			_marker setMarkerType "b_hq";
			MEMBER("marker", _marker);
		};

		PUBLIC FUNCTION("array", "unpackBase"){
			private ["_position", "_structures", "_vehicles"];

			_position = _this;
			_structures = [];
			_vehicles = [];

			"respawn_west" setmarkerpos _position;
			MEMBER("marker", nil) setMarkerPos _position;

			{ _x hideObjectGlobal true } foreach (nearestTerrainObjects [_position,[], 100]);

			_temp = "Land_LampAirport_F" createVehicle (_position findEmptyPosition [30,60]);
			_temp setdir (random 360);
			_structures = _structures + [_temp];

			_temp = "Land_Cargo_HQ_V2_F" createVehicle (_position findEmptyPosition [40,100]);
			_temp setdir (random 360);
			_structures = _structures + [_temp];
			wccommanderoff = true;
			_temp addEventHandler ['Killed', { ["wccommanderoff", "client"] call BME_fnc_publicvariable;}];
			_action = _temp addAction ["Pack Base", "client\scripts\packbase.sqf", nil, 1.5, false];
			
			_temp = "Land_Cargo_House_V1_F" createVehicle (_position findEmptyPosition [30,100]);
			_temp setdir (random 360);
			_structures = _structures + [_temp];
			
			_temp = "Land_Medevac_house_V1_F" createVehicle (_position findEmptyPosition [30,100]);
			_temp setdir (random 360);
			_structures = _structures + [_temp];
			
			{
				deleteVehicle _x;
				sleep 0.01;
			}foreach MEMBER("vehicles", nil);
			
			MEMBER("vehicles", _vehicles);
			MEMBER("structures", _structures);
		};

		PUBLIC FUNCTION("array", "packBase"){
			private ["_position", "_structures", "_vehicles"];
			
			_position = _this;
			_structures = [];
			_vehicles = [];

			{
				deleteVehicle _x;
				sleep 0.01;
			}foreach MEMBER("structures", nil);
			MEMBER("structures", _structures);
		
			_temp = "B_Truck_01_transport_F" createVehicle (_position findEmptyPosition [0,15]);
			_action = _temp addAction ["Unpack Base", "client\scripts\unpackbase.sqf", nil, 1.5, false];
			_vehicles = _vehicles + [_temp];
			MEMBER("vehicles", _vehicles);
		};

		PUBLIC FUNCTION("","deconstructor") { 
			MEMBER("deleteBase", nil);
			DELETE_VARIABLE("structures");
			DELETE_VARIABLE("position");
		};
	ENDCLASS;