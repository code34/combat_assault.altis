	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2016-2018 Nicolas BOITEUX

	CLASS OO_SUPPLY
	
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

	CLASS("OO_SUPPLY")
		PRIVATE VARIABLE("code","marker");
		PRIVATE VARIABLE("object", "supply");

		PUBLIC FUNCTION("object","constructor") {
			MEMBER("supply", _this);	
			MEMBER("createMarker", _this);
		};

		PUBLIC FUNCTION("object", "createMarker") {	
			private _name= getText (configFile >> "CfgVehicles" >> (typeOf _this) >> "DisplayName");
			private _mark = ["new", [position _this, false]] call OO_MARKER;
			["setPos", position _this] spawn _mark;
			["setText", _name] spawn _mark;
			["setColor", "ColorOrange"] spawn _mark;
			["setType", "mil_triangle"] spawn _mark;
			["setSize", [1,1]] spawn _mark;
			MEMBER("marker", _mark);
		};		

		PUBLIC FUNCTION("","deconstructor") { 
			["delete", MEMBER("marker", nil)] call OO_MARKER;
			DELETE_VARIABLE("marker");
			DELETE_VARIABLE("supply");
		};
	ENDCLASS;