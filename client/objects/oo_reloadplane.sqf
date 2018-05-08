	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014-2018 Nicolas BOITEUX

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
		PRIVATE VARIABLE("bool","run");
		PRIVATE VARIABLE("object","vehicle");
		PRIVATE VARIABLE("code","this");
		
		PUBLIC FUNCTION("object","constructor") {
			DEBUG(#, "OO_RELOADPLANE::constructor")
			MEMBER("vehicle", _this);
			"start" call MEMBER("this",nil);
		};

		PUBLIC FUNCTION("", "start") {
			DEBUG(#, "OO_RELOADPLANE::start")
			MEMBER("run", true);
			private _time = 0;
			private _message = false;
			private _vehicle = MEMBER("vehicle", nil);
			private _airports = ["remoteCall", ["BME_netcode_server_getairports", "", "server"]] call global_bme;

			while { MEMBER("run", nil) } do {
				MEMBER("setFuel", nil);
				if(_time > 120) then {
					if!(_message) then {
						MEMBER("airportAvalaibleMessage", nil);
						_message = true;
					};
					{
						if((getmarkerpos _x) distance _vehicle < 300) then {
							if(getMarkerColor _x isEqualTo "ColorBlue") then {
								MEMBER("reFuel", nil);
								MEMBER("reFuelMessage", _x);
								_message = false;
								_time = 0;
							};
						};
						sleep 0.001;
					}foreach _airports;
				};
				if(getDammage _vehicle > 0.9) then { MEMBER("run", false); };
				_time = _time + 1;
				sleep 1;
			};
			MEMBER("deconstructor", nil);
		};

		PUBLIC FUNCTION("", "stop") {
			DEBUG(#, "OO_RELOADPLANE::stop")
			MEMBER("run", false);
		};

		PUBLIC FUNCTION("", "reFuel") {
			DEBUG(#, "OO_RELOADPLANE::reFuel")
			private _vehicle = MEMBER("vehicle", nil);
			_vehicle setVehicleAmmoDef 1;
			_vehicle setdamage 0;
			_vehicle setfuel 1;
		};

		PUBLIC FUNCTION("", "airportAvalaibleMessage") {
			DEBUG(#, "OO_RELOADPLANE::airportAvalaibleMessage")
			_txt =  "<t color='#ff0000'>MESSAGE FROM: Air Traffic Control</t><br />";
			_txt2 = "Come back to Refuel and Reload<br />";
			hint parseText (_txt + _txt2); 
		};

		PUBLIC FUNCTION("string", "reFuelMessage") {
			DEBUG(#, "OO_RELOADPLANE::reFuelMessage")
			private _name = toUpper(_this);
			private _txt =  "<t color='#ff0000'>MESSAGE FROM: "+ _name + " Air Traffic Control</t><br />";
			private _txt2 = "Vehicule Refuel ! Good luck !<br />";
			hint parseText (_txt + _txt2); 
		};

		PUBLIC FUNCTION("", "setFuel") {
			DEBUG(#, "OO_RELOADPLANE::setFuel")
			private _vehicle = MEMBER("vehicle", nil);
			private _fuel = fuel _vehicle;
			private _conso = (speed _vehicle * 0.0005) / 100;
			_vehicle setfuel (_fuel - _conso);
		};

		PUBLIC FUNCTION("","deconstructor") { 
			DEBUG(#, "OO_RELOADPLANE::deconstructor")
			DELETE_VARIABLE("vehicle");
			DELETE_VARIABLE("run");
			DELETE_VARIABLE("this");
		};
	ENDCLASS;