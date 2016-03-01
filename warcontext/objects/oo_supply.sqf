	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2016 Nicolas BOITEUX

	CLASS OO_SUPPLY
	
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

	CLASS("OO_SUPPLY")
		PRIVATE VARIABLE("code","marker");
		PRIVATE VARIABLE("object", "target");
		PRIVATE VARIABLE("array", "position");

		PUBLIC FUNCTION("array","constructor") {
			private ["_list"];

			MEMBER("position", _this);
			
			_list = MEMBER("getSupply", nil);
			if(count _list > 0 ) then {
				MEMBER("markSupply", _list);
			};
		};

		PUBLIC FUNCTION("", "getSupply") {
			private ["_list", "_targets"];
			
			_targets = ["Land_i_House_Small_03_V1_F", "Land_Shed_Big_F", "Land_Hospital_main_F", "Land_u_Addon_02_V1_F", "Land_i_Barracks_V2_F", "Land_Lighthouse_small_F", "Land_Airport_Tower_F", "Land_Hangar_F", "Land_dp_bigTank_F", "Land_dp_mainFactory_F", "Land_dp_smallTank_F", "Land_dp_transformer_F", "Land_Factory_Main_F", "Land_FuelStation_Feed_F", "Land_fs_feed_F", "Land_IndPipe1_ground_F", "Land_HighVoltageEnd_F", "Land_HighVoltageTower_F", "Land_HighVoltageTower_largeCorner_F", "Land_ReservoirTank_Airport_F", "Land_ReservoirTank_V1_F", "Land_ReservoirTower_F", "Land_Tank_rust_F", "Land_TTowerBig_1_F", "Land_TBox_F", "Land_TTowerBig_2_F", "MetalBarrel_burning_F", "Land_MetalBarrel_F", "Land_Cargo_House_V1_F", "Land_Cargo_House_V2_F", "Land_Cargo_House_V3_F", "Land_Cargo_HQ_V1_F", "Land_Cargo_HQ_V2_F", "Land_Cargo_HQ_V3_F", "Land_Cargo_Patrol_V1_F", "Land_Cargo_Patrol_V2_F", "Land_Cargo_Patrol_V3_F", "Land_Cargo_Tower_V1_F", "Land_Cargo_Tower_V2_F", "Land_Cargo_Tower_V3_F", "Land_Radar_F", "Land_MilOffices_V1_F", "Land_Radar_Small_F", "Land_Dome_Small_F", "Land_Research_house_V1_F", "Land_Research_HQ_F", "Land_Offices_01_V1_F", "Land_dp_mainFactory_F", "Land_dp_smallFactory_F", "Land_Factory_Main_F", "Land_PowerLine_distributor_F", "Land_i_Shed_Ind_F", "Land_TTowerSmall_2_F"];

			_list = nearestObjects [ MEMBER("position", nil), _targets,  50];
			sleep 0.1;
			_list;
		};

		PUBLIC FUNCTION("array", "markSupply") {
			private ["_target", "_text", "_array"];

			{
				_text= "Supply" + getText (configFile >> "CfgVehicles" >> (typeOf _x) >> "DisplayName");
				_array = [_text, _x];
				MEMBER("setMarker", _array);
			}foreach _this;
		};


		PUBLIC FUNCTION("array", "setMarker") {
			private ["_mark", "_target", "_text"];
			
			_text = _this select 0;
			_target = _this select 1;

			_mark = ["new", [position _target, false]] call OO_MARKER;
			//["attachTo", _target] spawn _mark;
			["setPos", position _target] spawn _mark;
			["setText", _text] spawn _mark;
			["setColor", "ColorOrange"] spawn _mark;
			["setType", "mil_triangle"] spawn _mark;
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