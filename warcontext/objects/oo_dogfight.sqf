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
		PRIVATE VARIABLE("array","squadron");
		PRIVATE VARIABLE("array","targets");
		PRIVATE VARIABLE("array","target");
		PRIVATE VARIABLE("bool","patrol");
		PRIVATE VARIABLE("scalar","squadronsize");
			
		PUBLIC FUNCTION("array","constructor") {
			private ["_array"];
			_array = [];
			MEMBER("patrol", false);
			MEMBER("squadron", _array);
			MEMBER("targets", _array);
			MEMBER("target", _array);
			MEMBER("squadronsize", 0);
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
			}foreach MEMBER("squadron", nil);
		};

		PUBLIC FUNCTION("", "setSquadronSize") {
			private ["_multiplicator", "_size"];
			_multiplicator = count MEMBER("targets", nil);
			_size = 3 * _multiplicator;
			MEMBER("squadronsize", _size);		
		};

		PUBLIC FUNCTION("","getSquadronSize") {
			count MEMBER("squadron", nil);
		};

		PUBLIC FUNCTION("","startPatrol") {
			MEMBER("patrol", true);
			while { MEMBER("patrol", nil) } do {
				MEMBER("setSquadronSize", nil);
				MEMBER("popSquadron", nil);
				MEMBER("detectTargets", nil);
				MEMBER("setTarget", nil);	
				MEMBER("intercept", nil);
				MEMBER("setFuel", nil);
				MEMBER("cleaner", nil);
				sleep 20;
			};
		};

		PUBLIC FUNCTION("","stopPatrol") {
			MEMBER("patrol", false);
		};

		PUBLIC FUNCTION("", "setTarget") {
			private ["_target", "_score"];

			if(count MEMBER("targets", nil) > 0) then {
				_score = -1000;
				{			
					if(score _x > _score) then {
						_score = score _x;
						_target = [_x];
					};
				} foreach MEMBER("targets", nil);
			} else {
				_target = [];
			};
			MEMBER("target", _target);
		};

		PUBLIC FUNCTION("", "intercept") {
			private ["_target", "_vehicle"];

			if(count MEMBER("target", nil) > 0) then {
				_target = MEMBER("target", nil) select 0;
				{
					_vehicle = _x select 0;
					_vehicle domove (position _target);
					_vehicle dotarget _target;
				}foreach MEMBER("squadron", nil);
			};
		};

		PUBLIC FUNCTION("", "setFuel") {
			private ["_setFuel"];
			{
				_vehicle = _x select 0;
				_vehicle setfuel ((fuel _vehicle) - 0.05);
				sleep 0.001;
			}foreach MEMBER("squadron", nil);
		};

		PUBLIC FUNCTION("", "detectTargets") {
			private ["_array"];

			_array = [];
			{
				if(typeof _x == "B_Pilot_F") then {
					if((getposatl _x) select 2 > 10) then {
						_array = _array + [_x];
					};
				};
				if(typeof _x == "B_crew_F") then {
					_array = _array + [_x];
				};
			}foreach playableunits;
			MEMBER("targets", _array);
		};

		PUBLIC FUNCTION("", "popMember") {
			private ["_crew", "_vehicle", "_mark", "_position", "_squad"];
		
			_position = [[500,500,500], [29000,29000,100], [500,29000,100], [29000,500,100]] call BIS_fnc_selectRandom;
			_array = [_position, 0, "O_Plane_CAS_02_F", east] call bis_fnc_spawnvehicle;

			_vehicle = _array select 0;
			_crew = (_array select 1) select 0;

			_mark = ["new", position _vehicle] call OO_MARKER;

			["attachTo", _vehicle] spawn _mark;
			["setText", "Mig"] spawn _mark;
			["setColor", "ColorRed"] spawn _mark;
			["setType", "mil_arrow"] spawn _mark;
			["setSize", [0.5,0.5]] spawn _mark;

			_squad = MEMBER("squadron", nil);
			_squad = _squad + [[_vehicle, _crew, _mark]];
			MEMBER("squadron", _squad);
		};

		PUBLIC FUNCTION("object", "unpopMember") {
			private ["_counter", "_group", "_squad"];

			_counter = 0;
			_squad = MEMBER("squadron", nil);
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
					_squad set [_counter, -1];
				};
				_counter = _counter + 1;
			}foreach _squad;
			_squad = _squad - [-1];
			MEMBER("squadron", _squad);
		};

		PUBLIC FUNCTION("", "popSquadron") {
			private ["_size"];
			_size = MEMBER("squadronsize", nil) - MEMBER("getSquadronSize", nil);

			for "_i" from 1 to _size do {
				MEMBER("popMember", nil);
				sleep 10;
			};
		};

		PUBLIC FUNCTION("", "unpopSquadron") {
			{
				MEMBER("unpopMember", _x select 0);
			}foreach MEMBER("squadron", nil);
		};

		
		PUBLIC FUNCTION("","deconstructor") { 
			DELETE_VARIABLE("patrol");
			DELETE_VARIABLE("squadron");
			DELETE_VARIABLE("targets");
			DELETE_VARIABLE("squadronsize");
		};
	ENDCLASS;