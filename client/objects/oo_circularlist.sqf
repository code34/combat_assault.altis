	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014-2015 Nicolas BOITEUX

	CLASS OO_CIRCULARLIST
	
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

	CLASS("OO_CIRCULARLIST")
		PRIVATE VARIABLE("scalar","index");
		PRIVATE VARIABLE("array","list");
		PRIVATE VARIABLE("code","condition");

		PUBLIC FUNCTION("array","constructor") {
			MEMBER("index", 0);
			MEMBER("list", _this);
		};

		PUBLIC FUNCTION("array","set") {
			MEMBER("index", 0);
			MEMBER("list", _this);
		};

		PUBLIC FUNCTION("array","getPrev") {
			private ["_index", "_continue", "_element", "_count", "_size", "_condition", "_return"];
			
			_condition = _this select 0;
			_return = _this select 1;

			_continue = true;
			_count = -1;
			
			_size = count MEMBER("list", nil) - 1;
			_index = MEMBER("index", nil);

			while { _continue} do {
				_index = _index - 1;
				if(_index < 0) then { _index = _size;};

				_element = MEMBER("list", nil) select _index;
				_continue = false;
				_count =_count + 1;
				
				if!(_element call _condition) then {
					_continue = true;
				};

				if(_count > _size) then {
					_continue = false;
					_element = _return;
				};
				sleep 0.01;
			};
			MEMBER("index", _index);
			_element;
		};

		PUBLIC FUNCTION("array","getNext") {
			private ["_index", "_continue", "_element", "_count", "_size", "_condition", "_return"];
			
			_condition = _this select 0;
			_return = _this select 1;

			_continue = true;
			_count = -1;

			_size = count MEMBER("list", nil) - 1;
			_index = MEMBER("index", nil);
			
			while { _continue} do {
				_index = _index + 1;
				if(_index > _size) then { _index = 0;};
				
				_element = MEMBER("list", nil) select _index;
				_continue = false;
				_count =_count + 1;
				
				if!(_element call _condition) then {
					_continue = true;
				} else {
					if(_count > _size) then {
						_continue = false;
						_element = _return;
					};
				};
				sleep 0.01;
			};
			MEMBER("index", _index);
			_element;
		};
		
		PUBLIC FUNCTION("","deconstructor") { 
			DELETE_VARIABLE("condition");
			DELETE_VARIABLE("index");
			DELETE_VARIABLE("list");
		};
	ENDCLASS;