	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014-2018 Nicolas BOITEUX

	CLASS OO_SCORE
	
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

	CLASS("OO_SCORE")
		PRIVATE VARIABLE("array","serverranking");
		PRIVATE VARIABLE("scalar","gamekill");
		PRIVATE VARIABLE("scalar","gamedeath");
		PRIVATE VARIABLE("scalar","gamescore");
		PRIVATE VARIABLE("string","uid");
	
		PUBLIC FUNCTION("array","constructor") {
			MEMBER("serverranking", []);
			MEMBER("gamekill", 0);
			MEMBER("gamedeath", 0);
			MEMBER("gamescore", 0);
			private _key = (_this select 0) + "cba126";
			MEMBER("uid", _key);
			MEMBER("initBDD", _key);
		};

		PUBLIC FUNCTION("", "getKill") FUNC_GETVAR("gamekill");
		PUBLIC FUNCTION("", "getDeath") FUNC_GETVAR("gamedeath");

		PUBLIC FUNCTION("", "getMatches") {
			count MEMBER("serverranking", nil);
		};

		PUBLIC FUNCTION("string", "initBDD") {
			private _array = profileNamespace getVariable _this;
			if(isnil "_array") then { 
				_array = [];
				profileNamespace setVariable [_this, _array];
				saveProfileNamespace;
			};
			MEMBER("serverranking", _array);
		};

		PUBLIC FUNCTION("", "flushBDD") {	
			private _key = MEMBER("uid", nil);
			private _gameranking = MEMBER("getGameRanking", nil);
			if(_gameranking isEqualTo 0) exitwith {};
			MEMBER("serverranking", nil) pushBack _gameranking;
			profileNamespace setVariable [_key, MEMBER("serverranking", nil)];
			saveProfileNamespace;
		};

		PUBLIC FUNCTION("", "addDeath") {
			private _death = MEMBER("gamedeath", nil) + 1;
			MEMBER("gamedeath", _death);
		};

		PUBLIC FUNCTION("", "addKill") {
			private _kill = MEMBER("gamekill", nil) + 1;
			MEMBER("gamekill", _kill);
		};		

		PUBLIC FUNCTION("scalar", "setScore") {
			if(_this > 1000) then {_this = 1000;};
			private _score = MEMBER("gamescore", nil);
			_score = _score + (100 - round(log(_this / 100) * 100));
			MEMBER("gamescore", _score);
		};

		PUBLIC FUNCTION("", "killPlayer") {
			private _score = MEMBER("gamescore", nil) + 500;
			MEMBER("gamescore", _score);
		};

		PUBLIC FUNCTION("", "getScore") {
			private _score = MEMBER("gamescore", nil);
			if(_score < 1) then { _score = 1;	};
			_score;
		};		

		PUBLIC FUNCTION("scalar", "setKill") {
			MEMBER("gamekill", _this);
		};

		PUBLIC FUNCTION("", "getServerRanking") {
			private _ranking = 0;
			{
				_ranking = _ranking + _x;
			}foreach MEMBER("serverranking", nil);
			if(_ranking > 0) then { _ranking = _ranking / count (MEMBER("serverranking", nil)); };
			_ranking;
		};

		PUBLIC FUNCTION("", "getGameRanking") {
			private _kill =  MEMBER("getKill", nil);
			private _death = MEMBER("getDeath", nil);
			private _ranking = 0;

			if(!(_kill isEqualTo 0) and (_death > 4)) then { 
				_ranking = _kill / _death;
			};
			_ranking;
		};

		PUBLIC FUNCTION("scalar", "getRank") {
			private _ranking = _this;
			private _rank = "";
			switch (true) do {
				case (_ranking < 0.99) : { _rank = "PRIVATE"; };
				case (_ranking > 1 and _ranking < 1.99) : {_rank = "CORPORAL";};
				case (_ranking > 2 and _ranking < 2.99) : {_rank = "SERGEANT";};
				case (_ranking > 3 and _ranking < 3.99) : {_rank = "LIEUTENANT";};
				case (_ranking > 4 and _ranking < 4.99) : {_rank = "CAPTAIN";};
				case (_ranking > 5 and _ranking < 5.99) : {_rank = "MAJOR";};
				case (_ranking > 6) : {_rank = "COLONEL" ;};		
				default {_rank = "PRIVATE";};
			};
			_rank;
		};	

		PUBLIC FUNCTION("object", "publicScore") {
			private _gameranking = MEMBER("getGameRanking", nil);
			private _serverranking = MEMBER("getServerRanking", nil);
			private _matches = MEMBER("getMatches", nil);
			private _gamescore = MEMBER("getScore", nil);
			private _rank = MEMBER("getRank", _gameranking);
			_this setrank _rank;
			private _kill = MEMBER("getKill", nil);
			private _death = MEMBER("getDeath", nil);
			["remoteSpawn", ["BME_netcode_client_playerstats", [(name _this), [_gameranking, _serverranking, _matches, _gamescore, _kill, _death]], "client"]] call server_bme;
		};


		PUBLIC FUNCTION("","deconstructor") { 
			DELETE_VARIABLE("uid");
			DELETE_VARIABLE("serverranking");
			DELETE_VARIABLE("gamekill");
			DELETE_VARIABLE("gamedeath");
			DELETE_VARIABLE("gamescore");
		};
	ENDCLASS;