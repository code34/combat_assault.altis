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
		PRIVATE VARIABLE("array","squadron");
		PRIVATE VARIABLE("array","airtargets");
		PRIVATE VARIABLE("array","groundtargets");
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
			MEMBER("targets", _array);
			MEMBER("target", _array);
			MEMBER("squadronsize", 0);
			MEMBER("counter", 5);
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

		PUBLIC FUNCTION("", "setSquadronSize") {
			private ["_array", "_ground", "_air", "_size"];

			_ground = count MEMBER("groundtargets", nil);
			_air = count MEMBER("airtargets", nil);

			_size = _ground + (2 * _air);
			if(_size > 6) then { _size = 6;};
			MEMBER("squadronsize", _size);		
		};

		PUBLIC FUNCTION("","getSquadronSize") {
			count MEMBER("squadron", nil);
		};

		PUBLIC FUNCTION("","start") {
			MEMBER("patrol", true);
			while { MEMBER("patrol", nil) } do {
				MEMBER("setSquadronSize", nil);
				MEMBER("popSquadron", nil);
				MEMBER("checkTargets", nil);
				MEMBER("setFuel", nil);
				MEMBER("cleaner", nil);
				sleep 30;
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
				diag_log format ["oo_dogfight squadron %1", _squadron];
				
				{
					_vehicle = _x select 0;
					if(fuel _vehicle > 0.4) then {
						_vehicle domove (position _target);
						_vehicle dotarget _target;
						diag_log format ["oo_dogfight target %1 %2 %3", position _target, _target, _vehicle];
						if(count crew _target == 0) then {
							_target engineOn true;
						};
					} else {
						_vehicle domove [100,100];
						diag_log format ["oo_dogfight distance of init %1", (_vehicle distance [100,100])];
						if(_vehicle distance [100,100] < 2000) then {
							MEMBER("unpopMember", _vehicle);
						};
					};
					sleep 0.01;
				}foreach MEMBER("squadron", nil);
			};
		};

		PUBLIC FUNCTION("", "setFuel") {
			private ["_conso", "_fuel", "_vehicle"];
			{
				_vehicle = _x select 0;
				_fuel = fuel _vehicle;

				_conso = (speed _vehicle * 0.0005) / 10;
				_vehicle setfuel (_fuel - _conso);
				_vehicle setVehicleAmmoDef 1;
				sleep 0.0001;
			}foreach MEMBER("squadron", nil);
		};

		PUBLIC FUNCTION("", "checkTargets") {
			private ["_target"];
			
			_target = MEMBER("target", nil);
			while { count _target == 0} do {
				MEMBER("detectTargets", nil);
				MEMBER("setTarget", nil);
				_target = MEMBER("target", nil);
				sleep 10;
			};
			
			_target = MEMBER("target", nil) select 0;

			if ((damage _target < 0.9) and (!isnil "_target")) then {
				MEMBER("intercept", nil);
			} else {
				_array = [];
				MEMBER("target", _array);
			};
		};

		PUBLIC FUNCTION("", "detectTargets") {
			private ["_groundtargets", "_airtargets", "_vehicle"];

			_groundtargets = [];
			_airtargets = [];
			{
				_vehicle = vehicle _x;
				if((_vehicle != _x) and (alive _x)) then {
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
			}foreach playableunits;
			MEMBER("airtargets", _airtargets);
			MEMBER("groundtargets", _groundtargets);
			MEMBER("targets", _airtargets + _groundtargets);
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

				_mark = ["new", position _vehicle] call OO_MARKER;

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
			DELETE_VARIABLE("patrol");
			DELETE_VARIABLE("squadron");
			DELETE_VARIABLE("targets");
			DELETE_VARIABLE("squadronsize");
			DELETE_VARIABLE("counter");
		};
	ENDCLASS;