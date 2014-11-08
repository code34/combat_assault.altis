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
		PRIVATE VARIABLE("code","tree");

		PUBLIC FUNCTION("array","constructor") {
			_tree = ["new", []] call OO_TREE;
			MEMBER("tree", _tree);
		};

		PUBLIC FUNCTION("array", "addScore") {
			["put", _this] call MEMBER("tree", nil);
		};

		PUBLIC FUNCTION("", "getScore") {
			private ["_tree", "_players", "_globalscore", "_scores"];

			_tree = MEMBER("tree", nil);
			_players = "keySet" call _tree;
			_globalscore = [];

			{
				_scores = ["get", _x] call _tree;
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
			private ["_text", "_scores", "_score"];

			_scores = _this;

			_text = "Score Board<br/>";
			_text = _text + "-----------------------------------------------------------------<br/>";
			_text = _text + "<t size='0.7'>Top - Player" + "		" + " Game Ranking "+ "		" + "Server Ranking " + "		" + "Matchs</t><br/>";
			_text = _text + "-----------------------------------------------------------------<br/>";
			{
				_score = _x select 1;
				_text = _text + str _foreachindex + " - " + (_x select 0) + "		" +  MEMBER("getRankText", (_score select 0)) + "		" + MEMBER("getRankText", (_score select 1)) + "		" + str(_score select 2) + "<br/>";
			}foreach _scores;
			_text;
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
			["delete", MEMBER("tree", nil)] call OO_TREE;
			DELETE_VARIABLE("tree", nil);
		};
	ENDCLASS;