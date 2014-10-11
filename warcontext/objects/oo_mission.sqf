	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014 Nicolas BOITEUX

	CLASS OO_MISSION
	
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

	CLASS("OO_MISSION")
		PRIVATE VARIABLE("code","marker");
		PRIVATE VARIABLE("object", "target");
		PRIVATE VARIABLE("array", "position");

		PUBLIC FUNCTION("array","constructor") {
			_position = (_this select 0);
			MEMBER("position", _position);

			if(MEMBER("setTarget", nil)) then {
				MEMBER("setMarker", nil);
				MEMBER("destroy", nil);
			};
			MEMBER("deconstructor", nil);
		};

		PUBLIC FUNCTION("","getMarker") FUNC_GETVAR("marker");
		PUBLIC FUNCTION("","getTarget") FUNC_GETVAR("target");

		PUBLIC FUNCTION("", "setTarget") {
			private ["_list", "_target", "_mark", "_return"];
			
			_list = nearestObjects [ MEMBER("position", nil), ["House_F"], 25];
	
			if(count _list > 0) then {
				_target = _list call BIS_fnc_selectRandom;
				MEMBER("target", _target);
				_return = true;
			} else {
				_return = false;
			};
			_return;
		};

		PUBLIC FUNCTION("", "destroy") {
			private ["_counter", "_mark", "_name", "_target", "_win", "_run", "_text"];
			
			_target = MEMBER("target", nil);
			_mark = MEMBER("marker", nil);

			_run = true;
			_win = false;
			
			_counter = 3600;
			_text = "getText" call _mark;

			while { _run } do {
				if(getdammage _target > 0.7) then {
					_run = false;
					_win = true;
				};
				if(_counter < 1) then {
					_run = false;
				};
				_counter = _counter  - 1;
				sleep 1;
			};

			if(_win)	then {
				["expandFriendlyAround", MEMBER("position", nil)] call global_controller;
				["setTicket", "mission"] call global_ticket;
			};
		};		

		PUBLIC FUNCTION("", "setMarker") {
			private ["_mark", "_name", "_target"];

			_target = MEMBER("target", nil);
			_mark = ["new", position _target] call OO_MARKER;
			_name= "Destroy: " + getText (configFile >> "CfgVehicles" >> (typeOf _target) >> "DisplayName");
			["setText", _name] spawn _mark;
			["setColor", "ColorRed"] spawn _mark;
			["setType", "hd_objective"] spawn _mark;
			["setSize", [0.5,0.5]] spawn _mark;
			MEMBER("marker", _mark);
		};		

		PUBLIC FUNCTION("","deconstructor") { 
			["delete", MEMBER("marker", nil)] call OO_MARKER;
			DELETE_VARIABLE("marker");
			DELETE_VARIABLE("position");
			DELETE_VARIABLE("sector");
			DELETE_VARIABLE("target");
		};
	ENDCLASS;