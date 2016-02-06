	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014 Nicolas BOITEUX

	CLASS OO_DOGFIGHT
	
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

	CLASS("OO_DOGFIGHT")
		PRIVATE VARIABLE("code","atc");
		PRIVATE VARIABLE("scalar","age");
		PRIVATE VARIABLE("array","squadron");
		PRIVATE VARIABLE("array","airtargets");
		PRIVATE VARIABLE("array","groundtargets");
		PRIVATE VARIABLE("array","playertargets");
		PRIVATE VARIABLE("array","targets");
		PRIVATE VARIABLE("array","target");
		PRIVATE VARIABLE("bool","patrol");
		PRIVATE VARIABLE("scalar","squadronsize");
		PRIVATE VARIABLE("scalar","counter");

			
		PUBLIC FUNCTION("array","constructor") {
			private ["_array"];
			_array = [];
			MEMBER("atc", _this select 0);
			MEMBER("patrol", false);
			MEMBER("squadron", _array);
			MEMBER("airtargets", _array);
			MEMBER("groundtargets", _array);
			MEMBER("playertargets", _array);
			MEMBER("targets", _array);
			MEMBER("target", _array);
			MEMBER("squadronsize", 0);
			MEMBER("counter", 5);
			MEMBER("age", 10);
		};

		PUBLIC FUNCTION("","getSquadron") FUNC_GETVAR("squadron");
		PUBLIC FUNCTION("","getTargets") FUNC_GETVAR("targets");

		PUBLIC FUNCTION("", "cleaner") {
			private ["_vehicle", "_crew", "_mark"];

			{
				_vehicle = _x select 0;
				if(getDammage _vehicle > 0.90) then {
					_vehicle setdammage 1;
					sleep 10;	
					MEMBER("unpopMember", _vehicle);
				};
				sleep 0.01;
			}foreach MEMBER("squadron", nil);
		};

		// Defini la taille de l'escadre
		PUBLIC FUNCTION("", "setSquadronSize") {
			private ["_array", "_ground", "_air", "_size", "_player"];

			// compte le nombre de vehicules au sol bluefor
			_ground = count MEMBER("groundtargets", nil);

			// compte le nombre d avions bluefor
			_air = count MEMBER("airtargets", nil);

			// compte le nombre d infantery
			_player = count MEMBER("playertargets", nil);

			// la taille de l escadre ne peut pas etre superieur a 6
			_size = _ground + (2 * _air) + round(_player / 5);

			if(_size > 6) then { _size = 6;};
			MEMBER("squadronsize", _size);		
		};

		PUBLIC FUNCTION("","getSquadronSize") {
			count MEMBER("squadron", nil);
		};

		PUBLIC FUNCTION("","start") {
			MEMBER("patrol", true);
			while { MEMBER("patrol", nil) } do {
				MEMBER("checkTargets", nil);
				MEMBER("setSquadronSize", nil);
				MEMBER("popSquadron", nil);
				MEMBER("intercept", nil);
				MEMBER("setFuel", nil);
				MEMBER("cleaner", nil);
				sleep 10;
			};
		};

		PUBLIC FUNCTION("","stop") {
			MEMBER("patrol", false);
		};

		PUBLIC FUNCTION("object", "checkScoreByVehicle") {
			private ["_score", "_vehicle"];
			_vehicle = _this;
			_score = 0;
			{
				_score = _score + score _x;
				sleep 0.0001;
			}foreach (crew _vehicle);
			_score;
		};

		PUBLIC FUNCTION("", "setTarget") {
			private ["_target", "_score", "_newscore"];

			if(count MEMBER("targets", nil) > 0) then {
				_score = -1000;
				{
					_newscore = MEMBER("checkScoreByVehicle", _x);
					if(_newscore > _score) then {
						_score = _newscore;
						_target = [_x];
					};
					sleep 0.0001;
				} foreach MEMBER("targets", nil);
			} else {
				_target = [];
			};
			MEMBER("target", _target);
		};

		PUBLIC FUNCTION("", "intercept") {
			private ["_target", "_vehicle", "_squadron"];

			if(count MEMBER("target", nil) > 0) then {
				_target = MEMBER("target", nil) select 0;
				_squadron = MEMBER("squadron", nil);
				
				{
					_vehicle = _x select 0;
					_vehicle domove (position _target);
					_vehicle dotarget _target;
					diag_log format ["oo_dogfight target %1 %2 %3", position _target, _target, _vehicle];
					if(count crew _target == 0) then {
						_target engineOn true;
					};
					sleep 0.01;
				}foreach MEMBER("squadron", nil);
			};
		};

		PUBLIC FUNCTION("", "setFuel") {
			private ["_conso", "_fuel", "_vehicle"];
			{
				_vehicle = _x select 0;
				_vehicle setFuel 1;
				_vehicle setVehicleAmmoDef 1;
				sleep 0.0001;
			}foreach MEMBER("squadron", nil);
		};

		PUBLIC FUNCTION("", "checkTargets") {
			private ["_target", "_age"];
			
			_target = MEMBER("target", nil);
			_age = MEMBER("age", nil);

			if( ((position (_target select 0)) isEqualTo [0,0,0]) or (_age < 1) ) then { 
				_target = [];
				_age = 10;
				MEMBER("target", _target); 
				MEMBER("age", _age);
			} else {
				_age = _age - 1;
				MEMBER("age", _age);
			};

			while { count _target == 0} do {
				MEMBER("detectTargets", nil);
				MEMBER("setTarget", nil);
				_target = MEMBER("target", nil);
			};
		};

		PUBLIC FUNCTION("", "detectTargets") {
			private ["_groundtargets", "_airtargets", "_vehicle", "_playertargets", "_targets"];

			_groundtargets = [];
			_airtargets = [];
			_playertargets = [];
			
			{
				if(side _x ==  west) then {
					_vehicle = vehicle _x;
					if(_vehicle == _x) then {
						if!(_x in _playertargets) then {
							_playertargets = _playertargets + [_x];
						};
					} else {
						if((getposatl _x) select 2 > 10) then {
							if!(_vehicle in _airtargets) then {
								_airtargets = _airtargets + [_vehicle];
							};
						} else {
							if!(_vehicle in _groundtargets) then {
								_groundtargets = _groundtargets + [_vehicle];
							};
						};
					};
					sleep 0.0001;
				};
			}foreach playableunits;
			
			MEMBER("airtargets", _airtargets);
			MEMBER("groundtargets", _groundtargets);
			MEMBER("playertargets", _playertargets);

			_targets = _airtargets + _groundtargets + _playertargets;
			MEMBER("targets", _targets);
		};

		PUBLIC FUNCTION("", "popMember") {
			private ["_atc", "_crew", "_vehicle", "_mark", "_position", "_squad"];
			
			_atc = MEMBER("atc", nil);
			_array = "getEast" call _atc;
			_marker =  _array call BIS_fnc_selectRandom;
			 _position = getmarkerpos _marker;

			 _list = _position nearEntities [["Man", "Tank"], 300];
			 sleep 0.5;
			 if(west countSide _list == 0) then {
				_position = [_position select 0, _position select 1, 100];
				_array = [_position, 0, "O_Plane_CAS_02_F", east] call bis_fnc_spawnvehicle;

				_vehicle = _array select 0;
				_crew = (_array select 1) select 0;
				_handle = [_crew, ""] spawn WC_fnc_setskill;
				_handle = [_vehicle] spawn WC_fnc_vehiclehandler;

				_mark = ["new", [position _vehicle, false]] call OO_MARKER;

				["attachTo", _vehicle] spawn _mark;
				["setText", "Mig"] spawn _mark;
				["setColor", "ColorRed"] spawn _mark;
				["setType", "o_plane"] spawn _mark;
				["setSize", [1,1]] spawn _mark;

				_squad = MEMBER("squadron", nil);
				_squad = _squad + [[_vehicle, _crew, _mark]];
				MEMBER("squadron", _squad);
			};
		};

		PUBLIC FUNCTION("object", "unpopMember") {
			private ["_counter", "_group", "_squadron"];

			_squadron = MEMBER("squadron", nil);
			{
				if(_x select 0 == _this) then {
					(_x select 0) setdammage 1;
					deletevehicle (_x select 0) ;
					_group = group (_x select 1);
					(_x select 1) setdammage 1;
					deletevehicle (_x select 1);
					deletegroup _group;
					"detach" call (_x select 2);
					["delete", (_x select 2)] call OO_MARKER;
					_squadron set [_foreachindex, -1];
				};
				sleep 0.01;
			}foreach _squadron;
			_squadron = _squadron - [-1];
			MEMBER("squadron", _squadron);
		};

		PUBLIC FUNCTION("", "popSquadron") {
			private ["_atc", "_counter", "_airport", "_size"];		
			
			_atc = MEMBER("atc", nil);
			_airport = "countEast" call _atc;
			_counter = MEMBER("counter", nil);
			
			if(_airport > 0) then {
				_size = MEMBER("squadronsize", nil) - MEMBER("getSquadronSize", nil);			
				if(_size > 0) then {
					if(_counter >  3) then {
						for "_i" from 1 to _size do {
							MEMBER("popMember", nil);
							sleep 10;
						};
						MEMBER("counter", 0);
						wcaircraftstart = true;
						["wcaircraftstart", "client"] call BME_fnc_publicvariable;	
					} else {
						_counter = _counter + 1;
						MEMBER("counter", _counter);
					};
				};
			};
		};

		PUBLIC FUNCTION("", "unpopSquadron") {
			{
				MEMBER("unpopMember", _x select 0);
				sleep 0.01;
			}foreach MEMBER("squadron", nil);
		};

		
		PUBLIC FUNCTION("","deconstructor") { 
			DELETE_VARIABLE("atc");
			DELETE_VARIABLE("airtargets");
			DELETE_VARIABLE("groundtargets");
			DELETE_VARIABLE("playertargets");
			DELETE_VARIABLE("patrol");
			DELETE_VARIABLE("squadron");
			DELETE_VARIABLE("targets");
			DELETE_VARIABLE("squadronsize");
			DELETE_VARIABLE("counter");
			DELETE_VARIABLE("age");
		};
	ENDCLASS;