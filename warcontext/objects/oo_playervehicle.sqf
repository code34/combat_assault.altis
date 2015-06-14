	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014 Nicolas BOITEUX

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
		PRIVATE VARIABLE("bool","para");
		
		PUBLIC FUNCTION("array","constructor") {
			MEMBER("type", _this select 0);
			MEMBER("para", _this select 1);
			MEMBER("vehicle", objnull);
			MEMBER("alive", 0);
		};

		PUBLIC FUNCTION("","getType") FUNC_GETVAR("type");
		PUBLIC FUNCTION("","getAlive") FUNC_GETVAR("alive");

		PUBLIC FUNCTION("string", "setType") {
			MEMBER("type", _this);
		};

		PUBLIC FUNCTION("bool", "setPara") {
			MEMBER("para", _this);
		};		

		PUBLIC FUNCTION("", "sanity") {
			private ["_vehicle"];

			_vehicle = MEMBER("vehicle", nil);
			if(count (crew _vehicle) == 0) then {
				if(damage _vehicle < 0.9) then {
					_vehicle setdamage 0.91;
				};
			};
		};

		PUBLIC FUNCTION("", "checkAlive") {
			private ["_counter", "_vehicle"];

			_counter = 240;
			_vehicle = MEMBER("vehicle", nil);

			while { position _vehicle select 2 > 2} do { sleep 1;};
			sleep 10;
		 	MEMBER("setHandler", _vehicle);

			while { _counter > 1 } do {
				if(count (crew _vehicle) == 0) then { _counter = _counter - 1;} else {_counter = 240;};
				if(getDammage _vehicle > 0.9) then { _counter = _counter - 1;};
				MEMBER("alive", _counter);
				sleep 1;
			}; 
			MEMBER("unPop", nil);
			MEMBER("alive",  0);
		};

		PUBLIC FUNCTION("array", "pop") {
			private ["_vehicle", "_position", "_netid", "_type", "_name"];

			_position = _this select 0;
			_netid = _this select 1;
			_name = _this select 2;
			_type = MEMBER("type", nil);
			MEMBER("alive", 240);
			
			switch (_type) do {
				case "B_Heli_Transport_01_camo_F" : {
					_position = [[_position select 0, _position select 1], 0,50,1,0,3,0] call BIS_fnc_findSafePos;
					_vehicle = _type createVehicle _position;

					_vehicle setdamage 0;
					vehiclegetin = _vehicle;
					["vehiclegetin", "client", _netid] call BME_fnc_publicvariable;
				};
				case "B_Heli_Attack_01_F" : {
					_position = [[_position select 0, _position select 1], 0,50,1,0,3,0] call BIS_fnc_findSafePos;
					_vehicle = _type createVehicle _position;

					_vehicle setdamage 0;
					vehiclegetin = _vehicle;
					["vehiclegetin", "client", _netid] call BME_fnc_publicvariable;
				};
				case "B_Plane_CAS_01_F" : {
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
					vehiclegetin = _vehicle;
					["vehiclegetin", "client", _netid] call BME_fnc_publicvariable;
				};
				case "I_Plane_Fighter_03_AA_F" : {
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
					vehiclegetin = _vehicle;
					["vehiclegetin", "client", _netid] call BME_fnc_publicvariable;
				};
				case "B_MBT_01_cannon_F" : {
					_position = [[_position select 0, _position select 1], 0,50,1,0,3,0] call BIS_fnc_findSafePos;
					_vehicle = _type createVehicle [0,0,5000];
					_vehicle setdir (random 360); 

					_vehicle setpos [_position select 0, _position select 1,  150];
					MEMBER("paraVehicle", _vehicle);
				};
				case "B_APC_Tracked_01_AA_F" : {
					_position = [[_position select 0, _position select 1], 0,50,1,0,3,0] call BIS_fnc_findSafePos;
					_vehicle = _type createVehicle [0,0,5000];
					_vehicle setdir (random 360); 

					_vehicle setpos [_position select 0, _position select 1,  150];
					MEMBER("paraVehicle", _vehicle);
				};
				case "B_supplyCrate_F" : {
					_position = [[_position select 0, _position select 1], 0,50,1,0,3,0] call BIS_fnc_findSafePos;
					_vehicle = _type createVehicle [0,0,5000];
					_vehicle setdir (random 360); 

					_vehicle setpos [_position select 0, _position select 1,  150];
					MEMBER("paraVehicle", _vehicle);
					["AmmoboxInit",[_vehicle,true,{true}]] spawn BIS_fnc_arsenal;
				};
				default {
					_position = [[_position select 0, _position select 1], 0,50,1,0,3,0] call BIS_fnc_findSafePos;
					_vehicle = _type createVehicle [0,0,5000];
					_vehicle setdir (random 360); 

					_vehicle setpos [_position select 0, _position select 1,  150];
					MEMBER("paraVehicle", _vehicle);
				};
			};	
			
			MEMBER("vehicle", _vehicle);
			MEMBER("mark", nil);
			_vehicle;
		};

		PUBLIC FUNCTION("object", "paraVehicle") {
		 	private ["_para","_paras","_p"]; 
		 	
		 	_para = createVehicle ["B_parachute_02_F", [0,0,0], [], 0, "FLY"]; 
		 	_para setDir getDir _this; 
		 	_para setPos getPos _this; 
		 	_paras = [_para]; 
		 	_this attachTo [_para, [0,0,-1]]; 
		 	_this addEventHandler ["HandleDamage", {false}]; 	

		 	[_this, _paras] spawn { 
		 		private ["_vehicle", "_vel", "_paras"];
		 		
		 		_vehicle = _this select 0; 
		 		_paras = _this select 1;
		 		
		 		while { !(getPos _vehicle select 2 < 3) } do {sleep 0.1;};

		 		detach _vehicle; 

		 		{ 
		 			detach _x; 
		 			_x disableCollisionWith _vehicle; 
		 		} count _paras; 
		 		
		 		sleep 2;
		 		{ if (!isNull _x) then {deleteVehicle _x};} count _paras; 
		 		_vehicle removeAllEventHandlers "HandleDamage";
		 	};			
		};

		PUBLIC FUNCTION("", "unPop") {
			private ["_vehicle"];
			_vehicle = MEMBER("vehicle", nil);
			waituntil { count (crew _vehicle) == 0};
			deletevehicle _vehicle;
			MEMBER("unMark", nil);
		};

		PUBLIC FUNCTION("object", "setHandler") {
			private ["_vehicle"];
			_vehicle = _this;
			_vehicle removeAllEventHandlers "HandleDamage";
			_vehicle addeventhandler ['HandleDamage', {
				if(getdammage (_this select 0) > 0.9) then {
						(_this select 0) setdamage 1;
						(_this select 0) removeAllEventHandlers "HandleDamage";
						{
							_x setdamage 1;
						}foreach (crew (_this select 0));
				};
			}];

			_vehicle addeventhandler ['Hit', {
				if(_this select 2 > 0.30) then {
					(_this select 0) setdamage (getdammage (_this select 0) + random (1));
				};
			}];
		};

		PUBLIC FUNCTION("", "mark") {
			private ["_vehicle", "_mark", "_position"];
			
			_vehicle = MEMBER("vehicle", nil);
			_position = position _vehicle;

			_mark = ["new", _position] call OO_MARKER;
			["attachTo", _vehicle] spawn _mark;
			_name= getText (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "DisplayName");
			["setText", _name] spawn _mark;
			["setColor", "ColorGreen"] spawn _mark;
			["setType", "b_armor"] spawn _mark;
			["setSize", [1,1]] spawn _mark;
			MEMBER("marker", _mark);
		};

		PUBLIC FUNCTION("", "unMark") {
			["delete", MEMBER("marker", nil)] call OO_MARKER;
		};

		PUBLIC FUNCTION("","deconstructor") { 
			DELETE_VARIABLE("type");
			DELETE_VARIABLE("vehicle");
			DELETE_VARIABLE("marker");
			DELETE_VARIABLE("alive");
			DELETE_VARIABLE("para");
		};
	ENDCLASS;