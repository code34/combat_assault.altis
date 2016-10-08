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

	CLASS("OO_NAMEGENERATOR")
		PRIVATE VARIABLE("array","syllabes");

		PUBLIC FUNCTION("","constructor") {

		};

		PUBLIC FUNCTION("scalar", "generateName"){
			private ["_name", "_size"];

			_size = _this;

			_name = "";
			for "_i" from 0 to _size do {
				_name = _name + MEMBER("generateSyllabe", nil);
			};
			_name;
		};

		PRIVATE FUNCTION("", "generateSyllabe"){
			_voyelles = ["a", "e", "i", "o", "u"];
			_consonnes = ["b","c","d","f","g","h","j","k","l","m","n","r","s","t","p"];
			if(random 1 < 0.95) then {
				(_consonnes call BIS_fnc_selectRandom) + (_voyelles call BIS_fnc_selectRandom);
			} else {
				(_voyelles call BIS_fnc_selectRandom) + (_voyelles call BIS_fnc_selectRandom);
			};
		};


		PUBLIC FUNCTION("","deconstructor") { 
			DELETE_VARIABLE("syllabes");
		};
	ENDCLASS;