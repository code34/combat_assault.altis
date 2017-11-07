	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2016-2017 Nicolas BOITEUX

	CLASS OO_PLAYERSMARKER
	
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

	CLASS("OO_PLAYERSMARKER")
		PRIVATE VARIABLE("array","list");
		PRIVATE VARIABLE("array","markers");
		PRIVATE VARIABLE("code","hashmap");
		
		PUBLIC FUNCTION("array","constructor") {
			DEBUG(#, "OO_PLAYERSMARKER::constructor")		
			MEMBER("list", []);
			MEMBER("markers", []);
			private _hashmap  = ["new", []] call OO_HASHMAP;
			MEMBER("hashmap", _hashmap);
		};

		PUBLIC FUNCTION("string","addPlayer") {
			DEBUG(#, "OO_PLAYERSMARKER::addPlayer")	
			private _result = false;
			if!(_this in MEMBER("list", _nil)) then {
				MEMBER("list", nil) pushBack _this;
				_result = true;
			};
			_result;
		};

		PUBLIC FUNCTION("string","removePlayer") {
			DEBUG(#, "OO_PLAYERSMARKER::removePlayer")		
			private _array = MEMBER("list", _nil);
			private _result = false;
			private _mark = "";

			if(_this in _array) then {
				_array = _array - [_this];
				MEMBER("list", _array);
				_result = true;
				_mark = ["get", str(_x)] call MEMBER("hashmap", nil);
				if!(isnil "_mark") then { ["delete", _mark] call OO_MARKER; };
				["put", [str(_x), nil]] call MEMBER("hashmap", nil);
			};
			_result;
		};	

		PUBLIC FUNCTION("","start") {
			DEBUG(#, "OO_PLAYERSMARKER::start")	
			while { true } do {
				if(wcwithfriendsmarkers) then {
					MEMBER("draw", nil);
					MEMBER("garbage", nil);
				} else {
					MEMBER("unDraw", nil);
				};
				sleep 5;
			};
		};

		PUBLIC FUNCTION("","garbage") {
			DEBUG(#, "OO_PLAYERSMARKER::garbage")
			private _temp = "";
			private _mark = "";
			private _unit = objNull;
			{
				_mark = _x select 0;
				_unit = _x select 1;
				if( (("getPos" call _mark) distance [0,0] < 100) or !(alive _unit) ) then {
					["remove", str(_unit)] call MEMBER("hashmap", nil);
					["delete", _mark] call OO_MARKER;
					_temp = MEMBER("markers", nil) - [[_mark, _unit]];
					MEMBER("markers", _temp);
				};
			} foreach MEMBER("markers", nil);
		};

		PUBLIC FUNCTION("","draw") {
			DEBUG(#, "OO_PLAYERSMARKER::draw")
			private _mark = "";

			{
				if!(name _x in wcblacklist) then {
					_mark = ["get", str(_x)] call MEMBER("hashmap", nil);
					if(isnil "_mark") then {
						_mark = ["new", [position _x, true]] call OO_MARKER;
						["attachTo", _x] spawn _mark;
						["setText", name _x] spawn _mark;
						["setColor", "ColorGreen"] spawn _mark;
						["setType", "mil_arrow2"] spawn _mark;
						["setSize", [0.5,0.5]] spawn _mark;
						["put", [str(_x), _mark]] call MEMBER("hashmap", nil);
						MEMBER("markers", nil) pushBack [_mark, _x];
					};
				};
			}foreach allPlayers;
		};


		PUBLIC FUNCTION("","unDraw") {
			DEBUG(#, "OO_PLAYERSMARKER::unDraw")
			{
				["remove", str(_x select 1)] call MEMBER("hashmap", nil);
				["delete", (_x select 0)] call OO_MARKER;
			} foreach MEMBER("markers", nil);
			MEMBER("markers", []);
		};

		PUBLIC FUNCTION("","deconstructor") { 
			DEBUG(#, "OO_PLAYERSMARKER::deconstructor")
			DELETE_VARIABLE("list");
			DELETE_VARIABLE("markers");
			DELETE_VARIABLE("hashmap");
		};
	ENDCLASS;