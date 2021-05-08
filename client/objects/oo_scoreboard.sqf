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
		PRIVATE VARIABLE("hashmap","map");

		PUBLIC FUNCTION("array","constructor") {
			DEBUG(#, "OO_SCOREBOARD::constructor")
			private _map = createHashMap;
			MEMBER("map", _map);
		};

		PUBLIC FUNCTION("array", "addScore") {
			DEBUG(#, "OO_SCOREBOARD::addScore")
			MEMBER("map", nil) set [_this select 0, _this select 1];
		};

		PUBLIC FUNCTION("string", "getPlayerScore") {
			DEBUG(#, "OO_SCOREBOARD::getPlayerScore")
			private _result = MEMBER("map", nil) get _this;
			if(isnil "_result") then {	_result = [0,0,0,0,0,0]; };
			_result;
		};

		PUBLIC FUNCTION("", "generateRandomScore") {
			DEBUG(#, "OO_SCOREBOARD::generateRandomScore")
			for "_i" from 0 to 29 do {
				private _pseudo = "";
				for "_f" from 0 to 8 do {
					_pseudo = _pseudo + selectRandom["a","b","c","d","e","f","g"];
				};
				_score = [_pseudo, [ceil(random 4), ceil(random 4), ceil(random 10), ceil(random 10), ceil(random 10), ceil(random 10)]];
				MEMBER("addScore", _score);
			};
		};

		PUBLIC FUNCTION("", "getScore") {
			DEBUG(#, "OO_SCOREBOARD::getScore")
			private _map = MEMBER("map", nil);
			private _players = keys _map;
			private _globalscore = [];
			private _scores = [];

			{
				_scores = _map get _x;
				_globalscore pushBack [_x, _scores];
				sleep 0.0001;
			}foreach _players;
			_globalscore;
		};

		PUBLIC FUNCTION("", "topByRatio") {
			DEBUG(#, "OO_SCOREBOARD::topByRatio")
			private _sort = [MEMBER("getScore", nil), 0];
			private _array = MEMBER("sortMaxByColumn", _sort);
			MEMBER("getText", _array);
		};

		PUBLIC FUNCTION("", "topByScore") {
			DEBUG(#, "OO_SCOREBOARD::topByScore")
			private _sort = [MEMBER("getScore", nil), 3];
			private _array = MEMBER("sortMaxByColumn", _sort);
			MEMBER("getText", _array);
		};		

		PUBLIC FUNCTION("", "topByServerRatio") {
			DEBUG(#, "OO_SCOREBOARD::topByServerRatio")
			private _sort = [MEMBER("getScore", nil), 1];
			MEMBER("sortMaxByColumn", _sort);
		};

		PUBLIC FUNCTION("array", "getText") {
			DEBUG(#, "OO_SCOREBOARD::getText")
			private _scores = _this;
			private _top = "<t align='center'>Top<br/>";
			private _players = "Players<br/>";
			private _ranks = "<t align='center'>Game Ranking<br/>";
			private _serverranks = "<t align='center'>Server Ranking<br/>";
			private _matchs = "<t align='center'>Games<br/>";
			private _gamescores = "<t align='center'>Score<br/>";
			private _score = 0;
			private _tmp =  "";
			private _match = 0;
			private _gamescore = 0;
			private _playerkill = 0;
			private _playerdeath = 0;

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

				_gamescore = _score select 3;
				_playerkill = _score select  4;
				_playerdeath = _score select 5; 

				if(isnil "_gamescore") then {_gamescore = 0;};
				_tmp = str(_playerkill) + "/" + str(_playerdeath) + "/" + str(_gamescore) + "<br/>";
				_gamescores = _gamescores + _tmp;
			}foreach _scores;

			_top = _top + "</t>";
			_players = _players + "</t>";
			_ranks = _ranks + "</t>";
			_serverranks = _serverranks + "</t>";
			_matchs = _matchs + "</t>";
			_gamescores = _gamescores + "</t>";

			[_top, _players, _ranks, _serverranks, _matchs,  _gamescores];
		};

		PUBLIC FUNCTION("scalar", "getRankText") {
			DEBUG(#, "OO_SCOREBOARD::getRankText")
			private _ratio = _this;
			private _rank = "";

			switch (true) do {
				case (_ratio < 0.99) : { _rank = "PRIVATE";};
				case (_ratio > 1 and _ratio < 1.99) : {_rank = "CORPORAL";};
				case (_ratio > 2 and _ratio < 2.99) : {_rank = "SERGEANT";};
				case (_ratio > 3 and _ratio < 3.99) : {_rank = "LIEUTENANT";};
				case (_ratio > 4 and _ratio < 4.99) : {_rank = "CAPTAIN";};
				case (_ratio > 5 and _ratio < 5.99) : {_rank = "MAJOR";	};
				case (_ratio > 6) : {_rank = "COLONEL" ;};
				default {_rank = "PRIVATE";};
			};
			_rank;
		};

		PUBLIC FUNCTION("array", "sortMinByColumn") {
			DEBUG(#, "OO_SCOREBOARD::sortMinByColumn")	
			private _array = _this select 0;
			private _column = _this select 1;
			private _temp = [];
			private _min = 1000000;
			private _score = 0;
			private _index = 0;

			while { count _array > 0} do {
				_min = 1000000;
				{
					_score =  (_x select 1);
					if(_score select _column < _min) then {
						_min = _score select _column;
						_index = _foreachindex;
					};
				}foreach _array;
				_rem = _array deleteat _index;
				_temp pushBack _rem;
			};
			_temp;	
		};

		PUBLIC FUNCTION("array", "sortMaxByColumn") {
			DEBUG(#, "OO_SCOREBOARD::sortMaxByColumn")
			private _array = _this select 0;
			private _column = _this select 1;
			private _temp = [];
			private _score = 0;
			private _max = -1000000;
			private _index = 0;
			
			while { count _array > 0} do {
				_max = -1000000;
				{
					_score =  (_x select 1);
					if(_score select _column > _max) then {
						_max = _score select _column;
						_index = _foreachindex;
					};
				}foreach _array;
				_rem = _array deleteat _index;
				_temp pushBack _rem;
			};
			_temp;	
		};					

		PUBLIC FUNCTION("","deconstructor") { 
			DEBUG(#, "OO_SCOREBOARD::deconstructor")
			DELETE_VARIABLE("map");
		};
	ENDCLASS;