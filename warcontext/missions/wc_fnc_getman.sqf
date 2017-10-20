	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014-2018 Nicolas BOITEUX

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

			private ["_alive", "_handle","_type","_position","_group", "_position2", "_run", "_win", "_counter", "_text", "_vehicle", "_mark"];

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

			// create mission marker
			_text = "Support " + rank (leader _group) + " " +name (leader _group);
			_type = "hd_join";
			_mark = [_text, _type];
			_mark = MEMBER("createMarker", _mark);

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