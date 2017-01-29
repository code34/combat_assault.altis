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
			private ["_position", "_random"];

			_position = (_this select 0);
			MEMBER("position", _position);
			_type = ["destroy", "rescue", "rob", "weaponCache", "getMen", "bring"] call BIS_fnc_selectRandom;
			MEMBER(_type, _position);
			MEMBER("deconstructor", nil);
		};

		PUBLIC FUNCTION("","getMarker") FUNC_GETVAR("marker");
		PUBLIC FUNCTION("","getTarget") FUNC_GETVAR("target");

		PUBLIC FUNCTION("", "checkTarget") {
			private ["_list", "_target", "_return", "_targets"];
			
			_targets = ["Land_Lighthouse_small_F", "Land_Airport_Tower_F", "Land_Hangar_F", "Land_dp_bigTank_F", "Land_dp_mainFactory_F", "Land_dp_smallTank_F", "Land_dp_transformer_F", "Land_Factory_Main_F", "Land_FuelStation_Feed_F", "Land_fs_feed_F", "Land_IndPipe1_ground_F", "Land_HighVoltageEnd_F", "Land_HighVoltageTower_F", "Land_HighVoltageTower_largeCorner_F", "Land_ReservoirTank_Airport_F", "Land_ReservoirTank_V1_F", "Land_ReservoirTower_F", "Land_Tank_rust_F", "Land_TTowerBig_1_F", "Land_TBox_F", "Land_TTowerBig_2_F", "MetalBarrel_burning_F", "Land_MetalBarrel_F", "Land_Cargo_House_V1_F", "Land_Cargo_House_V2_F", "Land_Cargo_House_V3_F", "Land_Cargo_HQ_V1_F", "Land_Cargo_HQ_V2_F", "Land_Cargo_HQ_V3_F", "Land_Cargo_Patrol_V1_F", "Land_Cargo_Patrol_V2_F", "Land_Cargo_Patrol_V3_F", "Land_Cargo_Tower_V1_F", "Land_Cargo_Tower_V2_F", "Land_Cargo_Tower_V3_F", "Land_Radar_F", "Land_MilOffices_V1_F", "Land_Radar_Small_F", "Land_Dome_Small_F", "Land_Research_house_V1_F", "Land_Research_HQ_F", "Land_Offices_01_V1_F", "Land_dp_mainFactory_F", "Land_dp_smallFactory_F", "Land_Factory_Main_F", "Land_PowerLine_distributor_F", "Land_i_Shed_Ind_F", "Land_TTowerSmall_2_F"];

			_list = nearestObjects [ MEMBER("position", nil), _targets, 50];
			sleep 1;

			if(count _list > 0) then {
				_target = _list call BIS_fnc_selectRandom;
				MEMBER("target", _target);
				_return = true;
			} else {
				_return = false;
			};
			_return;
		};

		PUBLIC FUNCTION("object", "sizeBuilding") {
			private ["_index", "_building"];
			_building = _this;
			
			_index = 0;
			while { format ["%1", _building buildingPos _index] != "[0,0,0]" } do {
				_index = _index + 1;
				sleep 0.01;
			};
			_index;
		};

		PUBLIC FUNCTION("array", "destroy") {
			private ["_counter", "_mark", "_name", "_target", "_win", "_run", "_text", "_position"];

			_position = _this;
		
			if! (MEMBER("checkTarget", nil)) then {
				_target = ["Land_Lighthouse_small_F", "Land_Airport_Tower_F", "Land_Hangar_F", "Land_dp_bigTank_F", "Land_dp_mainFactory_F", "Land_dp_smallTank_F", "Land_dp_transformer_F", "Land_Factory_Main_F", "Land_fs_feed_F", "Land_IndPipe1_ground_F", "Land_HighVoltageEnd_F", "Land_HighVoltageTower_F", "Land_HighVoltageTower_largeCorner_F", "Land_ReservoirTank_Airport_F", "Land_ReservoirTank_V1_F", "Land_ReservoirTower_F", "Land_Tank_rust_F", "Land_TTowerBig_1_F", "Land_TBox_F", "Land_TTowerBig_2_F", "MetalBarrel_burning_F", "Land_MetalBarrel_F", "Land_Cargo_House_V1_F", "Land_Cargo_House_V2_F", "Land_Cargo_House_V3_F", "Land_Cargo_HQ_V1_F", "Land_Cargo_HQ_V2_F", "Land_Cargo_HQ_V3_F", "Land_Cargo_Patrol_V1_F", "Land_Cargo_Patrol_V2_F", "Land_Cargo_Patrol_V3_F", "Land_Cargo_Tower_V1_F", "Land_Cargo_Tower_V2_F", "Land_Cargo_Tower_V3_F", "Land_Radar_F", "Land_MilOffices_V1_F", "Land_Radar_Small_F", "Land_Dome_Small_F", "Land_Research_house_V1_F", "Land_Research_HQ_F", "Land_Offices_01_V1_F", "Land_dp_mainFactory_F", "Land_dp_smallFactory_F", "Land_Factory_Main_F", "Land_PowerLine_distributor_F", "Land_i_Shed_Ind_F", "Land_TTowerSmall_2_F"] call BIS_fnc_selectRandom;
				{ _x hideObjectGlobal true } foreach (nearestTerrainObjects [_position,[], 50]);
				_target = _target createVehicle (_position findEmptyPosition [0, 50]);
				MEMBER("target", _target);
			} else {
				_target = MEMBER("target", nil);
			};

			_text= "Destroy " + getText (configFile >> "CfgVehicles" >> (typeOf _target) >> "DisplayName");
			MEMBER("setMarker", _text);

			_mark = MEMBER("marker", nil);

			_run = true;
			_win = false;
			
			_counter = 3600;
			//_text = "getText" call _mark;

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
				wcmissioncompleted = [true, _text];
				["wcmissioncompleted", "client"] call BME_fnc_publicvariable;
			} else {
				wcmissioncompleted = [false, _text];
				["wcmissioncompleted", "client"] call BME_fnc_publicvariable;
			};
		};

		PUBLIC FUNCTION("array", "weaponCache") {
			private ["_type", "_position", "_run", "_counter", "_text", "_win", "_vehicle"];

			_position = _this;
			_position = [_position, 0, 50, 1, 0, 3, 0 ] call BIS_fnc_findSafePos;
			
			_type = "Box_FIA_Wps_F";

			_vehicle = createVehicle [_type, _position,[], 0, "NONE"];
			MEMBER("target", _vehicle);

			_counter = 3600;
			_run = true;

			_text= "Destroy " + getText (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "DisplayName");
			MEMBER("setMarker", _text);	
			_win = false;

			while { _run } do {
				if(getdammage _vehicle > 0.7) then {
					_run = false;
					_win = true;
				};
				if(_position distance _vehicle > 200) then {
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
				["setTicket", "mission"] call global_ticket;
				wcmissioncompleted = [true, _text];
				["wcmissioncompleted", "client"] call BME_fnc_publicvariable;
				while { count crew _vehicle > 0} do {
					sleep 30;
				};
			} else {
				wcmissioncompleted = [false, _text];
				["wcmissioncompleted", "client"] call BME_fnc_publicvariable;
			};
			deletevehicle _vehicle;
		};

		PUBLIC FUNCTION("array", "bring") {
			private ["_position", "_run", "_vehicle", "_list", "_supply", "_text"];

			_position = _this;
			_supply = ceil (random 100);

			_position = [_position, 0, 50, 1, 0, 3, 0 ] call BIS_fnc_findSafePos;

			_vehicle = createVehicle ["Land_FuelStation_Shed_F", _position,[], 0, "NONE"];
			_position = position _vehicle;
			MEMBER("target", _vehicle);
			MEMBER("setMarker", localize "STR_SUPPLYFULL");

			_run = true;
			while { _run } do {
				if(damage _vehicle > 0.9) then {
					_run = false;
				};
			
				if(_supply < 20 ) then {
					_text = localize "STR_SUPPLYEMPTY";
				} else {
					_text = localize "STR_SUPPLYFULL";
				};
				["setText", _text] spawn MEMBER("marker", nil);

				_list = nearestObjects [_position, ["TRUCK", "CAR"], 25];
				sleep 1;
				if(count _list > 0) then { 
					{
						if(_x getvariable ["isenemy", false]) then {
							_x setVariable ["isenemy", false];
							_text= "Bring completed: " + getText (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "DisplayName");
							["setTicket", "mission"] call global_ticket;
							wcmissioncompleted = [true, _text];
							["wcmissioncompleted", "client"] call BME_fnc_publicvariable;
							_supply = 100;
						} else {
							if(_supply > 20) then {
								_x call WC_fnc_servicing;
								_supply = _supply - 20;
							};
						};
						sleep 0.01;
					} foreach _list;
				};
			};
		};		

		PUBLIC FUNCTION("array", "rob") {
			private ["_type", "_position", "_run", "_counter", "_text", "_win", "_vehicle", "_count"];

			_position = _this;
			_position = [_position, 0, 50, 1, 0, 3, 0 ] call BIS_fnc_findSafePos;
			
			_type = ["O_Truck_02_covered_F", "O_Truck_02_transport_F","O_Truck_03_transport_F","O_Truck_03_covered_F","O_Truck_03_repair_F","O_Truck_03_ammo_F","O_Truck_03_fuel_F"] call BIS_fnc_selectRandom;

			_vehicle = createVehicle [_type, _position,[], 0, "NONE"];
			_vehicle setvariable ["isenemy", true];

			MEMBER("target", _vehicle);

			_counter = 3600;
			_run = true;

			_text= "Rob " + getText (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "DisplayName");
			MEMBER("setMarker", _text);	
			_win = false;

			while { _run } do {
				if(getdammage _vehicle > 0.7) then {
					_run = false;
				};
				if(_position distance _vehicle > 500) then {
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
				["setTicket", "mission"] call global_ticket;
				wcmissioncompleted = [true, _text];
				["wcmissioncompleted", "client"] call BME_fnc_publicvariable;
				while { count crew _vehicle > 0} do {
					sleep 30;
				};
			} else {
				wcmissioncompleted = [false, _text];
				["wcmissioncompleted", "client"] call BME_fnc_publicvariable;
			};

			_counter = 0;

			while { _counter < 360 } do {
				if(count (crew _vehicle) == 0) then {
					_counter = _counter + 1;
				} else {
					_counter = 0;
				};
				sleep 1;
			};
			deletevehicle _vehicle;
		};

		PUBLIC FUNCTION("array", "rescue") {
			private ["_civil", "_civils", "_group", "_type", "_position", "_unit", "_count", "_list", "_text", "_house", "_index", "_positions"];

			_position = _this;
			_position = [_position, 0, 50, 1, 0, 3, 0 ] call BIS_fnc_findSafePos;
			_positions = [];

			if((_position isFlatEmpty  [100, -1, 0.05, 100, -1]) isEqualTo []) then {
				_house = ["Land_Slum_House02_F", "Land_i_House_Big_01_V3_F", "Land_i_Shop_02_V1_F", "Land_i_House_Small_01_V2_F", "Land_u_House_Small_01_V1_F", "Land_Slum_House03_F"]  call BIS_fnc_selectRandom;
				{ _x hideObjectGlobal true } foreach (nearestTerrainObjects [_position,[], 50]);
				_house = _house createVehicle (_position findEmptyPosition [0, 50]);

				_index = 0;
				while { format ["%1", _house buildingPos _index] != "[0,0,0]" } do {
					_positions = _positions + [(_house buildingPos _index)];
					_index = _index + 1;
					sleep 0.01;
				};
				_position = _positions call BIS_fnc_selectRandom;
			};

			_civils = ["C_man_1","C_man_p_fugitive_F","C_man_p_fugitive_F_afro","C_man_p_fugitive_F_euro","C_man_p_fugitive_F_asia","C_man_p_beggar_F","C_man_p_beggar_F_afro","C_man_p_beggar_F_euro","C_man_p_beggar_F_asia","C_man_p_scavenger_1_F","C_man_p_scavenger_1_F_afro","C_man_p_scavenger_1_F_euro","C_man_p_scavenger_1_F_asia","C_man_p_scavenger_2_F","C_man_p_scavenger_2_F_afro","C_man_p_scavenger_2_F_euro","C_man_p_scavenger_2_F_asia","C_man_w_farmer_1_F","C_man_w_fisherman_1_F","C_man_w_farmer_2_F","C_man_w_fisherman_2_F","C_man_w_worker_F","C_man_hunter_1_F","C_man_hunter_2_F","C_man_1_1_F","C_man_1_1_F_afro","C_man_1_1_F_euro","C_man_1_1_F_asia","C_man_1_2_F","C_man_1_2_F_afro","C_man_1_2_F_euro","C_man_1_2_F_asia","C_man_1_3_F","C_man_1_3_F_afro","C_man_1_3_F_euro","C_man_1_3_F_asia","C_man_2_1_F","C_man_2_1_F_afro","C_man_2_1_F_euro","C_man_2_1_F_asia","C_man_2_2_F","C_man_2_3_F","C_man_2_3_F_afro","C_man_2_3_F_euro","C_man_2_3_F_asia","C_man_3_1_F","C_man_3_1_F_afro","C_man_3_1_F_euro","C_man_3_1_F_asia","C_man_shepherd_F","C_man_p_scavenger_3_F","C_man_p_scavenger_3_F_afro","C_man_p_scavenger_3_F_euro","C_man_p_scavenger_3_F_asia","C_man_4_1_F","C_man_4_1_F_afro","C_man_4_1_F_euro","C_man_4_1_F_asia","C_man_4_2_F","C_man_4_2_F_afro","C_man_4_2_F_euro","C_man_4_2_F_asia","C_man_4_3_F","C_man_4_3_F_afro","C_man_4_3_F_euro","C_man_4_3_F_asia","C_man_priest_F","C_man_p_shorts_1_F","C_man_p_shorts_1_F_afro","C_man_p_shorts_1_F_euro","C_man_p_shorts_1_F_asia","C_man_p_shorts_2_F","C_man_p_shorts_2_F_afro","C_man_p_shorts_2_F_euro","C_man_p_shorts_2_F_asia","C_man_shorts_1_F","C_man_shorts_1_F_afro","C_man_shorts_1_F_euro","C_man_shorts_1_F_asia","C_man_shorts_2_F","C_man_shorts_2_F_afro","C_man_shorts_2_F_euro","C_man_shorts_2_F_asia","C_man_shorts_3_F","C_man_shorts_3_F_afro","C_man_shorts_3_F_euro","C_man_shorts_3_F_asia","C_man_shorts_4_F","C_man_shorts_4_F_afro","C_man_shorts_4_F_euro","C_man_shorts_4_F_asia","C_man_pilot_F","C_man_polo_1_F","C_man_polo_1_F_afro","C_man_polo_1_F_euro","C_man_polo_1_F_asia","C_man_polo_2_F","C_man_polo_2_F_afro","C_man_polo_2_F_euro","C_man_polo_2_F_asia","C_man_polo_3_F","C_man_polo_3_F_afro","C_man_polo_3_F_euro","C_man_polo_3_F_asia","C_man_polo_4_F","C_man_polo_4_F_afro","C_man_polo_4_F_euro","C_man_polo_4_F_asia","C_man_polo_5_F","C_man_polo_5_F_afro","C_man_polo_5_F_euro","C_man_polo_5_F_asia","C_man_polo_6_F","C_man_polo_6_F_afro","C_man_polo_6_F_euro","C_man_polo_6_F_asia","C_Orestes","C_Nikos"];

			_group = creategroup civilian;
			_type = _civils call BIS_fnc_selectRandom;
			_civil = _group createUnit [_type, _position, [], 5, "FORM"];
			_civil stop true;

			if!(alive _civil) exitwith {
				deletevehicle _civil;
				deletegroup _group;
			};
			
			MEMBER("target", _civil);

			_text = "Rescue " + name _civil;
			MEMBER("setMarker", _text);

			_run = true;
			_win = false;
			
			_counter = 3600;

			while { _run } do {
				_count = count (units (group _civil));
				_list = nearestObjects [position _civil, ["MAN"], 5];
				sleep 0.5;
				if((count _list > 1) and (_count ==1)) then {
					{
						if((isPlayer _x) and (side _x == west)) then {
							[_civil] joinSilent group _x;
							_civil stop false;
							_civil doFollow _x;
						};
					}foreach _list;
				};
				if(_count > 1) then {
					_list = nearestObjects [position _civil, ["MAN"], 200];
					sleep 0.5;
					_count = east countSide _list;
					if(_count == 0) then {
						_run = false;
						_win = true;
					};
				};
				if(getdammage _civil > 0.9) then {
					_run = false;
					_win = false;
				};
				if(_counter < 1) then {
					_run = false;
				};
				_counter = _counter  - 1;
				sleep 1;
			};

			if(_win)	then {
				["setTicket", "mission"] call global_ticket;
				wcmissioncompleted = [true, _text];
				["wcmissioncompleted", "client"] call BME_fnc_publicvariable;
			} else {
				wcmissioncompleted = [false, _text];
				["wcmissioncompleted", "client"] call BME_fnc_publicvariable;
			};
			sleep 60;
			deletevehicle _civil;
			deletegroup _group;
		};

		PRIVATE FUNCTION("array", "getMen") {
			private ["_alive", "_handle","_type","_position","_group", "_position2", "_run", "_win", "_counter", "_text", "_vehicle"];

			_position = _this;

			_target = ["Land_Lighthouse_small_F", "Land_Airport_Tower_F", "Land_Hangar_F", "Land_dp_bigTank_F", "Land_dp_mainFactory_F", "Land_dp_smallTank_F", "Land_dp_transformer_F", "Land_Factory_Main_F", "Land_fs_feed_F", "Land_IndPipe1_ground_F", "Land_HighVoltageEnd_F", "Land_HighVoltageTower_F", "Land_HighVoltageTower_largeCorner_F", "Land_ReservoirTank_Airport_F", "Land_ReservoirTank_V1_F", "Land_ReservoirTower_F", "Land_Tank_rust_F", "Land_TTowerBig_1_F", "Land_TBox_F", "Land_TTowerBig_2_F", "MetalBarrel_burning_F", "Land_MetalBarrel_F", "Land_Cargo_House_V1_F", "Land_Cargo_House_V2_F", "Land_Cargo_House_V3_F", "Land_Cargo_HQ_V1_F", "Land_Cargo_HQ_V2_F", "Land_Cargo_HQ_V3_F", "Land_Cargo_Patrol_V1_F", "Land_Cargo_Patrol_V2_F", "Land_Cargo_Patrol_V3_F", "Land_Cargo_Tower_V1_F", "Land_Cargo_Tower_V2_F", "Land_Cargo_Tower_V3_F", "Land_Radar_F", "Land_MilOffices_V1_F", "Land_Radar_Small_F", "Land_Dome_Small_F", "Land_Research_house_V1_F", "Land_Research_HQ_F", "Land_Offices_01_V1_F", "Land_dp_mainFactory_F", "Land_dp_smallFactory_F", "Land_Factory_Main_F", "Land_PowerLine_distributor_F", "Land_i_Shed_Ind_F", "Land_TTowerSmall_2_F"] call BIS_fnc_selectRandom;
			{ _x hideObjectGlobal true } foreach (nearestTerrainObjects [_position,[], 50]);
			_target = _target createVehicle (_position findEmptyPosition [0, 50]);
	
			_type = ["BUS_InfSquad_Weapons","BUS_InfSquad", "BUS_InfTeam", "BUS_InfTeam_AA", "BUS_InfTeam_AT", "BUS_ReconTeam"] call BIS_fnc_selectRandom;
		
			_position = [_position, 0,50,1,0,3,0] call BIS_fnc_findSafePos;
			_position2 = getArray(configFile >> "CfgWorlds" >> worldName >> "centerPosition");
			if(_position isequalto _position2)  exitwith {[];};
		
			_group = [_position, west, (configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "infantry" >> _type)] call BIS_fnc_spawnGroup;
			MEMBER("target", leader _group);
			 _group setBehaviour "STEALTH";
			 _group setCombatMode "GREEN";

			{
				_x setskill wcskill;
				sleep 0.1;
			}foreach (units _group);			 

			_text = "Support " + rank (leader _group) + " " +name (leader _group);
			MEMBER("setMarker", _text);

			_run = true;
			_win = false;
			
			_counter = 3600;

			while { _run } do {
				_list = nearestObjects [position (leader _group), ["MAN"], 300];
				_list2 = nearestObjects [position (leader _group), ["MAN"], 25];
				sleep 0.5;
				if(((east countSide _list) == 0) and ((west countSide _list2) > count (units _group))) then {
					_run = false;
					_win = true;
				};

				_alive = false;
				{
					if(alive _x) then {
						_alive = true;
					};
				}foreach (units _group);
				if(!_alive) then {
					_run = false;
					_win = false;
				};
				if(_counter < 1) then {
					_run = false;
					_win = false;
				};
				if((position (leader _group)) distance _position > 300) then {
					_run = false;
					_win = true;
				};
				_counter = _counter  - 1;
				sleep 1;
			};
			
			if(_win)	then {
				["setTicket", "mission"] call global_ticket;
				wcmissioncompleted = [true, _text];
				["wcmissioncompleted", "client"] call BME_fnc_publicvariable;
			} else {
				wcmissioncompleted = [false, _text];
				["wcmissioncompleted", "client"] call BME_fnc_publicvariable;
			};
			sleep 60;
			{deletevehicle _x;} foreach  (units _group);
			deletegroup _group;					
		};		


		PUBLIC FUNCTION("string", "setMarker") {
			private ["_mark", "_name", "_target", "_text"];
			_text = _this;

			_target = MEMBER("target", nil);
			_mark = ["new", [position _target, false]] call OO_MARKER;
			["attachTo", _target] spawn _mark;
			["setText", _text] spawn _mark;
			["setColor", "ColorRed"] spawn _mark;
			["setType", "hd_objective"] spawn _mark;
			["setSize", [1,1]] spawn _mark;
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