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

			private ["_civil", "_civils", "_group", "_type", "_position", "_unit", "_count", "_list", "_text", "_house", "_index", "_positions", "_mark"];

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

			// create mission marker
			_text = "Rescue " + name _civil;
			_type = "hd_join";
			_mark = [_text, _type];
			_mark = MEMBER("createMarker", _mark);
			//["attachTo", _civil] spawn _mark;

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
				["remoteSpawn", ["BME_netcode_client_wcmissioncompleted", [true, _text], "client"]] call global_bme;
			} else {
				["remoteSpawn", ["BME_netcode_client_wcmissioncompleted", [false, _text], "client"]] call global_bme;
			};
			sleep 60;
			deletevehicle _civil;
			deletegroup _group;