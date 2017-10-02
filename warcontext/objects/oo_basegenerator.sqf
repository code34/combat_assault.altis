	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2016-2017 Nicolas BOITEUX

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
		PRIVATE VARIABLE("string","marker");
		PRIVATE VARIABLE("object","base");
		PRIVATE VARIABLE("bool","packed");

		PUBLIC FUNCTION("","constructor") {
			MEMBER("buildBase", nil);
			MEMBER("packed", false);
		};

		PUBLIC FUNCTION("","getPosition") FUNC_GETVAR("position");

		PUBLIC FUNCTION("array", "setPosition"){
			MEMBER("position", _this);
		};

		PUBLIC FUNCTION("", "buildBase"){
			private ["_position", "_base"];

			_position = [0,0];
			_base = objNull;

			while { _base isEqualTo objNull } do {
				_position = MEMBER("generatePosition", nil);
				{ _x hideObjectGlobal true } foreach (nearestTerrainObjects [_position,[], 100]);
				_base = "Land_Cargo_HQ_V2_F" createVehicle (_position findEmptyPosition [5,50]);
				[[_base, ["Pack Base", "client\scripts\packbase.sqf", nil, 1.5, false]],"addAction",true,true] call BIS_fnc_MP;

				if!(_base isEqualTo objNull) then {
					_base addEventHandler ['HandleDamage', { false; }];
					_base setdir (random 360);
				};
				sleep 0.1;
			};

			"respawn_west" setmarkerpos _position;
			MEMBER("marker", nil) setMarkerPos _position;
			MEMBER("createMarker", _position);
			MEMBER("position", _position);
			MEMBER("base", _base);
		};

		PUBLIC FUNCTION("", "deleteBase"){
			deleteVehicle MEMBER("base", nil);
			deleteMarker MEMBER("marker", nil);
		};

		PUBLIC FUNCTION("", "generatePosition"){
			private ["_flag", "_sector", "_position", "_size", "_sectorsize"];
			
			_flag = false;
			_size = getNumber (configfile >> "CfgWorlds" >> worldName >> "mapSize");
			_sectorsize = 100;

			while { !_flag } do {
				_sector = [ceil (random (_size/_sectorsize)), ceil (random (_size/_sectorsize))];
				_position = ["getPosFromSector", _sector] call global_grid;
				if!(surfaceIsWater _position) then {
					if((_position isFlatEmpty  [100, -1, 0.05, 100, -1]) isEqualTo []) then {
						_flag = true;
					};
				};
				sleep 0.01;
			};
			_position;
		};

		PUBLIC FUNCTION("array", "createMarker"){
			private ["_position", "_marker"];
			_position = _this;
			_marker = createMarker ["globalbase", _position];
			_marker setMarkerText (toUpper ((["generateName", (ceil (random 3) + 1)] call global_namegenerator)  + " Base"));
			_marker setMarkerType "b_hq";
			MEMBER("marker", _marker);
		};

		PUBLIC FUNCTION("", "unpackBase"){
			private ["_position", "_base", "_newposition"];

			_position = getMarkerPos "respawn_west";

			if(MEMBER("packed", nil)) then {
				MEMBER("packed", false);
				deleteVehicle MEMBER("base", nil);

				_newposition =  (_position findEmptyPosition [5,50]);
				if(_newposition isEqualTo []) exitWith {};

				_base = "Land_Cargo_HQ_V2_F" createVehicle _newposition;
				[[_base, ["Pack Base", "client\scripts\packbase.sqf", nil, 1.5, false]],"addAction",true,true] call BIS_fnc_MP;
				
				_base addEventHandler ['HandleDamage', { false; }];
				_base setdir (random 360);

				"respawn_west" setmarkerpos (position _base);
				MEMBER("marker", nil) setMarkerPos (position _base);
				MEMBER("base", _base);
			};
		};

		PUBLIC FUNCTION("", "packBase"){
			private ["_position", "_base", "_newposition"];
			
			_position = getMarkerPos "respawn_west";

			if(!MEMBER("packed", nil)) then {
				MEMBER("packed", true);
				deleteVehicle MEMBER("base", nil);

				_newposition =  (_position findEmptyPosition [0,15]);
				if(_newposition isEqualTo []) exitWith {};

				_base = "B_Truck_01_transport_F" createVehicle _newposition;
				[[_base, ["Unpack Base", "client\scripts\unpackbase.sqf", nil, 1.5, false]],"addAction",true,true] call BIS_fnc_MP;
				
				_mark = MEMBER("marker", nil);
				[_base, _mark] spawn {
					while { alive (_this select 0)} do {
						(_this select 1) setMarkerPos (getpos (_this select 0));
						"respawn_west" setmarkerpos (getpos (_this select 0));
						sleep 0.1;
					};
				};
				MEMBER("base", _base);
			};
		};		

		PUBLIC FUNCTION("","deconstructor") { 
			MEMBER("deleteBase", nil);
			DELETE_VARIABLE("position");
			DELETE_VARIABLE("marker");
			DELETE_VARIABLE("base");
		};
	ENDCLASS;