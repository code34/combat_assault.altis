	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014 Nicolas BOITEUX

	CLASS OO_PATHFINDING
	
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

	CLASS("OO_PATHFINDING")
		PRIVATE VARIABLE("code","grid");
		PRIVATE VARIABLE("code","weightfunction");
	
		PUBLIC FUNCTION("code","constructor") {
			MEMBER("grid", _this);
			MEMBER("weightfunction", {1;})
		};

		PUBLIC FUNCTION("code", "setWeightFunction") {
			MEMBER("weightfunction", _this);
		};

		PRIVATE FUNCTION("array", "heuristic") {
			private ["_goal", "_next"];

			_goal = _this select 0;
			_next = _this select 1;

			abs((_goal select 0) - (_next select 0)) + abs((_goal select 1) - (_next select 1));
		};

		// Path finding - find the best way between one sector and other
		PUBLIC FUNCTION("array", "getPath_GreedyBestFirst") {
			private ["_start", "_end", "_frontier", "_current", "_path", "_grid", "_hashmap", "_position", "_heuristic", "_index", "_value", "_size"];

			_start = _this select 0;
			_end = _this select 1;

			_grid = MEMBER("grid", nil);
			
			_hashmap = ["new", []] call OO_HASHMAP;
			_frontier = ["new", ""] call OO_QUEUE;

			_start = ["getSectorFromPos", _start] call _grid;
			_end = ["getSectorFromPos", _end] call _grid;
			_size = ("getXsectorsize" call _grid) / 2;

			["put", [0, _start]] call _frontier;
			["put", [str(_start), _start]] call _hashmap;


			while {!("isEmpty" call _frontier)} do {
				_current = ["get", ""] call _frontier;
				_arounds = ["getSectorsAroundSector", _current] call _grid;
				{
					_position = ["getPosFromSector", _x] call _grid;
					_list = _position nearRoads _size;
					if(count _list > 0) then {
						_result = ["containsKey", str(_x)] call _hashmap;
						if(!_result)then {
							_array = [_x, _end];
							_heuristic = MEMBER("heuristic", _array);
							["put", [_heuristic, _x]] call _frontier;
							["put", [str(_x), _current]] call _hashmap;
							//["DrawSector", [_current, str(_heuristic)]] call _grid;
						};
					};
					sleep 0.000001;
				}foreach _arounds;
				if(_current isequalto _end) then {"clearQueue" call _frontier;};
			};

			_path = [];
			while {!(_current isequalto _start)} do {
				_path = _path + [["getPosFromSector", _current] call _grid];
				_current = ["get", str(_current)] call _hashmap;
				sleep 0.000001;
			};
			_path = _path + [["getPosFromSector", _current] call _grid];
			reverse _path;

			["delete", _hashmap] call OO_HASHMAP;
			["delete", _frontier] call OO_QUEUE;

			_path;
		};		

		// Path finding - find the best way between one sector and other
		PUBLIC FUNCTION("array", "getPath_Dijkstra") {
			private ["_start", "_end", "_frontier", "_current", "_path", "_grid", "_hashmap", "_position", "_heuristic", "_weightsofar", "_newweight", "_result", "_queue", "_size"];

			_start = _this select 0;
			_end = _this select 1;

			_grid = MEMBER("grid", nil);
			_hashmap = ["new", []] call OO_HASHMAP;
			_weightsofar = ["new", []] call OO_HASHMAP;
			_frontier = ["new", ""] call OO_QUEUE;

			_start = ["getSectorFromPos", _start] call _grid;
			_end = ["getSectorFromPos", _end] call _grid;
			_size = ("getXsectorsize" call _grid) / 2;

			["put", [str(_start), _start]] call _hashmap;
			["put", [str(_start), 0]] call _weightsofar;
			["put", [0, _start]] call _frontier;

			while {!("isEmpty" call _frontier)} do {
				_current = ["get", ""] call _frontier;
				_arounds = ["getSectorsAroundSector", _current] call _grid;
				
				{
					_position = ["getPosFromSector", _x] call _grid;
					_list = _position nearRoads _size;
					if(count _list > 0) then {
						_newweight = (["get", str(_current)] call _weightsofar) + 1;
						_result = false;
						if(["containsKey", str(_x)] call _weightsofar) then {
							if(_newweight < (["get", str(_x)] call _weightsofar)) then {
								_result = true;
							};
						} else {
							_result = true;
						};
						if (_result) then {
							["put", [str(_x), _newweight]] call _weightsofar;
							["put", [_newweight, _x]] call _frontier;
							["put", [str(_x), _current]] call _hashmap;
							//["DrawSector", [_current, str(_newweight)]] call _grid;
						};
					};
					sleep 0.000001;
				}foreach _arounds;
				if(_current isequalto _end) then {"clearQueue" call _frontier;};
			};

			_path = [];
			while {!(_current isequalto _start)} do {
				_path = _path + [["getPosFromSector", _current] call _grid];
				_current = ["get", str(_current)] call _hashmap;
				sleep 0.000001;
			};
			_path = _path + [["getPosFromSector", _current] call _grid];
			reverse _path;
			
			["delete", _weightsofar] call OO_HASHMAP;
			["delete", _hashmap] call OO_HASHMAP;
			["delete", _frontier] call OO_QUEUE;

			_path;
		};	

		// Path finding - find the best way between one sector and other
		PUBLIC FUNCTION("array", "getPath_A") {
			private ["_start", "_end", "_frontier", "_current", "_path", "_grid", "_hashmap", "_position", "_heuristic", "_weightsofar", "_newweight", "_result", "_queue", "_array", "_heuristic", "_priority", "_size", "_weight"];

			_start = _this select 0;
			_end = _this select 1;

			_grid = MEMBER("grid", nil);
			_hashmap = ["new", []] call OO_HASHMAP;
			_weightsofar = ["new", []] call OO_HASHMAP;
			_frontier = ["new", ""] call OO_QUEUE;

			_start = ["getSectorFromPos", _start] call _grid;
			_end = ["getSectorFromPos", _end] call _grid;
			_size = ("getXsectorsize" call _grid) / 2;

			["put", [str(_start), _start]] call _hashmap;
			["put", [str(_start), 0]] call _weightsofar;
			["put", [0, _start]] call _frontier;

			while {!("isEmpty" call _frontier)} do {
				_current = ["get", ""] call _frontier;
				_arounds = ["getSectorsAroundSector", _current] call _grid;
				
				{
					_position = ["getPosFromSector", _x] call _grid;
					_weight = [_position, _size ] call MEMBER("weightfunction", nil);
					if(_weight > 0) then {
						_newweight = (["get", str(_current)] call _weightsofar) + _weight;
						_result = false;
						if(["containsKey", str(_x)] call _weightsofar) then {
							if(_newweight < (["get", str(_x)] call _weightsofar)) then {
								_result = true;
							};
						} else {
							_result = true;
						};
						if (_result) then {
							_array = [_x, _end];
							_heuristic = MEMBER("heuristic", _array);
							_priority = _newweight + _heuristic;						
							["put", [str(_x), _newweight]] call _weightsofar;
							["put", [_priority, _x]] call _frontier;
							["put", [str(_x), _current]] call _hashmap;
							//["DrawSector", [_current, str(_priority)]] call _grid;
						};
					};
					sleep 0.000001;
				}foreach _arounds;
				if(_current isequalto _end) then {"clearQueue" call _frontier;};
			};

			_path = [];
			while {!(_current isequalto _start)} do {
				_path = _path + [["getPosFromSector", _current] call _grid];
				_current = ["get", str(_current)] call _hashmap;
				sleep 0.000001;
			};
			_path = _path + [["getPosFromSector", _current] call _grid];
			reverse _path;
			
			["delete", _weightsofar] call OO_HASHMAP;
			["delete", _hashmap] call OO_HASHMAP;
			["delete", _frontier] call OO_QUEUE;
			_path;
		};		

		PUBLIC FUNCTION("","deconstructor") { 
			DELETE_VARIABLE("grid");
			DELETE_VARIABLE("weightfunction");
		};
	ENDCLASS;