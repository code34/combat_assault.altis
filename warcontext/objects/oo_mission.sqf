	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014-2018 Nicolas BOITEUX

	CLASS OO_MISSION
	
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

	CLASS("OO_MISSION")
		PRIVATE VARIABLE("bool", "active");

		PUBLIC FUNCTION("","constructor") {
			MEMBER("active", false);
		};

		PUBLIC FUNCTION("","getActive") FUNC_GETVAR("active");

		PUBLIC FUNCTION("bool", "setActive") {
			MEMBER("active", _this);
		};

		PUBLIC FUNCTION("", "generateMission") {
			_type = selectRandom ["bringobject", "destroystructure", "getman", "rescuepeople", "robobject", "weaponcache"];
			
			switch (_type) do { 
				case 1 : {  

				 }; 
				case 2 : {  

				 }; 
				default {  

				}; 
			};
		};

		PUBLIC FUNCTION("","deconstructor") { 
			DELETE_VARIABLE("active");
		};
	ENDCLASS;