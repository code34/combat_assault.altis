	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014 Nicolas BOITEUX

	CLASS OO_RELOADPLANE
	
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

	CLASS("OO_RELOADPLANE")
		PRIVATE VARIABLE("scalar","contacttime");
		PRIVATE VARIABLE("scalar","time");
		PRIVATE VARIABLE("scalar","state");
		PRIVATE VARIABLE("string","airport");
		PRIVATE VARIABLE("bool","run");

		PUBLIC FUNCTION("array","constructor") {
			MEMBER("time", 0);
			MEMBER("contacttime", 0);
			MEMBER("state", 0);
			MEMBER("airport", "air1");
			MEMBER("run", false);
		};

		PUBLIC FUNCTION("","getReloadTime") FUNC_GETVAR("time");

		PUBLIC FUNCTION("", "start") {
			MEMBER("run", true);
			while { MEMBER("run", nil) } do {
				INC_VAR("time");
				if(MEMBER("needFuel", nil)) then {
					if(MEMBER("state", nil) == 0) then {
						MEMBER("state", 1);
						MEMBER("getAirPort", nil);
					};
					MEMBER("setContactTime", nil);
					if(MEMBER("getContactTime", nil) < 1) then {
						(vehicle player) setVehicleAmmoDef 1;
						(vehicle player) setdamage 0;
						(vehicle player) setfuel 1;
						MEMBER("fightingMessage", nil);
						MEMBER("time", 0);
						MEMBER("state", 0);
					} else {
						MEMBER("landingMessage", nil);
					};
				};
				MEMBER("setFuel", nil);
				sleep 1;
			};
			MEMBER("deconstructor", nil);
		};

		PUBLIC FUNCTION("", "stop") {
			MEMBER("run", false);
		};

		PUBLIC FUNCTION("", "needFuel") {
			if(fuel(vehicle player) < 0.4) then {true;} else {false;};
		};

		PUBLIC FUNCTION("", "setFuel") {
			private ["_vehicle", "_fuel"];
			_vehicle = vehicle player;
			_fuel = fuel _vehicle;
			if(speed _vehicle > 200) then {
				_vehicle setfuel (_fuel - 0.002);
			};
			if(speed _vehicle > 350) then {
				_vehicle setfuel (_fuel - 0.003);
			};
			if(speed _vehicle > 500) then {
				_vehicle setfuel (_fuel - 0.007);
			};
			if(speed _vehicle > 600) then {
				_vehicle setfuel (_fuel - 0.01);
			};
		};

		PUBLIC FUNCTION("", "getAirPort") {
			private ["_distance", "_airport"];
			_distance = 100000;
			_airport = "";
			{
				if((getmarkerpos _x) distance player < _distance) then {
					_distance = (getmarkerpos _x) distance player;
					_airport = _x;
				};
				sleep 0.001;
			}foreach ["air1", "air2"];
			MEMBER("airport", _airport);
		};

		PUBLIC FUNCTION("", "getContactTime") {
			MEMBER("contacttime", nil);
		};

		PUBLIC FUNCTION("", "setContactTime") {
			private ["_distance", "_time"];
			_distance = player distance (getmarkerpos MEMBER("airport",nil));
			_time = round(_distance / (speed player));
			MEMBER("contacttime", _time);
		};

		PUBLIC FUNCTION("", "landingMessage") {
			private ["_name", "_time"];

			if(MEMBER("airport",nil) == "air1") then { 
				_name = "CROCODILE";
				0 setAirportSide east;
				1 setAirportSide west;
				2 setAirportSide east;
				3 setAirportSide east;
				4 setAirportSide east;
				5 setAirportSide east;
			};

			if(MEMBER("airport",nil) == "air2") then { 
				_name = "COCONUTS";
				0 setAirportSide west;
				1 setAirportSide east;
				2 setAirportSide east;
				3 setAirportSide east;
				4 setAirportSide east;
				5 setAirportSide east;
			};
	
			_time = format["%1 sec", MEMBER("contacttime", nil)];

			_txt =  "<t color='#ff0000'>MESSAGE FROM: "+ _name + " Air Traffic Control</t><br />";
			_txt2 = "Come back to Refuel and Reload<br />";
			_txt3 = "Average contact time: "+ _time + "<br />";
			hint parseText (_txt + _txt2 + _txt3); 
		};

		PUBLIC FUNCTION("", "fightingMessage") {
			private ["_name"];
			if(MEMBER("airport",nil) == "air1") then { _name = "CROCODILE";};
			if(MEMBER("airport",nil) == "air2") then { _name = "COCONUTS";};
	
			_txt =  "<t color='#ff0000'>MESSAGE FROM: "+ _name + " Air Traffic Control</t><br />";
			_txt2 = "Vehicule Refuel ! Good luck !<br />";
			hint parseText (_txt + _txt2); 
		};

		PUBLIC FUNCTION("","deconstructor") { 
			DELETE_VARIABLE("run");
			DELETE_VARIABLE("contacttime");
			DELETE_VARIABLE("time");
			DELETE_VARIABLE("state");
			DELETE_VARIABLE("airport");
		};
	ENDCLASS;