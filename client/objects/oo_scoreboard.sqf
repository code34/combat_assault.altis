	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014 Nicolas BOITEUX

	CLASS OO_SCOREBOARD
	
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

	CLASS("OO_SCOREBOARD")
		PRIVATE VARIABLE("code","map");

		PUBLIC FUNCTION("array","constructor") {
			_map = ["new", []] call OO_HASHMAP;
			MEMBER("map", _map);
		};

		PUBLIC FUNCTION("array", "addScore") {
			["put", _this] call MEMBER("map", nil);
		};

		PUBLIC FUNCTION("", "getScore") {
			private ["_map", "_players", "_globalscore", "_scores"];

			_map = MEMBER("map", nil);
			_players = "keySet" call _map;
			_globalscore = [];

			{
				_scores = ["get", _x] call _map;
				_globalscore = _globalscore + [[_x, _scores]];
				sleep 0.0001;
			}foreach _players;
			_globalscore;
		};

		PUBLIC FUNCTION("", "topByRatio") {
			private ["_array", "_score", "_sort"];
			_score = MEMBER("getScore", nil);
			_sort = [_score, 0];
			_array = MEMBER("sortMaxByColumn", _sort);
			MEMBER("getText", _array);
		};

		PUBLIC FUNCTION("", "topByServerRatio") {
			_score = MEMBER("getScore", nil);
			_sort = [_score, 1];
			MEMBER("sortMaxByColumn", _sort);
		};

		PUBLIC FUNCTION("array", "getText") {
			private ["_text", "_scores", "_score", "_tmp", "_top", "_players", "_ranks", "_serverranks", "_ranks", "_match"];

			_scores = _this;
			
			_top = "<t align='center'>Top<br/>";
			_players = "Players<br/>";
			_ranks = "<t align='center'>Game Ranking<br/>";
			_serverranks = "<t align='center'>Server Ranking<br/>";
			_matchs = "<t align='center'>Match<br/>";

			{
				_score = _x select 1;

				_tmp  = str(_foreachindex + 1) + "<br/>";			
				_top = _top + _tmp;

				_tmp = (_x select 0) + "<br/>";
				_players = _players + _tmp;

				_tmp = MEMBER("getRankText", (_score select 0)) + "<br/>";
				_ranks = _ranks + _tmp;
				
				_tmp = MEMBER("getRankText", (_score select 1)) + "<br/>";
				_serverranks = _serverranks + _tmp;
				
				_match = _score select 2;
				if(isnil "_match") then {_match = 0;};
				_tmp = str(_match) + "<br/>";
				_matchs = _matchs + _tmp;
			}foreach _scores;

			_top = _top + "</t>";
			_players = _players + "</t>";
			_ranks = _ranks + "</t>";
			_serverranks = _serverranks + "</t>";
			_matchs = _matchs + "</t>";

			[_top, _players, _ranks, _serverranks, _matchs];
		};

		PUBLIC FUNCTION("scalar", "getRankText") {
			private ["_ratio","_rank"];
			
			_ratio = _this;

			switch (true) do {
				case (_ratio < 0.99) : {
					_rank = "PRIVATE";
				};

				case (_ratio > 1 and _ratio < 1.99) : {
					_rank = "CORPORAL";
				};

				case (_ratio > 2 and _ratio < 2.99) : {
					_rank = "SERGEANT";
				};

				case (_ratio > 3 and _ratio < 3.99) : {
					_rank = "LIEUTENANT";
				};

				case (_ratio > 4 and _ratio < 4.99) : {
					_rank = "CAPTAIN";
				};

				case (_ratio > 5 and _ratio < 5.99) : {
					_rank = "MAJOR";
				};				

				case (_ratio > 6) : {
					_rank = "COLONEL" ;
				};		

				default {
					_rank = "PRIVATE";
				};
			};
			_rank;
		};

		PUBLIC FUNCTION("array", "sortMinByColumn") {
			private ["_array", "_temp", "_min", "_index", "_rem", "_column", "_score"];

			_array = _this select 0;
			_column = _this select 1;

			_temp = [];

			while { count _array > 0} do {
				_min = 10000;
				{
					_score =  (_x select 1);
					if(_score select _column < _min) then {
						_min = _score select _column;
						_index = _foreachindex;
					};
				}foreach _array;
				_rem = _array deleteat _index;
				_temp = _temp + [_rem];
			};
			_temp;	
		};

		PUBLIC FUNCTION("array", "sortMaxByColumn") {
			private ["_array", "_temp", "_max", "_index", "_rem", "_column", "_score"];

			_array = _this select 0;
			_column = _this select 1;

			_temp = [];
			
			while { count _array > 0} do {
				_max = -10000;
				{
					_score =  (_x select 1);
					if(_score select _column > _max) then {
						_max = _score select _column;
						_index = _foreachindex;
					};
				}foreach _array;
				_rem = _array deleteat _index;
				_temp = _temp + [_rem];
			};
			_temp;	
		};					

		PUBLIC FUNCTION("","deconstructor") { 
			["delete", MEMBER("map", nil)] call OO_HASHMAP;
			DELETE_VARIABLE("map", nil);
		};
	ENDCLASS;