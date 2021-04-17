	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014-2018 Nicolas BOITEUX

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

		PUBLIC FUNCTION("","constructor") {
			MEMBER("airports", []);
			MEMBER("run", false);
			MEMBER("west", []);
			MEMBER("east", []);
			MEMBER("discover", nil);
		};

		PUBLIC FUNCTION("","getWest") FUNC_GETVAR("west");
		PUBLIC FUNCTION("","getEast") FUNC_GETVAR("east");
		PUBLIC FUNCTION("","getAirports") FUNC_GETVAR("airports");

		PUBLIC FUNCTION("", "discover") {
			private _airports = [];
			private _mark = "";
			private _mark2 = "";
			private _positions = [getarray (configfile >> "CfgWorlds" >> worldName >> "ilsPosition")];
			"_positions pushBack (getArray (_x >> 'ilsPosition'))" configClasses (configFile >> "CfgWorlds" >> worldName >> "secondaryAirports");

			{
				_name = toUpper (["generateName", (ceil (random 3) + 1)] call global_namegenerator);
				_mark = createMarker [_name+"_AIRPORT", _x];
				_mark setMarkerType "mil_pickup";
				_mark setMarkerText (_name + " AIRPORT");
				_mark2 = createMarker [_name, _x];
				_mark2 setMarkerShape "ELLIPSE";
				_mark2 setMarkerSize [300,300];
				_mark2 setMarkerColor "COLORBLUE";
				_mark2 setMarkerBrush "FDiagonal";
				MEMBER("airports", nil) pushBack _name;
			}foreach _positions;
		};

		PUBLIC FUNCTION("", "isFriendly") {
			private _sector = [];
			private _around = [];
			private _enemies = false;

			MEMBER("east", []);
			MEMBER("west", []);

			{						
				_enemies = false;
				_sector = ["getSectorFromPos", getmarkerpos _x] call global_grid;
				_around = ["getSectorsAroundSector", _sector] call global_grid;
				{
					_sector = global_zone_hashmap get str(_x);
					if(!isnil "_sector") then {
						if("getState" call _sector < 2) then {
							_enemies = true;
						};
					};
					sleep 0.1;
				}foreach _around;
				
				if(_enemies) then {
					_x setmarkercolor "colorRed";
					MEMBER("east", nil) pushBack _x;
				} else {
					_x setmarkercolor "colorBlue";
					MEMBER("west", nil) pushBack _x;
				};
				sleep 1;
			}foreach MEMBER("airports", nil);
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