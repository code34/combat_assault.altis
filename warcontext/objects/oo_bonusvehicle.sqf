	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014 Nicolas BOITEUX

	CLASS OO_BONUSVEHICLE STRATEGIC GRID
	
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

	CLASS("OO_BONUSVEHICLE")
		PRIVATE VARIABLE("object","vehicle");
		PRIVATE VARIABLE("array","position");
		PRIVATE VARIABLE("string","type");

		PUBLIC FUNCTION("array","constructor") {
			private ["_type", "_position", "_vehicle"];

			_position = _this select 0;
			MEMBER("position", _position);

			MEMBER("setType", nil);

			_vehicle = createVehicle [MEMBER("getType", nil), _position, [], 0, "NONE"];
			_vehicle addeventhandler ['HandleDamage', {
				private ["_name", "_gunner", "_commander"];
				if(side(_this select 3) in [west, civilian]) then {
					if ((_this select 2) > 0.4) then {
						(_this select 0) setHit [(_this select 1), (_this select 2)];
						(_this select 0) setdamage (damage (_this select 0) + (_this select 2));
						if(damage (_this select 0) > 0.9) then {
							(_this select 0) setdamage 1;
							(_this select 0) removeAllEventHandlers "HandleDamage";
						};
					};
				};
			}];

			MEMBER("vehicle", _vehicle);
		};

		PUBLIC FUNCTION("","getType") FUNC_GETVAR("type");
		PUBLIC FUNCTION("","getPosition") FUNC_GETVAR("position");
		PUBLIC FUNCTION("","getVehicle") FUNC_GETVAR("vehicle");


		PUBLIC FUNCTION("", "removeVehicle") {
			MEMBER("getVehicle", nil) setdamage 1;
			deletevehicle MEMBER("getVehicle", nil);
		};

		PUBLIC FUNCTION("", "setType") {
			_type = ["B_Truck_01_transport_F", "B_APC_Wheeled_01_cannon_F", "B_MBT_01_TUSK_F", "B_MBT_01_cannon_F"] call BIS_fnc_selectRandom;
			MEMBER("type", _type);
		};


		PUBLIC FUNCTION("", "checkAlive") {
			private ["_counter", "_vehicle"];

			_counter = 0;
			_vehicle = MEMBER("getVehicle", nil);

			while { ((getDammage _vehicle < 0.9) || (fuel _vehicle > 0)) } do {
				
				if(count crew _vehicle == 0) then { _counter = _counter + 1} else {_counter = 0;};
				if(_counter > 180) then { _vehicle setfuel 0;};
				sleep 1;
			}; 
			sleep 30;
			MEMBER("delete", nil);
		};

		PUBLIC FUNCTION("","deconstructor") { 
			MEMBER("removeVehicle", nil);
			DELETE_VARIABLE("vehicle");
		};
	ENDCLASS;