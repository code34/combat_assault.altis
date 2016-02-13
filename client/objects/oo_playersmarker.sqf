﻿	/*
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
		PRIVATE VARIABLE("array","list");
		PRIVATE VARIABLE("array","markers");
		PRIVATE VARIABLE("code","hashmap");
		
		PUBLIC FUNCTION("array","constructor") {
			private ["_array", "_hashmap"];
			
			MEMBER("setList", _this);

			_array = [];
			MEMBER("markers", _array);
					
			_hashmap  = ["new", []] call OO_HASHMAP;
			MEMBER("hashmap", _hashmap);
		};


		PUBLIC FUNCTION("array","setList") {
			MEMBER("list", _this);
		};

		PUBLIC FUNCTION("","start") {
			while { true } do {
				MEMBER("draw", nil);
				MEMBER("garbage", nil);
				sleep 10;
			};
		};

		PUBLIC FUNCTION("","garbage") {
			private ["_temp", "_mark", "_unit"];

			{
				_mark = _x select 0;
				_unit = _x select 1;

				if( (("getPos" call _mark) distance [0,0] < 100) or !(alive _unit) ) then {
					["remove", str(_unit)] call MEMBER("hashmap", nil);
					["delete", _mark] call OO_MARKER;
					_temp = MEMBER("markers", nil) - [[_mark, _unit]];
					MEMBER("markers", _temp);
				};
			} foreach MEMBER("markers", nil);
		};

		PUBLIC FUNCTION("","draw") {
			private ["_array", "_position", "_temp", "_mark", "_list"];

			_list = MEMBER("list", nil);

			{
				if((name _x) in _list) then {
					_position = position _x;
					_mark = ["get", str(_x)] call MEMBER("hashmap", nil);
					if(isnil "_mark") then {
						_mark = ["new", [_position, false]] call OO_MARKER;
						["attachTo", _x] spawn _mark;
						["setText", name _x] spawn _mark;
						["setColor", "ColorGreen"] spawn _mark;
						["setType", "mil_arrow2"] spawn _mark;
						["setSize", [0.5,0.5]] spawn _mark;
						["put", [str(_x), _mark]] call MEMBER("hashmap", nil);
						_temp = MEMBER("markers", nil) + [[_mark, _x]];
						MEMBER("markers", _temp);
					};
				};
			}foreach allunits;
		};


		PUBLIC FUNCTION("","unDraw") {
			{
				_mark = _x select 0;
				_unit = _x select 1;
				["remove", str(_unit)] call MEMBER("hashmap", nil);
				["delete", _mark] call OO_MARKER;
			} foreach MEMBER("markers", nil);
			
			_temp = [];
			MEMBER("markers", _temp);
		};

		PUBLIC FUNCTION("","deconstructor") { 
			DELETE_VARIABLE("list");
			DELETE_VARIABLE("markers");
			DELETE_VARIABLE("hashmap");
		};
	ENDCLASS;