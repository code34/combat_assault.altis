	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014-2018 Nicolas BOITEUX

	CLASS OO_PLAYERVEHICLE
	
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

	CLASS("OO_PLAYERVEHICLE")
		PRIVATE VARIABLE("string","type");
		PRIVATE VARIABLE("object","vehicle");
		PRIVATE VARIABLE("code","marker");
		PRIVATE VARIABLE("scalar","alive");
		
		PUBLIC FUNCTION("string","constructor") {
			DEBUG(#, "OO_PLAYERVEHICLE::constructor")
			MEMBER("type", _this);
			MEMBER("vehicle", objnull);
			MEMBER("alive", 0);
		};

		PUBLIC FUNCTION("","getType") FUNC_GETVAR("type");
		PUBLIC FUNCTION("","getAlive") FUNC_GETVAR("alive");

		PUBLIC FUNCTION("string", "setType") {
			DEBUG(#, "OO_PLAYERVEHICLE::setType")
			MEMBER("type", _this);
		};

		PUBLIC FUNCTION("", "sanity") {
			DEBUG(#, "OO_PLAYERVEHICLE::sanity")
			private _vehicle = MEMBER("vehicle", nil);
			{
				if!(alive _x) then { deletevehicle _x; };
				sleep 0.0001;
			}foreach (crew _vehicle);
			if(count (crew _vehicle) == 0) then { if(damage _vehicle < 0.9) then { _vehicle setdamage 0.91; }; };
		};

		PUBLIC FUNCTION("", "checkAlive") {
			DEBUG(#, "OO_PLAYERVEHICLE::checkAlive")
			private _counter = wcpopplayervehiclecooldown;
			private _vehicle = MEMBER("vehicle", nil);
			while { position _vehicle select 2 > 2} do { sleep 1;};
			sleep 10;
		 	MEMBER("setHandler", _vehicle);

			while { _counter > 1 } do {
				{
					if!(alive _x) then {
						_x action ["Eject", _vehicle];
						deletevehicle _x;
					};
					sleep 0.0001;
				}foreach (crew _vehicle);

				if ( (count (crew _vehicle) == 0) or (damage _vehicle > 0.9) ) then {
					_counter = _counter - 1;
				} else {
					_counter = wcpopplayervehiclecooldown;
				};
				MEMBER("alive", _counter);
				sleep 1;
			}; 
			MEMBER("unPop", nil);
			MEMBER("alive",  0);
		};

		PUBLIC FUNCTION("array", "pop") {
			DEBUG(#, "OO_PLAYERVEHICLE::pop")
			private _position = _this select 0;
			private _netid = _this select 1;
			private _name = _this select 2;
			private _type = MEMBER("type", nil);
			private _vehicle = objNull;
			private _array = [];
			MEMBER("alive", wcpopplayervehiclecooldown);

			switch (true) do {
				case (_type isKindOf "Helicopter") : {
					_position = [[_position select 0, _position select 1], 0,50,1,0,3,0] call BIS_fnc_findSafePos;
					_vehicle = _type createVehicle _position;
					_vehicle setdamage 0;
					["remoteSpawn", ["BME_netcode_client_getInAirVehicle", _vehicle, "client", _netid]] call server_bme;
				};

				case (_type isKindOf "Plane") : {
					_position = [[_position select 0, _position select 1], 0,50,1,0,3,0] call BIS_fnc_findSafePos;
					_position = [_position select 0, _position select 1, 200];
					_array = [_position, 0, _type, west] call bis_fnc_spawnvehicle;
					_vehicle = _array select 0;
					{
						_x setdammage 1;
						deletevehicle _x;
					}foreach units (_array select 2);
					deletegroup (_array select 2);
					_vehicle setdamage 0;
					["remoteSpawn", ["BME_netcode_client_getInAirVehicle", _vehicle, "client", _netid]] call server_bme;
				};

				case (_type isEqualTo "B_supplyCrate_F") : {
					if(_position distance (getMarkerPos "respawn_west") > 300) then {
						_position = [[_position select 0, _position select 1], 0,50,1,0,3,0] call BIS_fnc_findSafePos;
						_vehicle = _type createVehicle [0,0,5000];
						_vehicle setdir (random 360); 
						_vehicle setpos [_position select 0, _position select 1,  150];
						MEMBER("paraVehicle", _vehicle);
						["AmmoboxInit",[_vehicle,true,{true}]] spawn BIS_fnc_arsenal;
					} else {
						_position = ((getMarkerPos "respawn_west") findEmptyPosition [10,60]);
						_vehicle = _type createVehicle _position;
						["AmmoboxInit",[_vehicle,true,{true}]] spawn BIS_fnc_arsenal;
					};
				};

				default {
					//if(_position distance (getMarkerPos "respawn_west") > 300) then {
					//	_position = [[_position select 0, _position select 1], 0,50,1,0,3,0] call BIS_fnc_findSafePos;
					//	_vehicle = createVehicle [_type, [_position select 0, _position select 1,  5000], [], 0, "FLY"];
					//	_vehicle setpos [_position select 0, _position select 1,  150];
					//	_vehicle setdir (random 360); 
					//	_vehicle setVelocity [0, 0, 0];
					//	MEMBER("paraVehicle", _vehicle);
					//} else {
					_position = [[_position select 0, _position select 1], 0,50,1,0,3,0] call BIS_fnc_findSafePos;
					_vehicle = _type createVehicle _position;
					//};
				};
			};
			MEMBER("vehicle", _vehicle);
			MEMBER("createMarker", _vehicle);
			_vehicle;
		};

		PUBLIC FUNCTION("object", "paraVehicle") {
			DEBUG(#, "OO_PLAYERVEHICLE::paraVehicle")	
		 	private _para = createVehicle ["B_parachute_02_F", [0,0,0], [], 0, "FLY"]; 
		 	_para setDir getDir _this; 
		 	_para setPos getPos _this; 
		 	_this attachTo [_para, [0,0,-1]]; 
		 	_this addEventHandler ["HandleDamage", {false}]; 	

		 	[_this, _para] spawn {  		
		 		private _vehicle = _this select 0; 
		 		private _para = _this select 1;
		 		
		 		while { !(getPos _vehicle select 2 < 1) } do {sleep 0.1;};
		 		detach _vehicle; 

	 			detach _para; 
	 			_para disableCollisionWith _vehicle; 
		 		
		 		sleep 2;
		 		if (!isNull _para) then {deleteVehicle _para};
		 		_vehicle removeAllEventHandlers "HandleDamage";
		 		_vehicle setDamage 0;
		 		_vehicle setFuel 1;
		 	};			
		};

		PUBLIC FUNCTION("", "unPop") {
			DEBUG(#, "OO_PLAYERVEHICLE::unPop")	
			deletevehicle MEMBER("vehicle", nil);
			MEMBER("unMark", nil);
		};

		PUBLIC FUNCTION("object", "setHandler") {
			DEBUG(#, "OO_PLAYERVEHICLE::setHandler")	
			_this removeAllEventHandlers "HandleDamage";
			_this addeventhandler ['HandleDamage', {
				if(getdammage (_this select 0) > 0.9) then {
						(_this select 0) setdamage 1;
						(_this select 0) removeAllEventHandlers "HandleDamage";
						{
							_x setdamage 1;
						}foreach (crew (_this select 0));
				};
			}];

			_this addeventhandler ['Hit', {
				if(_this select 2 > 0.30) then {
					(_this select 0) setdamage (getdammage (_this select 0) + random (1));
				};
			}];
		};

		PUBLIC FUNCTION("object", "createMarker") {
			DEBUG(#, "OO_PLAYERVEHICLE::createMarker")	
			private _mark = ["new", [position _this, false]] call OO_MARKER;
			["attachTo", _this] spawn _mark;
			private _name= getText (configFile >> "CfgVehicles" >> (typeOf _this) >> "DisplayName");
			["setText", _name] spawn _mark;
			["setColor", "ColorGreen"] spawn _mark;
			["setType", "b_armor"] spawn _mark;
			["setSize", [1,1]] spawn _mark;
			MEMBER("marker", _mark);
		};

		PUBLIC FUNCTION("", "unMark") {
			DEBUG(#, "OO_PLAYERVEHICLE::unMark")
			["delete", MEMBER("marker", nil)] call OO_MARKER;
		};

		PUBLIC FUNCTION("","deconstructor") { 
			DEBUG(#, "OO_PLAYERVEHICLE::deconstructor")
			MEMBER("unPop", _vehicle);
			DELETE_VARIABLE("type");
			DELETE_VARIABLE("vehicle");
			DELETE_VARIABLE("marker");
			DELETE_VARIABLE("alive");
		};
	ENDCLASS;