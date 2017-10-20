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

	private ["_counter", "_mark", "_name", "_target", "_win", "_run", "_text", "_position", "_type"];

	_position = _this;

	if! (MEMBER("checkTarget", nil)) then {
		_target = ["Land_Lighthouse_small_F", "Land_Airport_Tower_F", "Land_Hangar_F", "Land_dp_bigTank_F", "Land_dp_mainFactory_F", "Land_dp_smallTank_F", "Land_dp_transformer_F", "Land_Factory_Main_F", "Land_fs_feed_F", "Land_IndPipe1_ground_F", "Land_HighVoltageEnd_F", "Land_HighVoltageTower_F", "Land_HighVoltageTower_largeCorner_F", "Land_ReservoirTank_Airport_F", "Land_ReservoirTank_V1_F", "Land_ReservoirTower_F", "Land_Tank_rust_F", "Land_TTowerBig_1_F", "Land_TBox_F", "Land_TTowerBig_2_F", "MetalBarrel_burning_F", "Land_MetalBarrel_F", "Land_Cargo_House_V1_F", "Land_Cargo_House_V2_F", "Land_Cargo_House_V3_F", "Land_Cargo_HQ_V1_F", "Land_Cargo_HQ_V2_F", "Land_Cargo_HQ_V3_F", "Land_Cargo_Patrol_V1_F", "Land_Cargo_Patrol_V2_F", "Land_Cargo_Patrol_V3_F", "Land_Cargo_Tower_V1_F", "Land_Cargo_Tower_V2_F", "Land_Cargo_Tower_V3_F", "Land_Radar_F", "Land_MilOffices_V1_F", "Land_Radar_Small_F", "Land_Dome_Small_F", "Land_Research_house_V1_F", "Land_Research_HQ_F", "Land_Offices_01_V1_F", "Land_dp_mainFactory_F", "Land_dp_smallFactory_F", "Land_Factory_Main_F", "Land_PowerLine_distributor_F", "Land_i_Shed_Ind_F", "Land_TTowerSmall_2_F"] call BIS_fnc_selectRandom;
		{ _x hideObjectGlobal true } foreach (nearestTerrainObjects [_position,[], 50]);
		_target = _target createVehicle (_position findEmptyPosition [0, 50]);
		MEMBER("target", _target);
	} else {
		_target = MEMBER("target", nil);
	};

			// create mission marker
			_text= "Destroy " + getText (configFile >> "CfgVehicles" >> (typeOf _target) >> "DisplayName");
			_type = "hd_destroy";
			_mark = [_text, _type];
			_mark = MEMBER("createMarker", _mark);

			_run = true;
			_win = false;
			_counter = 3600;

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