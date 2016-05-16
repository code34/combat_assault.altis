	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014 Nicolas BOITEUX

	CLASS OO_ATC
	
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

	CLASS("OO_ATC")
		PRIVATE VARIABLE("bool","run");
		PRIVATE VARIABLE("array","west");
		PRIVATE VARIABLE("array","east");
		PRIVATE VARIABLE("array", "airports");

		PUBLIC FUNCTION("scalar","constructor") {
			_array = [];
			MEMBER("run", false);
			MEMBER("west", _array);
			MEMBER("east", _array);
			MEMBER("discover", _this);
		};

		PUBLIC FUNCTION("","getWest") FUNC_GETVAR("west");
		PUBLIC FUNCTION("","getEast") FUNC_GETVAR("east");
		PUBLIC FUNCTION("","getAirports") FUNC_GETVAR("airports");

		PUBLIC FUNCTION("scalar", "discover") {
			private ["_positions", "_airports"];

			_airports = [];
			_positions = [getarray (configfile >> "CfgWorlds" >> worldName >> "ilsPosition")];
			"_positions pushBack (getArray (_x >> 'ilsPosition'))" configClasses (configFile >> "CfgWorlds" >> worldName >> "secondaryAirports");

			{
				_name = toUpper (["generateName", (ceil (random 4) + 1)] call global_namegenerator);
				
				_temp = createMarker [_name+"_AIRPORT", _x];
				_temp setMarkerType "mil_pickup";
				_temp setMarkerText (_name + " AIRPORT");

				_temp = createMarker [_name, _x];
				_temp setMarkerShape "ELLIPSE";
				_temp setMarkerSize [300,300];
				_temp setMarkerColor "COLORBLUE";
				_temp setMarkerBrush "FDiagonal";

				_airports = _airports + [_name];
			}foreach _positions;
			MEMBER("airports", _airports);
		};

		PUBLIC FUNCTION("", "isFriendly") {
			private ["_enemies", "_sector", "_around", "_wairport", "_eairport"];
			
			_wairport = [];
			_eairport = [];
			{						
				_enemies = false;
				_sector = ["getSectorFromPos", getmarkerpos _x] call global_grid;
				_around = ["getSectorsAroundSector", _sector] call global_grid;
				{
					_sector = ["get", str(_x)] call global_zone_hashmap;
					if(!isnil "_sector") then {
						if("getState" call _sector < 2) then {
							_enemies = true;
						};
					};
					sleep 0.1;
				}foreach _around;
				
				if(_enemies) then {
					_x setmarkercolor "colorRed";
					_eairport = _eairport + [_x];
				} else {
					_x setmarkercolor "colorBlue";
					_wairport = _wairport + [_x];
				};
				sleep 1;
			}foreach MEMBER("airports", nil);
			MEMBER("west", _wairport);
			MEMBER("east", _eairport);
		};

		PUBLIC FUNCTION("", "countWest") {
			count MEMBER("west", nil);
		};

		PUBLIC FUNCTION("", "countEast") {
			count MEMBER("east", nil);
		};

		PUBLIC FUNCTION("", "start") {
			MEMBER("run", true);
			while { MEMBER("run", nil) } do {
				MEMBER("isFriendly", nil);
				sleep 1;
			};
		};

		PUBLIC FUNCTION("", "stop") {
			MEMBER("run", false);
		};


		PUBLIC FUNCTION("","deconstructor") { 
			DELETE_VARIABLE("west");
			DELETE_VARIABLE("east");
			DELETE_VARIABLE("run");
		};
	ENDCLASS;