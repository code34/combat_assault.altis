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
			private ["_position", "_vehicle", "_mark"];

			_position = _this select 0;
			//_position = [_position, 0,50,10,0, 1000,0] call BIS_fnc_findSafePos;
			MEMBER("position", _position);

			_array = [_position, 180, "O_APC_Tracked_02_AA_F", EAST] call bis_fnc_spawnvehicle;
			_vehicle = _array select 0;
			_group = _array select 2;
			_group setBehaviour "COMBAT";
			_group setCombatMode "RED";
			
			//MEMBER("createMarker", _vehicle);
			MEMBER("group", _group);
			[_vehicle] spawn WC_fnc_vehiclehandler;
			MEMBER("vehicle", _vehicle);
		};

		PUBLIC FUNCTION("","getPosition") FUNC_GETVAR("position");
		PUBLIC FUNCTION("","getVehicle") FUNC_GETVAR("vehicle");

		PUBLIC FUNCTION("object", "createMarker") {
			private ["_mark"];
			_mark = ["new", [position _this, false]] call OO_MARKER;
			["attachTo", _this] spawn _mark;
			["setText", "Anti Air"] spawn _mark;
			["setColor", "ColorRed"] spawn _mark;
			["setType", "hd_destroy"] spawn _mark;
			["setSize", [0.5,0.5]] spawn _mark;
			MEMBER("marker", _mark);
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
			private ["_group"];
			
			_group = MEMBER("group", nil);
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