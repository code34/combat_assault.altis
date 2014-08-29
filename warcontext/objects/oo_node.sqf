	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014 Nicolas BOITEUX

	CLASS OO_NODE STRATEGIC GRID
	
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

	CLASS("OO_NODE")
		PRIVATE VARIABLE("code","parent");
		PRIVATE VARIABLE("code","goal");
		PRIVATE VARIABLE("scalar","cost");
		PRIVATE VARIABLE("scalar","x");
		PRIVATE VARIABLE("scalar","y");

		PUBLIC FUNCTION("array","constructor") {
			private["_array"];
			MEMBER("parent", _this select 0);
			MEMBER("goal", _this select 1);
			MEMBER("cost", _this select 2);
			MEMBER("x", _this select 3);
			MEMBER("y", _this select 4);
		};

		PUBLIC FUNCTION("","getParent") FUNC_GETVAR("parent");
		PUBLIC FUNCTION("","getGoal") FUNC_GETVAR("goal");
		PUBLIC FUNCTION("","getCost") FUNC_GETVAR("cost");
		PUBLIC FUNCTION("","getX") FUNC_GETVAR("x");
		PUBLIC FUNCTION("","getY") FUNC_GETVAR("y");


		PUBLIC FUNCTION("array", "getTotalCost") {
			private ["_cost"];
			_cost = MEMBER("cost", nil) + MEMBER("getEstimateCost", []);
			_cost;
		};


		// Estimation of the cost between current node and goal node
		PUBLIC FUNCTION("array", "getEstimateCost") {
			private ["_x", "_y", "_dx", "_dy"];

			_x = "getX" call MEMBER("goal", nil);
			_y = "getY" call MEMBER("goal", nil);

			_dx = abs(MEMBER("x", nil) - _x);
			_dy = abs(MEMBER("y", nil) - _y);

			(_dx + _dy);
		};

		PUBLIC FUNCTION("","deconstructor") { 
			DELETE_VARIABLE("parent");
			DELETE_VARIABLE("goal");
			DELETE_VARIABLE("cost");
			DELETE_VARIABLE("x");
			DELETE_VARIABLE("y");
		};
	ENDCLASS;