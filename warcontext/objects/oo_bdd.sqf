	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014 Nicolas BOITEUX

	CLASS OO_NODE
	
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

	CLASS("OO_BDD")
		PRIVATE VARIABLE("array","value");

		PUBLIC FUNCTION("array","constructor") {
		};

		PUBLIC FUNCTION("string", "getValue") {
			_key = _this select 0;
			profileNamespace getVariable _key;
		};

		PUBLIC FUNCTION("array", "setValue") {
			_key = _this select 0;
			_value = _this select 1;
			profileNamespace setVariable [_key, _value];
		};

		PUBLIC FUNCTION("","deconstructor") { 
			DELETE_VARIABLE("value");
		};
	ENDCLASS;