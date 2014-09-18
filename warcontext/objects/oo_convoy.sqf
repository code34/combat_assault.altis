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
		PRIVATE VARIABLE("code","marker");
		PRIVATE VARIABLE("group","group");
		PRIVATE VARIABLE("code","grid");

		PUBLIC FUNCTION("array","constructor") {
			private ["_array", "_startposition", "_endposition", "_grid"];

			_grid = ["new", [31000,31000,100,100]] call OO_GRID;
			MEMBER("grid", _grid);

			_startposition = _this;
			_endposition = [_startposition, 3000,5000,10,0,2000,0] call BIS_fnc_findSafePos;		

			MEMBER("startposition", _startposition);
			MEMBER("endposition", _endposition);

			_array = [];
			MEMBER("vehicle", _array);
			MEMBER("popSupport", nil);
		};

		PUBLIC FUNCTION("","getVehicle") FUNC_GETVAR("vehicle");

		PUBLIC FUNCTION("", "startConvoy") {
			private ["_rate", "_vehicle", "_sector", "_text"];
			MEMBER("moveTo", nil);
			_vehicle = MEMBER("vehicle", nil);

			_rate = 0;
			while { ((damage _vehicle < 0.9) and (alive (driver _vehicle))) } do {
				if(speed _vehicle < 1) then {
					_rate = _rate + 1;
					_text = format["Support - Expanding %1", _rate] +"%";
					["setText", _text] spawn MEMBER("marker", nil);

					if(_rate > 99) then {
						_vehicle setdammage 1;
						_sector = ["getSectorFromPos", position _vehicle] call MEMBER("grid", nil);
						["expandSector", _sector] call global_controller;
						["expandSectorAround", _sector] call global_controller;
					};
				} else {
					_rate = 0;
					["setText", "Support"] spawn MEMBER("marker", nil);
				};
				sleep 1;
			};
			if(_rate > 99) then {
				["setText", "Support - Expanding done"] spawn MEMBER("marker", nil);
			} else {
				["setText", "Support - Expanding failed"] spawn MEMBER("marker", nil);
			};
			sleep 5;
			MEMBER("deconstructor", nil);
		};

		PUBLIC FUNCTION("", "popSupport") {
			private ["_array", "_type", "_position", "_vehicle"];

			_position = MEMBER("startposition", nil);
	
			if(random 1 > 0.5) then {
				_type = ["O_Truck_02_covered_F", "O_Truck_02_transport_F","O_Truck_03_transport_F","O_Truck_03_covered_F","O_Truck_03_repair_F","O_Truck_03_ammo_F","O_Truck_03_fuel_F"] call BIS_fnc_selectRandom;
			} else {
				_type = ["O_APC_Tracked_02_cannon_F","O_APC_Tracked_02_AA_F","O_MBT_02_cannon_F","O_MBT_02_arty_F","O_APC_Wheeled_02_rcws_F","I_APC_Wheeled_03_cannon_F"] call BIS_fnc_selectRandom;
			};

			_position = [_position, 0,50,10,0,2000,0] call BIS_fnc_findSafePos;
			_array = [_position, random 359, _type, east] call bis_fnc_spawnvehicle;

			_vehicle =  _array select 0;
			MEMBER("vehicle", _vehicle);
			MEMBER("group", (_array select 2));

			_mark = ["new", position _vehicle] call OO_MARKER;
			["attachTo", _vehicle] spawn _mark;
			["setText", "Support"] spawn _mark;
			["setColor", "ColorRed"] spawn _mark;
			["setType", "mil_arrow"] spawn _mark;
			["setSize", [0.5,0.5]] spawn _mark;
			MEMBER("marker", _mark);
		};

		// armor
		//_armor = ["O_APC_Tracked_02_cannon_F","O_APC_Tracked_02_AA_F","O_MBT_02_cannon_F","O_MBT_02_arty_F","O_APC_Wheeled_02_rcws_F","I_APC_Wheeled_03_cannon_F"];
		//for "_i" from 1 to 2 step 1 do {
		//	_type = _armor call BIS_fnc_selectRandom;
		//	_position = [_position, 0,50,10,0,2000,0] call BIS_fnc_findSafePos;
		//	_array = [_position, random 359, _type, east] call bis_fnc_spawnvehicle;
		//};


		PUBLIC FUNCTION("", "removeVehicle") {
			{
				_x setdamage 1;
				deletevehicle _x;
			}foreach units (MEMBER("group", nil));

			MEMBER("getVehicle", nil) setdamage 1;
			deletevehicle MEMBER("getVehicle", nil);
		};

		PUBLIC FUNCTION("", "moveTo") {
			private ["_group", "_wp", "_position"];

			_group = MEMBER("group", nil);
			_position = MEMBER("endposition", nil);

			_wp = _group addwaypoint [_position, 0];
			_wp setWaypointPosition [_position, 5];
			_wp setWaypointType "MOVE";
			_wp setWaypointSpeed "FULL";
			_group setCurrentWaypoint _wp;
		};

		PUBLIC FUNCTION("","deconstructor") { 
			["delete", MEMBER("marker", nil)] call OO_MARKER;
			MEMBER("removeVehicle", nil);
			DELETE_VARIABLE("vehicle");
			deletegroup MEMBER("group", nil);
			DELETE_VARIABLE("startposition");
			DELETE_VARIABLE("endposition");
			DELETE_VARIABLE("group");
			DELETE_VARIABLE("grid");
			DELETE_VARIABLE("vehicle");
		};
	ENDCLASS;