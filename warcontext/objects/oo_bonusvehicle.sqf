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
		PRIVATE STATIC_VARIABLE("scalar","counter");
		PRIVATE VARIABLE("object","vehicle");
		PRIVATE VARIABLE("array","position");
		PRIVATE VARIABLE("string","type");
		PRIVATE VARIABLE("code","marker");

		PUBLIC FUNCTION("array","constructor") {
			private ["_counter", "_position"];

			_counter = MEMBER("counter",nil);
			if (isNil "_counter") then {_counter = 0;};
			_counter = _counter + 1;
			MEMBER("counter", _counter);
			if(_counter < 8) exitwith {};
			MEMBER("counter", 0);

			// increase difficulty
			wcskill = wcskill + 0.01;

			_position = _this;
			MEMBER("position", _position);
			MEMBER("setType", nil);
			MEMBER("popVehicle", nil);
			MEMBER("setMarker", nil);
			MEMBER("checkAlive", nil);
		};

		PUBLIC FUNCTION("","getType") FUNC_GETVAR("type");
		PUBLIC FUNCTION("","getPosition") FUNC_GETVAR("position");
		PUBLIC FUNCTION("","getVehicle") FUNC_GETVAR("vehicle");

		PUBLIC FUNCTION("", "popVehicle") {
			private ["_vehicle"];
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
			if(random 1 > 0.9) then {
				 _position = [_position, 3, random 360] call BIS_fnc_relPos;
				createVehicle ["APERSBoundingMine_Range_Ammo", _position,[], 0, "can_collide"];
			};
		};

		PUBLIC FUNCTION("", "removeVehicle") {
			MEMBER("getVehicle", nil) setdamage 1;
			deletevehicle MEMBER("getVehicle", nil);
		};

		PUBLIC FUNCTION("", "setMarker") {
			private ["_mark", "_name"];
			_mark = ["new", [position MEMBER("vehicle", nil), true]] call OO_MARKER;
			["attachTo", MEMBER("vehicle", nil)] spawn _mark;
			_name= getText (configFile >> "CfgVehicles" >> (typeOf MEMBER("vehicle", nil)) >> "DisplayName");
			["setText", _name] spawn _mark;
			["setColor", "ColorGreen"] spawn _mark;
			["setType", "mil_arrow"] spawn _mark;
			["setSize", [0.8,0.8]] spawn _mark;
			MEMBER("marker", _mark);
		};

		PUBLIC FUNCTION("", "setType") {
			private ["_position", "_airport", "_type"];
			
			_position = MEMBER("position", nil);
			_airport = false;

			{
				if(_position distance getmarkerpos _x < 1000) then {
					_airport = true;
				};
			}foreach ["viking","hurricane","crocodile", "coconuts", "liberty"];
			
			if(_airport) then {
				_type = ["B_Heli_Light_01_F", "B_Heli_Light_01_armed_F", "O_Heli_Light_02_F", "O_Heli_Light_02_unarmed_F", "I_Heli_light_03_F", "I_Heli_light_03_unarmed_F"]  call BIS_fnc_selectRandom;
			} else {
				_type = ["B_Truck_01_transport_F", "B_APC_Wheeled_01_cannon_F", "B_MBT_01_TUSK_F", "B_MBT_01_cannon_F"] call BIS_fnc_selectRandom;
			};
			MEMBER("type", _type);
		};


		PUBLIC FUNCTION("", "checkAlive") {
			private ["_counter", "_vehicle"];

			_counter = 0;
			_vehicle = MEMBER("getVehicle", nil);

			while { ((getDammage _vehicle < 0.9) and (fuel _vehicle > 0.1)) } do {
				if(count crew _vehicle == 0) then { _counter = _counter + 1} else {_counter = 0;};
				if(_counter > 180) then { _vehicle setfuel 0;};
				_name= getText (configFile >> "CfgVehicles" >> (typeOf MEMBER("vehicle", nil)) >> "DisplayName") + format[" - %1", (180 -_counter)];
				["setText", _name] call MEMBER("marker", nil);
				sleep 1;
			}; 
			MEMBER("deconstructor", nil);
		};

		PUBLIC FUNCTION("","deconstructor") { 
			["delete", MEMBER("marker", nil)] call OO_MARKER;
			DELETE_VARIABLE("marker");
			MEMBER("removeVehicle", nil);
			DELETE_VARIABLE("vehicle");
			DELETE_VARIABLE("position");
			DELETE_VARIABLE("type");
		};
	ENDCLASS;