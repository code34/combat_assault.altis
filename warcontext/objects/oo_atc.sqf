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
		PRIVATE VARIABLE("array","airports");
		PRIVATE VARIABLE("array","playersback");

		PUBLIC FUNCTION("array","constructor") {
			_grid = ["new", [31000,31000,100,100]] call OO_GRID;
			MEMBER("grid", _grid);
			MEMBER("run", false);
			_airports = [["air1", west], ["air2", west]];
			MEMBER("airports", _airports);
		};

		PUBLIC FUNCTION("", "isFriendly") {
			private ["_enemies", "_sector", "_around"];
			{						
				_enemies = false;
				_sector = ["getSectorFromPos", getmarkerpos (_x select 0)] call MEMBER("grid", nil);
				_around = ["getSectorAround", _sector] call MEMBER("grid", nil);
				{
					_sector = ["Get", str(_x)] call global_zone_hashmap;
					if(!isnil "_sector") then {
						if("getState" call _sector < 2) then {
							_enemies = true;
						};
					};
					sleep 0.0001;
				}foreach _around;
				
				if(_enemies) then {
					(_x select 0) setmarkercolor "colorRed";
				} else {
					(_x select 0) setmarkercolor "colorBlue";
				};
				sleep 0.0001;
			}foreach MEMBER("airports", nil);
		};

		PUBLIC FUNCTION("", "callBack") {
			private ["_array"];
			_array = MEMBER("playersback",nil);
			{
				if((getposatl _x) select 2 > 10) then {
					if!(_x in _array) then {
						if(fuel (vehicle _x) < 0.4) then {
							_array = _array + [_x];
						};
					};
				};
				sleep 0.001;
			}foreach playableunits;
		};

		PUBLIC FUNCTION("", "start") {
			MEMBER("run", true);
			while { MEMBER("run", nil) } do {
				MEMBER("isFriendly", nil);
				MEMBER("callBack", nil);
				sleep 1;
			};
			MEMBER("deconstructor", nil);
		};

		PUBLIC FUNCTION("", "stop") {
			MEMBER("run", false);
		};


		PUBLIC FUNCTION("","deconstructor") { 
			DELETE_VARIABLE("grid");
			DELETE_VARIABLE("run");
		};
	ENDCLASS;