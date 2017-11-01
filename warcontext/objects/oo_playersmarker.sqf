	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2016-2018 Nicolas BOITEUX

	CLASS OO_PLAYERSMARKER
	
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

	CLASS("OO_PLAYERSMARKER")
		PRIVATE VARIABLE("array","markers");
		PRIVATE VARIABLE("code","grid");
		PRIVATE VARIABLE("code","hashmap");

		PUBLIC FUNCTION("string","constructor") {
			MEMBER("markers", []);		
			private _grid = ["new", [0,0, 31000,31000,1000,1000]] call OO_GRID;
			MEMBER("grid", _grid);
			private _hashmap  = ["new", []] call OO_HASHMAP;
			MEMBER("hashmap", _hashmap);
		};

		PUBLIC FUNCTION("","start") {
			while { true } do {
				MEMBER("draw", nil);
				sleep 15;
			};
		};

		PUBLIC FUNCTION("","draw") {
			private _position = [];
			private _mark = "";
			MEMBER("markers", []);

			{
				_position = ["getSectorCenterPos", (position _x)] call MEMBER("grid", nil);
				_mark = ["get", str(_x)] call MEMBER("hashmap", nil);
				if(isnil "_mark") then {
					_mark = ["new", [_position, false]] call OO_MARKER;
					["setShape", "RECTANGLE"] spawn _mark;
					["setSize", [500,500]] spawn _mark;
					if(side _x isEqualTo west) then {
						["setColor", "ColorBlue"] spawn _mark;
					} else {
						["setColor", "ColorRed"] spawn _mark;
					};
					["put", [str(_x), _mark]] call MEMBER("hashmap", nil);
				} else {
					["setPos", _position] spawn _mark;
				};
				MEMBER("markers", nil) pushBack _mark;
			}foreach playableUnits;
		};


		PUBLIC FUNCTION("","unDraw") {
			{
				["delete", _x] call OO_MARKER;
			}foreach MEMBER("markers", nil);
		};

		PUBLIC FUNCTION("","deconstructor") { 
			DELETE_VARIABLE("markers");
		};
	ENDCLASS;