	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2016 Nicolas BOITEUX

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
		
		PUBLIC FUNCTION("string","constructor") {
			_array = [];
			MEMBER("markers", _array);
		};

		PUBLIC FUNCTION("","start") {
			while { true } do {
				MEMBER("draw", nil);
				sleep 15;
				MEMBER("unDraw", nil);
			};
		};

		PUBLIC FUNCTION("","draw") {
			private ["_array", "_position", "_sector", "_mark"];
			_array = [];
			{

				_position = position _x;
				_position = ["getSectorCenterPos", _position] call global_grid;

				_mark = ["new", [_position, false]] call OO_MARKER;
				["setShape", "RECTANGLE"] spawn _mark;
				["setSize", [50,50]] spawn _mark;
				if(side _x == west) then {
					["setColor", "ColorBlue"] spawn _mark;
				} else {
					["setColor", "ColorRed"] spawn _mark;
				};
				_array = _array + [_mark];
			}foreach playableUnits;
			MEMBER("markers", _array);
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