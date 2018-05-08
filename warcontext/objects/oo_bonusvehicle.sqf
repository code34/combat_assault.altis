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
			private _counter = MEMBER("counter",nil);
			if (isNil "_counter") then {_counter = 0;};
			_counter = _counter + 1;
			MEMBER("counter", _counter);
			if(_counter < 8) exitwith {};
			MEMBER("counter", 0);
			MEMBER("position", _this);
			MEMBER("setType", nil);
			MEMBER("popVehicle", _this);
			MEMBER("setMarker", nil);
			MEMBER("checkAlive", nil);
		};

		PUBLIC FUNCTION("","getType") FUNC_GETVAR("type");
		PUBLIC FUNCTION("","getPosition") FUNC_GETVAR("position");
		PUBLIC FUNCTION("","getVehicle") FUNC_GETVAR("vehicle");

		PUBLIC FUNCTION("array", "popVehicle") {
			private _vehicle = createVehicle [MEMBER("getType", nil), _this, [], 0, "FLY"];
			_vehicle setpos [_this select 0, _this select 1,  500];
			_vehicle setdir (random 360); 
			_vehicle setVelocity [0, 0, 0];
			MEMBER("paraVehicle", _vehicle);
			MEMBER("vehicle", _vehicle);
			["remoteSpawn", ["BME_netcode_client_wcbonusvehicle", _vehicle, "client"]] call server_bme;
		};

		PUBLIC FUNCTION("", "removeVehicle") {
			MEMBER("getVehicle", nil) setdamage 1;
			deletevehicle MEMBER("getVehicle", nil);
		};

		PUBLIC FUNCTION("", "setMarker") {
			private _mark = ["new", [position MEMBER("vehicle", nil), false]] call OO_MARKER;
			["attachTo", MEMBER("vehicle", nil)] spawn _mark;
			private _name= getText (configFile >> "CfgVehicles" >> (typeOf MEMBER("vehicle", nil)) >> "DisplayName");
			["setText", _name] spawn _mark;
			["setColor", "ColorGreen"] spawn _mark;
			["setType", "mil_arrow"] spawn _mark;
			["setSize", [0.8,0.8]] spawn _mark;
			MEMBER("marker", _mark);
		};

		PUBLIC FUNCTION("", "setType") {	
			private _airport = false;
			private _type = "";
			{
				if(MEMBER("position", nil) distance getmarkerpos _x < 1000) then { _airport = true; };
			}foreach ("getAirports" call global_atc);
			
			if(_airport) then {
				_type = selectRandom ["B_Heli_Light_01_F", "B_Heli_Light_01_armed_F", "O_Heli_Light_02_F", "O_Heli_Light_02_unarmed_F", "I_Heli_light_03_F", "I_Heli_light_03_unarmed_F"];
			} else {
				_type = selectRandom ["B_Truck_01_transport_F", "B_APC_Wheeled_01_cannon_F", "B_MBT_01_TUSK_F", "B_MBT_01_cannon_F"];
			};
			MEMBER("type", _type);
		};


		PUBLIC FUNCTION("", "checkAlive") {
			private _counter = 0;
			private _vehicle = MEMBER("getVehicle", nil);
			private _name = "";

			while { ((getDammage _vehicle < 0.9) and (fuel _vehicle > 0.1)) } do {
				if(count crew _vehicle == 0) then { _counter = _counter + 1} else {_counter = 0;};
				if(_counter > 180) then { _vehicle setfuel 0;};
				_name= getText (configFile >> "CfgVehicles" >> (typeOf MEMBER("vehicle", nil)) >> "DisplayName") + format[" - %1", (180 -_counter)];
				["setText", _name] call MEMBER("marker", nil);
				sleep 1;
			}; 
			MEMBER("deconstructor", nil);
		};

		PUBLIC FUNCTION("object", "paraVehicle") {	 	
		 	private _para = createVehicle ["B_parachute_02_F", [0,0,0], [], 0, "FLY"]; 
		 	_para setDir getDir _this; 
		 	_para setPos getPos _this; 
		 	_this attachTo [_para, [0,0,-1]]; 
		 	_this addEventHandler ["HandleDamage", {false}]; 	

		 	[_this, _para] spawn { 
				private _vel = 0;		 		
		 		private _vehicle = _this select 0; 
		 		private _paras = _this select 1;
		 		while { !(getPos _vehicle select 2 < 1) } do {sleep 0.1;};
		 		detach _vehicle;  		 
	 			detach _para; 
	 			_x disableCollisionWith _vehicle; 
		 		sleep 2;
				if (!isNull _para) then {deleteVehicle _para;};
		 		_vehicle removeAllEventHandlers "HandleDamage";
		 		_vehicle setDamage 0;
		 		_vehicle setFuel 1;
		 	};			
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