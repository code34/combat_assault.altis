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
		PRIVATE VARIABLE("string","ammo");
		PRIVATE VARIABLE("scalar","round");
		PRIVATE VARIABLE("bool","suppression");
		PRIVATE VARIABLE("code","marker");

		PUBLIC FUNCTION("array","constructor") {
			private _position = [(_this select 0), 0,50,10,0,2000,0] call BIS_fnc_findSafePos;
			MEMBER("createArtillery", _position);
			MEMBER("createMarker", _vehicle);
			MEMBER("setCombatMode", nil);
			["remoteSpawn", ["BME_netcode_client_wcartillerystart", true, "client"]] call server_bme;
		};

		PUBLIC FUNCTION("array", "createArtillery") {
			private _array = [_this, 180, (selectRandom wcartilleryvehicles), EAST] call bis_fnc_spawnvehicle;
			private _vehicle = _array select 0;
			private _group = _array select 2;
			MEMBER("group", _group);
			MEMBER("target", _vehicle);
			MEMBER("vehicle", _vehicle);
			[_vehicle] spawn WC_fnc_vehiclehandler;
			MEMBER("ammo", "32Rnd_155mm_Mo_shells");
			MEMBER("round", floor(random 3));
			MEMBER("setSuppression", false);
			enableEngineArtillery true;
		};

		PUBLIC FUNCTION("array", "isAlive") {
			alive MEMBER("vehicle", nil);
		};

		PUBLIC FUNCTION("object", "createMarker") {
			private _mark = ["new", [position _this, false]] call OO_MARKER;
			["attachTo", _this] spawn _mark;
			["setText", "Artillery"] spawn _mark;
			["setColor", "ColorRed"] spawn _mark;
			["setType", "hd_destroy"] spawn _mark;
			["setSize", [0.5,0.5]] spawn _mark;
			MEMBER("marker", _mark);
		};

		PUBLIC FUNCTION("","getPosition") {
			position MEMBER("vehicle", nil);
		};

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

		PUBLIC FUNCTION("object", "callFireOnTarget") {
			MEMBER("setTarget", _this);
			MEMBER("autoSetAmmo", nil);
			MEMBER("doFire", nil);
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

		PUBLIC FUNCTION("bool", "autoSetAmmo") {
			private _target = MEMBER("target", nil);
			private _ammo = "";

			if(!MEMBER("suppression", nil)) then {			
				if( _target iskindof "Man") then {
					_ammo = selectRandom ["smoke", "cluster", "bomb", "mine", "bigbomb"];
				} else {
					_ammo = selectRandom ["cluster", "bomb", "mine", "bigbomb"];
				};
			} else {
				_ammo = "smoke";
			};
			MEMBER("setAmmo", _ammo);
		};

		PUBLIC FUNCTION("string", "setAmmo") {
			private _ammo = "";
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
			["delete", MEMBER("marker", nil)] call OO_MARKER;
			MEMBER("removeVehicle", nil);
			DELETE_VARIABLE("vehicle");
			deleteGroup MEMBER("group", nil);
			DELETE_VARIABLE("group");
			DELETE_VARIABLE("target");
			DELETE_VARIABLE("ammo");
			DELETE_VARIABLE("round");
			DELETE_VARIABLE("suppression");
		};
	ENDCLASS;