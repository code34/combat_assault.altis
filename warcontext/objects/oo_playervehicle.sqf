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
		PRIVATE VARIABLE("bool","alive");
		
		PUBLIC FUNCTION("array","constructor") {
			private ["_type"];			
			_type = _this select 0;
			MEMBER("type", _type);
			MEMBER("vehicle", objnull);
			MEMBER("alive", false);
		};

		PUBLIC FUNCTION("","getType") FUNC_GETVAR("type");

		PUBLIC FUNCTION("string", "setType") {
			MEMBER("type", _this);
		};

		PUBLIC FUNCTION("", "checkAlive") {
			private ["_counter", "_vehicle"];

			_counter = 0;
			_vehicle = MEMBER("vehicle", nil);
			MEMBER("alive", true);
			while { _counter < 60} do {
				if(count (crew _vehicle) == 0) then { _counter = _counter + 1} else {_counter = 0;};
				if(getDammage _vehicle > 0.9) then { _counter = 60; sleep 120;};
				sleep 1;
			}; 
			MEMBER("alive", false);
			MEMBER("unPop", nil);
		};

		PUBLIC FUNCTION("array", "pop") {
			private ["_vehicle", "_position", "_netid", "_type", "_name"];

			_position = _this select 0;
			_netid = _this select 1;
			_name = _this select 2;
			_type = MEMBER("type", nil);

			if(MEMBER("alive", nil)) exitwith {
				vehicleavalaible = false;
				["vehicleavalaible", "client", _netid] call BME_fnc_publicvariable;
			};
			if(_position distance (getmarkerpos "respawn_west") < 300) exitwith {
				vehicleavalaible = false;
				["vehicleavalaible", "client", _netid] call BME_fnc_publicvariable;
			};
			_vehicle = createVehicle [_type, _position, [], 0, "NONE"];
			
			MEMBER("setHandler", _vehicle);
			MEMBER("vehicle", _vehicle);
			MEMBER("mark", nil);
			MEMBER("checkAlive", nil);
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
			["setType", "b_air"] spawn _mark;
			["setSize", [0.8,0.8]] spawn _mark;
			MEMBER("marker", _mark);
		};

		PUBLIC FUNCTION("", "unMark") {
			["delete", MEMBER("marker", nil)] call OO_MARKER;
		};

		PUBLIC FUNCTION("","deconstructor") { 
			DELETE_VARIABLE("type", nil);
			DELETE_VARIABLE("vehicle", nil);
			DELETE_VARIABLE("marker", nil);
			DELETE_VARIABLE("alive", nil);
		};
	ENDCLASS;