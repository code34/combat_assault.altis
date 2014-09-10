	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014 Nicolas BOITEUX

	CLASS OO_GROUP
	
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

	CLASS("OO_GROUP")
		PRIVATE VARIABLE("group","group");
		PRIVATE VARIABLE("object","target");

		PUBLIC FUNCTION("group","constructor") {
			MEMBER("group", _this);
		};

		PUBLIC FUNCTION("","getGroup") FUNC_GETVAR("group");
		PUBLIC FUNCTION("","getTarget") FUNC_GETVAR("target");

		PUBLIC FUNCTION("", "isAlive") {
			if(MEMBER("getSize", nil) > 0) then {true;} else {false;};
		};

		PUBLIC FUNCTION("", "isInVehicle") {
			if(MEMBER("getLeader", nil) == vehicle MEMBER("getLeader", nil)) then {true;} else {false;};
		};

		PUBLIC FUNCTION("", "getSize") {
			count (units MEMBER("group", nil));
		};

		PUBLIC FUNCTION("", "getLeader") {
			leader MEMBER("group", nil);
		};

		PUBLIC FUNCTION("", "getSide") {
			side (leader MEMBER("group", nil));
		};

		PUBLIC FUNCTION("array", "distanceToPos") {
			MEMBER("getLeader", nil) distance _this;
		};

		PUBLIC FUNCTION("", "distanceToTarget") {
			MEMBER("distanceToPos", position MEMBER("target", nil));
		};

		PUBLIC FUNCTION("object", "setTarget") {
			MEMBER("target", _this);
			{
				_x dotarget _this;
				sleep 0.01;
			}foreach (units MEMBER("group", nil));
		};

		PUBLIC FUNCTION("object", "revealTarget") {
			MEMBER("group", nil) reveal [_this, 4];
		};

		PUBLIC FUNCTION("", "setCombatMode") {
			MEMBER("group", nil) setBehaviour "COMBAT";
			MEMBER("group", nil) setCombatMode "RED";
			MEMBER("group", nil) setSpeedMode "FULL";
		};	

		PUBLIC FUNCTION("", "setSafeMode") {
			MEMBER("group", nil) setBehaviour "SAFE";
			MEMBER("group", nil) setCombatMode "GREEN";
			MEMBER("group", nil) setSpeedMode "NORMAL";
		};	

		PUBLIC FUNCTION("","deconstructor") { 
			deleteGroup MEMBER("group", nil);
			DELETE_VARIABLE("group");
			DELETE_VARIABLE("target");
		};
	ENDCLASS;