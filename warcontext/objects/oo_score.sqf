	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014 Nicolas BOITEUX

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
		PRIVATE VARIABLE("string","uid");
		PRIVATE VARIABLE("scalar","globalkill");
		PRIVATE VARIABLE("scalar","globaldeath");
		PRIVATE VARIABLE("scalar","globalratio");
		PRIVATE VARIABLE("scalar","globalnumber");
		PRIVATE VARIABLE("scalar","gamedeath");
		PRIVATE VARIABLE("scalar","gamekill");
	
		PUBLIC FUNCTION("array","constructor") {
			private ["_key", "_array"];
			_key = (_this select 0) + "cba";
			MEMBER("uid", _key);
			_array = profileNamespace getVariable _key;
			if(isnil "_array") then {
				MEMBER("initBDD", _key);
				_array = profileNamespace getVariable _key;
			};
			MEMBER("globalkill", _array select 0);
			MEMBER("globaldeath", _array select 1);
			MEMBER("globalratio", _array select 2);
			MEMBER("globalnumber", _array select 3);
			MEMBER("gamekill", 0);
			MEMBER("gamedeath", 0);
		};

		PUBLIC FUNCTION("","getNumber") FUNC_GETVAR("globalnumber");
		PUBLIC FUNCTION("","getGlobalKill") FUNC_GETVAR("globalkill");
		PUBLIC FUNCTION("","getGlobalDeath") FUNC_GETVAR("globaldeath");

		PUBLIC FUNCTION("string", "initBDD") {
			private ["_key", "_array"];
			_key = _this;
			_array = [1,1,1,0];
			profileNamespace setVariable [_key, _array];			
		};

		PUBLIC FUNCTION("", "flushBDD") {
			private ["_key", "_array"];
			_key = MEMBER("uid", nil);
			_array = MEMBER("compute", nil);
			if(_array select 2 > 0) then {
				profileNamespace setVariable [_key, _array];
			};
			saveProfileNamespace;
		};

		PUBLIC FUNCTION("", "addDeath") {
			private ["_death"];
			_death = MEMBER("gamedeath", nil) + 1;
			MEMBER("gamedeath", _death);
		};

		PUBLIC FUNCTION("scalar", "setKill") {
			MEMBER("gamekill", _this);
		};

		PUBLIC FUNCTION("", "getKill") {
			private ["_kill"];
			_kill = MEMBER("gamekill", nil);
			if(_kill < 1) then { _kill = 1;	};
			_kill;
		};

		PUBLIC FUNCTION("", "getDeath") {
			private ["_death"];
			_death = MEMBER("gamedeath", nil);
			if(_death < 1) then { _death = 1; };
			_death;
		};

		PUBLIC FUNCTION("", "getGlobalRatio") {
			MEMBER("globalratio", nil);
		};

		PUBLIC FUNCTION("", "getRatio") {
			private ["_death", "_ratio", "_kill"];

			_kill =  MEMBER("getKill", nil);
			_death = MEMBER("getDeath", nil);
			if(_death < 5) then {
				_ratio = 0;
			} else {
				_ratio = _kill / _death;
			};
			_ratio;
		};

		PUBLIC FUNCTION("scalar", "getRank") {
			private ["_ratio", "_rank"];
			
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

		PUBLIC FUNCTION("", "compute") {
			private ["_array", "_death", "_globalnumber", "_ratio", "_kill"];
			_kill = MEMBER("globalkill", nil) + MEMBER("gamekill", nil);
			_death = MEMBER("globaldeath", nil) + MEMBER("gamedeath", nil);
			_ratio = ((MEMBER("globalnumber", nil) * MEMBER("globalratio", nil)) + MEMBER("getRatio", nil)) / (MEMBER("globalnumber", nil) + 1);
			_globalnumber = MEMBER("globalnumber", nil) + 1;
			_array = [_kill, _death, _ratio, _globalnumber];
			_array;
		};		

		PUBLIC FUNCTION("","deconstructor") { 
			DELETE_VARIABLE("uid");
			DELETE_VARIABLE("globalkill");
			DELETE_VARIABLE("globaldeath");
			DELETE_VARIABLE("globalratio");
			DELETE_VARIABLE("globalnumber");
			DELETE_VARIABLE("gamekill");
			DELETE_VARIABLE("gamedeath");
		};
	ENDCLASS;