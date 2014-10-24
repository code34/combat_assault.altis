	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014 Nicolas BOITEUX

	CLASS OO_TICKET
	
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

	CLASS("OO_TICKET")
		PRIVATE VARIABLE("scalar","ticket");
		PRIVATE VARIABLE("bool","active");

		PUBLIC FUNCTION("array","constructor") {
			MEMBER("ticket", 1000);
			MEMBER("active", false);
		};

		PUBLIC FUNCTION("","getTicket") FUNC_GETVAR("ticket");
		PUBLIC FUNCTION("","getActive") FUNC_GETVAR("active");

		PUBLIC FUNCTION("scalar", "add"){
			_value = MEMBER("ticket", nil) + _this;
			MEMBER("ticket", _value);
		};

		PUBLIC FUNCTION("bool", "setActive"){
			MEMBER("active", _this);
		};

		PUBLIC FUNCTION("string", "setTicket"){
			private ["_type", "_credit", "_value", "_ticket"];
			
			if!(MEMBER("active", nil)) exitwith {};

			_type = _this;
			_credit = MEMBER("getCredit", _type);

			MEMBER("add", _credit);
			_ticket = MEMBER("ticket", nil);

			if(_ticket > 0) then {
				_value = [_ticket, _type, _credit];
				MEMBER("send", _value);
			} else {
				end = "loose";
				["end", "client"] call BME_fnc_publicvariable;
				["epicFail",false,2] call BIS_fnc_endMission;
			};
		};

		PUBLIC FUNCTION("array", "send"){
			wcticket = _this;
			["wcticket", "client"] call BME_fnc_publicvariable;
		};

		PUBLIC FUNCTION("string", "getCredit"){
			private ["_type", "_credit"];

			_type = _this;
			switch (_type) do { 
				case "chopper": {
					_credit = -3;
				};
				case "tank": {
					_credit = -3;
				};
				case "tankaa": {
					_credit = -3;
				};				
				case "fighter": {
					_credit = -5;
				};
				case "bomber": {
					_credit = -5;
				};				
				case "soldier": {
					_credit = -1;
				};
				case "bluezone": {
					_credit = 10;
				};
				case "redzone": {
					_credit = -10;
				};
				case "convoy": {
					_credit = 20;
				};			
				case "mission": {
					_credit = 30;
				};
				default {
					_credit = -1;
				};
			};
			_credit;
		};

		PUBLIC FUNCTION("","deconstructor") { 
			DELETE_VARIABLE("active");
			DELETE_VARIABLE("ticket");
		};
	ENDCLASS;