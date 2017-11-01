	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2016 Nicolas BOITEUX

	CLASS OO_ANTIAIR

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

	CLASS("OO_ANTIAIR")
		PRIVATE VARIABLE("object","vehicle");
		PRIVATE VARIABLE("group","group");
		PRIVATE VARIABLE("array","position");
		PRIVATE VARIABLE("string","ammo");
		PRIVATE VARIABLE("code","marker");

		PUBLIC FUNCTION("array","constructor") {
			MEMBER("position",  (_this select 0));
			private _array = [ (_this select 0), 180, (selectRandom wcantiairvehicles), EAST] call bis_fnc_spawnvehicle;
			MEMBER("group", (_array select 2));
			[(_array select 0)] spawn WC_fnc_vehiclehandler;
			MEMBER("vehicle", (_array select 0));
			MEMBER("setCombatMode", nil);
		};

		PUBLIC FUNCTION("","getPosition") FUNC_GETVAR("position");
		PUBLIC FUNCTION("","getVehicle") FUNC_GETVAR("vehicle");

		PUBLIC FUNCTION("object", "createMarker") {
			private _mark = ["new", [position _this, false]] call OO_MARKER;
			["attachTo", _this] spawn _mark;
			private _name= getText (configFile >> "CfgVehicles" >> (typeOf _this) >> "DisplayName");
			["setText", _name] spawn _mark;
			["setColor", "ColorRed"] spawn _mark;
			["setType", "hd_destroy"] spawn _mark;
			["setSize", [0.5,0.5]] spawn _mark;
			MEMBER("marker", _mark);
		};

		PUBLIC FUNCTION("", "setMoveMode") {
			MEMBER("group", nil) setBehaviour "AWARE";
			MEMBER("group", nil) setCombatMode "RED";
			MEMBER("group", nil) setSpeedMode "FULL";
			MEMBER("group", nil) allowFleeing 0.1;
		};		

		PUBLIC FUNCTION("", "setSafeMode") {
			MEMBER("group", nil) setBehaviour "SAFE";
			MEMBER("group", nil) setCombatMode "GREEN";
			MEMBER("group", nil) setSpeedMode "NORMAL";
			MEMBER("group", nil) allowFleeing 0.1;
		};

		PUBLIC FUNCTION("", "setCombatMode") {
			MEMBER("group", nil) setBehaviour "COMBAT";
			MEMBER("group", nil) setCombatMode "RED";
			MEMBER("group", nil) setSpeedMode "FULL";
			MEMBER("group", nil) allowFleeing 0.1;
		};

		PUBLIC FUNCTION("", "removeVehicle") {
			{
				_x setdamage 1;
				deletevehicle _x;
				sleep 0.01;
			}foreach (crew MEMBER("getVehicle", nil));

			MEMBER("getVehicle", nil) setdamage 1;
			deletevehicle MEMBER("getVehicle", nil);
		};

		PUBLIC FUNCTION("object", "patrol") {	
			private _group = MEMBER("group", nil);
			while { count (units _group) > 0 } do {
				{
					(leader _group) reveal [_x, 4];
					sleep 0.01;
				} foreach allplayers;
				sleep 15;
			};
			MEMBER("deconstructor", nil);
		};

		PUBLIC FUNCTION("","deconstructor") { 
			["delete", MEMBER("marker", nil)] call OO_MARKER;
			MEMBER("removeVehicle", nil);
			DELETE_VARIABLE("vehicle");
			deleteGroup MEMBER("group", nil);
			DELETE_VARIABLE("group");
			DELETE_VARIABLE("target");
			DELETE_VARIABLE("position");
		};
	ENDCLASS;