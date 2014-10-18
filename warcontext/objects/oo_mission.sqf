﻿	/*
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
			private ["_list", "_target", "_return", "_targets"];
			
			_targets = ["Land_Lighthouse_small_F", "Land_Airport_Tower_F", "Land_Hangar_F", "Land_dp_bigTank_F", "Land_dp_mainFactory_F", "Land_dp_smallTank_F", "Land_dp_transformer_F", "Land_Factory_Main_F", "Land_FuelStation_Feed_F", "Land_fs_feed_F", "Land_IndPipe1_ground_F", "Land_HighVoltageEnd_F", "Land_HighVoltageTower_F", "Land_HighVoltageTower_largeCorner_F", "  	Land_ReservoirTank_Airport_F", "Land_ReservoirTank_V1_F", "Land_ReservoirTower_F", "Land_Tank_rust_F", "Land_TTowerBig_1_F", "Land_TBox_F", "Land_TTowerBig_2_F", "MetalBarrel_burning_F", "Land_MetalBarrel_F", "Land_Cargo_House_V1_F", "Land_Cargo_House_V2_F", "Land_Cargo_House_V3_F", "Land_Cargo_HQ_V1_F", "Land_Cargo_HQ_V2_F", "Land_Cargo_HQ_V3_F", "Land_Cargo_Patrol_V1_F", "Land_Cargo_Patrol_V2_F", "Land_Cargo_Patrol_V3_F", "Land_Cargo_Tower_V1_F", "Land_Cargo_Tower_V2_F", "Land_Cargo_Tower_V3_F", "Land_Radar_F", "Land_MilOffices_V1_F", "Land_Radar_Small_F", "Land_Dome_Small_F", "Land_Research_house_V1_F", "Land_Research_HQ_F"];

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

		PUBLIC FUNCTION("", "protect") {
			_civils = ["C_man_1","C_man_p_fugitive_F","C_man_p_fugitive_F_afro","C_man_p_fugitive_F_euro","C_man_p_fugitive_F_asia","C_man_p_beggar_F","C_man_p_beggar_F_afro","C_man_p_beggar_F_euro","C_man_p_beggar_F_asia","C_man_p_scavenger_1_F","C_man_p_scavenger_1_F_afro","C_man_p_scavenger_1_F_euro","C_man_p_scavenger_1_F_asia","C_man_p_scavenger_2_F","C_man_p_scavenger_2_F_afro","C_man_p_scavenger_2_F_euro","C_man_p_scavenger_2_F_asia","C_man_w_farmer_1_F","C_man_w_fisherman_1_F","C_man_w_farmer_2_F","C_man_w_fisherman_2_F","C_man_w_worker_F","C_man_hunter_1_F","C_man_hunter_2_F","C_man_1_1_F","C_man_1_1_F_afro","C_man_1_1_F_euro","C_man_1_1_F_asia","C_man_1_2_F","C_man_1_2_F_afro","C_man_1_2_F_euro","C_man_1_2_F_asia","C_man_1_3_F","C_man_1_3_F_afro","C_man_1_3_F_euro","C_man_1_3_F_asia","C_man_2_1_F","C_man_2_1_F_afro","C_man_2_1_F_euro","C_man_2_1_F_asia","C_man_2_2_F","C_man_2_3_F","C_man_2_3_F_afro","C_man_2_3_F_euro","C_man_2_3_F_asia","C_man_3_1_F","C_man_3_1_F_afro","C_man_3_1_F_euro","C_man_3_1_F_asia","C_man_shepherd_F","C_man_p_scavenger_3_F","C_man_p_scavenger_3_F_afro","C_man_p_scavenger_3_F_euro","C_man_p_scavenger_3_F_asia","C_man_4_1_F","C_man_4_1_F_afro","C_man_4_1_F_euro","C_man_4_1_F_asia","C_man_4_2_F","C_man_4_2_F_afro","C_man_4_2_F_euro","C_man_4_2_F_asia","C_man_4_3_F","C_man_4_3_F_afro","C_man_4_3_F_euro","C_man_4_3_F_asia","C_man_priest_F","C_man_p_shorts_1_F","C_man_p_shorts_1_F_afro","C_man_p_shorts_1_F_euro","C_man_p_shorts_1_F_asia","C_man_p_shorts_2_F","C_man_p_shorts_2_F_afro","C_man_p_shorts_2_F_euro","C_man_p_shorts_2_F_asia","C_man_shorts_1_F","C_man_shorts_1_F_afro","C_man_shorts_1_F_euro","C_man_shorts_1_F_asia","C_man_shorts_2_F","C_man_shorts_2_F_afro","C_man_shorts_2_F_euro","C_man_shorts_2_F_asia","C_man_shorts_3_F","C_man_shorts_3_F_afro","C_man_shorts_3_F_euro","C_man_shorts_3_F_asia","C_man_shorts_4_F","C_man_shorts_4_F_afro","C_man_shorts_4_F_euro","C_man_shorts_4_F_asia","C_man_pilot_F","C_man_polo_1_F","C_man_polo_1_F_afro","C_man_polo_1_F_euro","C_man_polo_1_F_asia","C_man_polo_2_F","C_man_polo_2_F_afro","C_man_polo_2_F_euro","C_man_polo_2_F_asia","C_man_polo_3_F","C_man_polo_3_F_afro","C_man_polo_3_F_euro","C_man_polo_3_F_asia","C_man_polo_4_F","C_man_polo_4_F_afro","C_man_polo_4_F_euro","C_man_polo_4_F_asia","C_man_polo_5_F","C_man_polo_5_F_afro","C_man_polo_5_F_euro","C_man_polo_5_F_asia","C_man_polo_6_F","C_man_polo_6_F_afro","C_man_polo_6_F_euro","C_man_polo_6_F_asia","C_Orestes","C_Nikos"];

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