	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014 Nicolas BOITEUX

	CLASS OO_ARTILLERY

	different type of ammos:
		- bomb
		- clusterbomb
		- bigbomb
		- vehiclemine
		- manmine
		- smoke
	
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

	CLASS("OO_ARTILLERY")
		PRIVATE VARIABLE("object","vehicle");
		PRIVATE VARIABLE("group","group");
		PRIVATE VARIABLE("object","target");
		PRIVATE VARIABLE("array","position");
		PRIVATE VARIABLE("string","ammo");
		PRIVATE VARIABLE("scalar","round");

		PUBLIC FUNCTION("array","constructor") {
			private ["_position", "_vehicle"];

			_position = _this select 0;
			_position = [_position, 0,50,10,0,2000,0] call BIS_fnc_findSafePos;
			MEMBER("position", _position);

			_array = [_position, 180, "O_MBT_02_arty_F", EAST] call bis_fnc_spawnvehicle;

			_vehicle = _array select 0;
			_group = _array select 2;
			_group setBehaviour "COMBAT";
			_group setCombatMode "RED";
			MEMBER("group", _group);

			_vehicle addeventhandler ['HandleDamage', {
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

			_vehicle addeventhandler ['Fired', { hint "artillery";}];

			MEMBER("vehicle", _vehicle);
			MEMBER("ammo", "32Rnd_155mm_Mo_shells");
			MEMBER("round", 3);
			enableEngineArtillery true;
		};

		PUBLIC FUNCTION("","getPosition") FUNC_GETVAR("position");
		PUBLIC FUNCTION("","getVehicle") FUNC_GETVAR("vehicle");
		PUBLIC FUNCTION("","getAmmo") FUNC_GETVAR("ammo");
		PUBLIC FUNCTION("","getTarget") FUNC_GETVAR("target");
		PUBLIC FUNCTION("","getRound") FUNC_GETVAR("round");

		PUBLIC FUNCTION("", "getAmmoAvalaible") {
			getArtilleryAmmo [MEMBER("getVehicle", nil)];
		};

		PUBLIC FUNCTION("", "doFire") {
			MEMBER("getVehicle", nil) doArtilleryFire [(position MEMBER("target", nil)), MEMBER("ammo", nil), MEMBER("round", nil)];
		};

		PUBLIC FUNCTION("", "canFire") {
			(position MEMBER("target", nil)) inRangeOfArtillery [[MEMBER("getVehicle", nil)], MEMBER("ammo", nil)];
		};

		PUBLIC FUNCTION("", "getEta") {
			MEMBER("getVehicle", nil) getArtilleryETA [(position MEMBER("target", nil)), currentMagazine MEMBER("getVehicle", nil)];
		};


		PUBLIC FUNCTION("", "removeVehicle") {
			MEMBER("getVehicle", nil) setdamage 1;
			deletevehicle MEMBER("getVehicle", nil);
		};

		PUBLIC FUNCTION("string", "setAmmo") {
			private ["_ammo"];

			switch (_this) do {
				case "bomb": {
					_ammo = "32Rnd_155mm_Mo_shells";
				};

				case "cluster": {
					_ammo = "2Rnd_155mm_Mo_Cluster";
				};

				case "smoke": {
					_ammo = "6Rnd_155mm_Mo_smoke";
				};
	
				case "bigbomb": {
					_ammo = "2Rnd_155mm_Mo_LG";
				};

				case "vehiclemine": {
					_ammo = "6Rnd_155mm_Mo_AT_mine";
				};

				case "manmine": {
					_ammo = "6Rnd_155mm_Mo_mine";
				};

				default {
					_ammo = "32Rnd_155mm_Mo_shells";
				};
			};
			MEMBER("ammo", _ammo);			
		};

		PUBLIC FUNCTION("object", "setTarget") {
			MEMBER("target", _this);
		};

		PUBLIC FUNCTION("scalar", "setRound") {
			MEMBER("round", _this);
		};


		PUBLIC FUNCTION("", "checkAlive") {
			private ["_counter", "_vehicle"];

			_counter = 0;
			_vehicle = MEMBER("getVehicle", nil);

			while { ((getDammage _vehicle < 0.9) || (fuel _vehicle > 0)) } do {		
				sleep 1;
			}; 
			sleep 30;
			MEMBER("delete", nil);
		};

		PUBLIC FUNCTION("","deconstructor") { 
			MEMBER("removeVehicle", nil);
			DELETE_VARIABLE("vehicle");
			DELETE_VARIABLE("group");
			DELETE_VARIABLE("target");
			DELETE_VARIABLE("position");
			DELETE_VARIABLE("ammo");
			DELETE_VARIABLE("round");
		};
	ENDCLASS;