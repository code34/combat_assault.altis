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
		PRIVATE VARIABLE("code","grid");
		PRIVATE VARIABLE("array","west");
		PRIVATE VARIABLE("array","east");

		PUBLIC FUNCTION("array","constructor") {
			_grid = ["new", [31000,31000,100,100]] call OO_GRID;
			_array = [];
			MEMBER("grid", _grid);
			MEMBER("run", false);
			MEMBER("west", _array);
			MEMBER("east", _array);
		};

		PUBLIC FUNCTION("","getWest") FUNC_GETVAR("west");
		PUBLIC FUNCTION("","getEast") FUNC_GETVAR("east");

		PUBLIC FUNCTION("", "isFriendly") {
			private ["_enemies", "_sector", "_around", "_wairport", "_eairport"];
			
			_wairport = [];
			_eairport = [];
			{						
				_enemies = false;
				_sector = ["getSectorFromPos", getmarkerpos _x] call MEMBER("grid", nil);
				_around = ["getSectorAround", _sector] call MEMBER("grid", nil);
				{
					_sector = ["Get", str(_x)] call global_zone_hashmap;
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
			}foreach ["viking","hurricane","crocodile", "coconuts", "liberty"];
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
			DELETE_VARIABLE("grid");
			DELETE_VARIABLE("run");
		};
	ENDCLASS;