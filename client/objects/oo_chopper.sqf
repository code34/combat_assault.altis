	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014 Nicolas BOITEUX

	CLASS OO_CHOPPER
	
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

	CLASS("OO_CHOPPER")
		PRIVATE VARIABLE("string","type");
		PRIVATE VARIABLE("object","chopper");
		PRIVATE VARIABLE("code","marker");
		PRIVATE VARIABLE("bool","alive");
		
		PUBLIC FUNCTION("array","constructor") {
			_type = "B_Heli_Transport_01_camo_F";	
			MEMBER("type", _type);
			MEMBER("chopper", objnull);
		};

		PUBLIC FUNCTION("", "checkAlive") {
			private ["_counter", "_chopper"];

			_counter = 0;
			_chopper = MEMBER("chopper", nil);
			MEMBER("alive", true);
			while { _counter < 60} do {
				if(count (crew _chopper) == 0) then { _counter = _counter + 1} else {_counter = 0;};
				if(getDammage _chopper > 0.9) then { _counter = 60; sleep 10;};
				sleep 1;
			}; 
			MEMBER("alive", false);
			MEMBER("unPop", nil);
		};		

		PUBLIC FUNCTION("array", "popInAir") {
			private ["_array", "_position", "_chopper", "_type"];

			_position = _this;
			_type = MEMBER("type", nil);
			_array = [_position, 0, _type, west] call bis_fnc_spawnvehicle;
			_chopper = _array select 0;
			MEMBER("chopper", _chopper);
			MEMBER("mark", _position);

			_chopper removeAllEventHandlers "HandleDamage";
			_chopper addeventhandler ['HandleDamage', {
				if(getDammage (_this select 0) > 0.9) then {
						(_this select 0) setdamage 1;
						(_this select 0) removeAllEventHandlers "HandleDamage";
						{
							_x setdamage 1;
						}foreach (crew (_this select 0));
				};
			}];

			{
				_x setdammage 1;
				deletevehicle _x;
			}foreach units (_array select 2);
			deletegroup (_array select 2);
			_chopper;
		};

		PUBLIC FUNCTION("array", "pop") {
			private ["_chopper", "_position"];
			_position = _this;
			if(MEMBER("alive", nil)) exitwith {
				["hint", ["Chopper servicing", "chopper is not yet avalaible"]] call hud;
			};
			_position = _this;
			_chopper = createVehicle ["B_Heli_Transport_01_camo_F", _position, [], 0, "NONE"];
			MEMBER("chopper", _chopper);
			MEMBER("mark", _position);
		};

		PUBLIC FUNCTION("", "unPop") {
			private ["_chopper"];
			_chopper = MEMBER("chopper", nil);
			waituntil { count (crew _chopper) == 0};
			deletevehicle _chopper;
			MEMBER("unMark", nil);
		};

		PUBLIC FUNCTION("array", "mark") {
			private ["_chopper", "_mark", "_position"];
			
			_position = _this;
			_chopper = MEMBER("chopper", nil);

			_mark = ["new", _position] call OO_MARKER;
			["attachTo", _chopper] spawn _mark;
			["setShape", "ELLIPSE"] spawn _mark;
			["setText",  typeof _chopper] spawn _mark;
			["setColor", "ColorBlue"] spawn _mark;
			["setSize", [150,150]] spawn _mark;
			MEMBER("marker", _mark);
		};

		PUBLIC FUNCTION("", "unMark") {
			["delete", MEMBER("marker", nil)] call OO_MARKER;
		};

		PUBLIC FUNCTION("","deconstructor") { 
			DELETE_VARIABLE("type", nil);
			DELETE_VARIABLE("chopper", nil);
			DELETE_VARIABLE("marker", nil);
		};
	ENDCLASS;