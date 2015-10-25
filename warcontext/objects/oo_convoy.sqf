	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014 Nicolas BOITEUX

	CLASS OO_CONVOY
	
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

	CLASS("OO_CONVOY")
		PRIVATE VARIABLE("object","vehicle");
		PRIVATE VARIABLE("array","startposition");
		PRIVATE VARIABLE("array","endposition");
		PRIVATE VARIABLE("array","escort");
		PRIVATE VARIABLE("code","marker");
		PRIVATE VARIABLE("group","group");

		PUBLIC FUNCTION("array","constructor") {
			private ["_array", "_startposition", "_endposition"];

			_startposition = _this;
			MEMBER("startposition", _startposition);

			_array = [];
			MEMBER("vehicle", _array);
			MEMBER("escort", _array);
			MEMBER("setTarget", _startposition);
			MEMBER("popConvoy", nil);
			MEMBER("popEscort", nil);
		};

		PUBLIC FUNCTION("","getVehicle") FUNC_GETVAR("vehicle");

		PUBLIC FUNCTION("", "startConvoy") {
			private ["_rate", "_vehicle", "_sector", "_text", "_position"];
			
			_array = [MEMBER("endposition", nil), MEMBER("group", nil)];
			MEMBER("moveTo", _array);
			_vehicle = MEMBER("vehicle", nil);

			wcconvoystart = true;
			["wcconvoystart", "client"] call BME_fnc_publicvariable;	

			_rate = 0;
			while { ((damage _vehicle < 0.9) and (alive (driver _vehicle))) } do {
				if(speed _vehicle < 1) then {
					_rate = _rate + 1;
					_text = format["Convoy - Expanding %1", _rate] +"%";
					["setText", _text] spawn MEMBER("marker", nil);
					if(_rate > 99) then {
						_vehicle setdammage 1;
					};
				} else {
					_rate = 0;
					["setText", "Convoy"] spawn MEMBER("marker", nil);
				};
				sleep 1;
			};

			if(_rate > 99) then {
				_sector = ["getSectorFromPos", position _vehicle] call global_grid;
				wcconvoy = true;
				["wcconvoy", "client"] call BME_fnc_publicvariable;				
				["expandSector", _sector] call global_controller;
				["expandSectorAround", [_sector, 10]] call global_controller;
				["setText", "Convoy - Expanding done"] spawn MEMBER("marker", nil);
			} else {
				wcconvoy = false;
				["wcconvoy", "client"] call BME_fnc_publicvariable;				
				["setText", "Convoy - Expanding failed"] spawn MEMBER("marker", nil);
				["setTicket", "convoy"] call global_ticket;
			};
			sleep 60;
			MEMBER("deconstructor", nil);
		};

		PUBLIC FUNCTION("array", "setTarget") {
			private ["_distance", "_endposition", "_markers", "_marker", "_position"];

			_position = _this;

			if(("countWest" call global_atc >  0) and (random 1> 0.25)) then {
				_markers = "getWest" call global_atc;
				_distance = 30000;
				{
					if ((getmarkerpos _x ) distance _position < _distance) then {
						_distance = (getmarkerpos _x ) distance _position;
						_marker = _x;
					};
					sleep 0.0001;
				}foreach _markers;
				_endposition = getmarkerpos _marker;				
			} else {
				_marker = ["RADIOCENTER", "RESEARCHCENTER", "MILITARYDEPOT", "GAZFACTORY", "WEAPONSFACTORY", "POWERRELAY", "BLACKCASTLE", "VEHICLEDEPOT", "POWERPLANT1", "POWERPLANT2", "POWERPLANT3", "POWERPLANT4", "CARGODEPOT", "AGIAPORT", "VEHICLEFACTORY", "URANIUMMINE", "FUELFACTORY", "AGIOSHARBOR", "GSMANTENNA"] call BIS_fnc_selectRandom;
				_endposition = getmarkerpos _marker;	
				//_endposition = [_position, 3000,5000,10,0,2000,0] call BIS_fnc_findSafePos;
			};
			MEMBER("endposition", _endposition);
		};

		PUBLIC FUNCTION("", "popConvoy") {
			private ["_array", "_type", "_position", "_vehicle"];

			_position = MEMBER("startposition", nil);
	
			if(random 1 > 0.5) then {
				_type = ["O_Truck_02_covered_F", "O_Truck_02_transport_F","O_Truck_03_transport_F","O_Truck_03_covered_F","O_Truck_03_repair_F","O_Truck_03_ammo_F","O_Truck_03_fuel_F"] call BIS_fnc_selectRandom;
			} else {
				_type = ["O_APC_Tracked_02_cannon_F","O_APC_Tracked_02_AA_F","O_MBT_02_cannon_F","O_MBT_02_arty_F","O_APC_Wheeled_02_rcws_F","O_APC_Wheeled_02_rcws_F"] call BIS_fnc_selectRandom;
			};

			_position = [_position, 0,50,10,0,2000,0] call BIS_fnc_findSafePos;
			_array = [_position, random 359, _type, east] call bis_fnc_spawnvehicle;

			_vehicle =  _array select 0;
			MEMBER("vehicle", _vehicle);
			MEMBER("group", (_array select 2));

			_mark = ["new", position _vehicle] call OO_MARKER;
			["attachTo", _vehicle] spawn _mark;
			["setText", "Convoy"] spawn _mark;
			["setColor", "ColorRed"] spawn _mark;
			["setType", "mil_arrow"] spawn _mark;
			["setSize", [0.5,0.5]] spawn _mark;
			MEMBER("marker", _mark);
		};


		PUBLIC FUNCTION("", "popEscort") {
			 private ["_array", "_armor", "_group", "_position", "_vehicles", "_units", "_newgroup", "_type", "_leader"];

			 _position = position MEMBER("vehicle", nil);
			 //_group = creategroup east;
			 _group = MEMBER("group", nil);
			 _vehicles = [];

			_armor = ["O_APC_Tracked_02_cannon_F","O_APC_Tracked_02_AA_F","O_MBT_02_cannon_F","O_APC_Wheeled_02_rcws_F","I_APC_Wheeled_03_cannon_F"];

			for "_i" from 1 to 2 step 1 do {
				_type = _armor call BIS_fnc_selectRandom;
				_position = [_position, 25 + random 25, random 360] call BIS_fnc_relPos;
				_array = [_position, random 359, _type, east] call bis_fnc_spawnvehicle;
				_vehicles = _vehicles + [_array select 0];
				_newgroup = _array select 2;
				_leader = leader _newgroup;
				(_array select 1) joinsilent _group;
				deletegroup _newgroup;
				sleep 1;
			};
			_group selectLeader _leader;

			_array = [MEMBER("endposition", nil),  _group];
			MEMBER("moveTo", _array);
			MEMBER("escort", _vehicles);
		};

		PUBLIC FUNCTION("", "unPopEscort") {
			{
				{
					_x setdammage 1;
					deletevehicle _x;
					sleep 0.001;
				}foreach (crew _x);
				_x setdammage 1;
				deletevehicle _x;
				sleep 0.001;
			} foreach MEMBER("escort", nil);
		};


		PUBLIC FUNCTION("", "removeVehicle") {
			{
				_x setdamage 1;
				deletevehicle _x;
				sleep 0.01;
			}foreach units (MEMBER("group", nil));

			MEMBER("getVehicle", nil) setdamage 1;
			deletevehicle MEMBER("getVehicle", nil);
		};

		PUBLIC FUNCTION("array", "moveTo") {
			private ["_group", "_wp", "_position"];

			_position = _this select 0;
			_group = _this select 1;
			
			_wp = _group addwaypoint [_position, 0];
			_wp setWaypointPosition [_position, 5];
			_wp setWaypointType "MOVE";
			_wp setWaypointSpeed "FULL";
			_group setCurrentWaypoint _wp;

			//_mark = ["new", _position] call OO_MARKER;
			//["setText", "Destination convoy"] spawn _mark;
			//["setColor", "ColorRed"] spawn _mark;
			//["setType", "mil_arrow"] spawn _mark;
			//["setSize", [1,1]] spawn _mark;
		};

		PUBLIC FUNCTION("","deconstructor") { 
			["delete", MEMBER("marker", nil)] call OO_MARKER;
			MEMBER("removeVehicle", nil);
			MEMBER("unPopEscort", nil);
			DELETE_VARIABLE("vehicle");
			deletegroup MEMBER("group", nil);
			DELETE_VARIABLE("escort");
			DELETE_VARIABLE("startposition");
			DELETE_VARIABLE("endposition");
			DELETE_VARIABLE("group");
			DELETE_VARIABLE("vehicle");
		};
	ENDCLASS;