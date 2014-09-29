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
		PRIVATE VARIABLE("bool","suppression");

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

			_vehicle addeventhandler ['Hit', {
				if(_this select 2 > 0.30) then {
					(_this select 0) setdamage (getdammage (_this select 0) + random (1));
				};
			}];

			MEMBER("target", _vehicle);
			MEMBER("vehicle", _vehicle);
			MEMBER("ammo", "32Rnd_155mm_Mo_shells");
			MEMBER("round", 3);
			MEMBER("setSuppression", false);
			enableEngineArtillery true;
		};

		PUBLIC FUNCTION("","getPosition") FUNC_GETVAR("position");
		PUBLIC FUNCTION("","getVehicle") FUNC_GETVAR("vehicle");
		PUBLIC FUNCTION("","getAmmo") FUNC_GETVAR("ammo");
		PUBLIC FUNCTION("","getTarget") FUNC_GETVAR("target");
		PUBLIC FUNCTION("","getRound") FUNC_GETVAR("round");
		PUBLIC FUNCTION("","getSuppression") FUNC_GETVAR("suppression");

		PUBLIC FUNCTION("bool", "setSuppression") {
			MEMBER("suppression", _this);
		};

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
			{
				_x setdamage 1;
				deletevehicle _x;
			}foreach (crew MEMBER("getVehicle", nil));

			MEMBER("getVehicle", nil) setdamage 1;
			deletevehicle MEMBER("getVehicle", nil);
		};

		PUBLIC FUNCTION("bool", "autoSetAmmo") {
			private ["_ammo", "_target"];
			_target = MEMBER("target", nil);

			if(!MEMBER("suppression", nil)) then {			
				if( _target iskindof "Man") then {
					if( format["%1", (surfacetype position _target)] in ["#GdtGrassDry", "#GdtDirt", "#GdtGrassGreen"]) then {
						_ammo = ["smoke", "cluster", "bomb", "mine"] call BIS_fnc_selectRandom;
					} else {
						_ammo = ["smoke", "cluster", "bomb"] call BIS_fnc_selectRandom;
					};
				} else {
					_ammo = ["cluster", "bomb", "mine"] call BIS_fnc_selectRandom;
				};
			} else {
				_ammo = "smoke";
			};
			MEMBER("setAmmo", _ammo);
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

				case "mine": {
					if(MEMBER("target", nil) != vehicle MEMBER("target", nil)) then {
						_ammo = "6Rnd_155mm_Mo_AT_mine";
					} else {
						_ammo = "6Rnd_155mm_Mo_mine";
					};
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


		PUBLIC FUNCTION("","deconstructor") { 
			MEMBER("removeVehicle", nil);
			DELETE_VARIABLE("vehicle");
			deleteGroup MEMBER("group", nil);
			DELETE_VARIABLE("group");
			DELETE_VARIABLE("target");
			DELETE_VARIABLE("position");
			DELETE_VARIABLE("ammo");
			DELETE_VARIABLE("round");
			DELETE_VARIABLE("suppression");
		};
	ENDCLASS;