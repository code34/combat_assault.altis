	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014 Nicolas BOITEUX

	CLASS OO_NODE
	
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

	CLASS("OO_NODE")
		PRIVATE VARIABLE("scalar","parent");
		PRIVATE VARIABLE("scalar","current");
		PRIVATE VARIABLE("array","childrens");
		PRIVATE VARIABLE("array","value");

		PUBLIC FUNCTION("array","constructor") {
			private["_array"];
			_array = [];
			MEMBER("parent", _this select 0);
			MEMBER("current", _this select 1);
			MEMBER("childrens", _array);
			MEMBER("value", _array);
		};

		PUBLIC FUNCTION("","getCurrent") FUNC_GETVAR("current");
		PUBLIC FUNCTION("","getParent") FUNC_GETVAR("parent");
		PUBLIC FUNCTION("","getChildrens") FUNC_GETVAR("childrens");

		PUBLIC FUNCTION("", "getValue") {
			MEMBER("value", nil);
		};

		PUBLIC FUNCTION("scalar", "nextChild") {
			private ["_return", "_scalar"];

			_scalar = _this;
			_return = -1;

			{
				scopename "oo_node_nextchild";
				if(_scalar == _x select 0) then {
					_return = _x select 1;
					breakout "oo_node_nextchild";
				};
				sleep 0.0001;
			}foreach MEMBER("childrens", nil);
			_return;
		};

		PUBLIC FUNCTION("", "parseChildKeySet") {
			private ["_array", "_value"];
			_array = [];
			{
				_array = _array + ("parseChildKeySet" call (_x select 1));
				_value = "getCurrent" call (_x select 1);
				if(_value > 0) then {
					_array = _array + [_value];
				};
				sleep 0.0001;
			}foreach MEMBER("childrens", nil);
			_array;
		};

		PUBLIC FUNCTION("", "parseChildEntrySet") {
			private ["_array", "_value"];
			_array = [];
			{
				_array = _array + ("parseChildEntrySet" call (_x select 1));
				_value = "getValue" call (_x select 1);
				if(count _value > 0) then {
					_array = _array + _value;
				};
				sleep 0.0001;
			}foreach MEMBER("childrens", nil);
			_array;
		};

		PUBLIC FUNCTION("", "getChild") {
			private ["_return"];
			if(count MEMBER("childrens", nil) == 0) then { 
				_return = -1;
			} else {
				_return = (MEMBER("childrens",nil) select 0) select 1;
			};
			_return;
		};

		PUBLIC FUNCTION("scalar", "addChild") {
			private ["_array", "_node", "_scalar"];

			_scalar = _this;
			_node = ["new", [MEMBER("current", nil), _scalar]] call OO_NODE;
			_array = MEMBER("childrens", nil);
			_array = _array + [[_scalar, _node]];
			MEMBER("childrens", _array);
			_node;
		};

		PUBLIC FUNCTION("scalar", "removeChild") {
			private ["_array", "_scalar", "_counter"];

			_scalar = _this;
			_array = MEMBER("childrens", nil);

			{
				if(_x select 0 == _scalar) then {
					_array set [_foreachindex, -1];
				};
				sleep 0.0001;
			}foreach _array;
			_array = _array - [-1];
			MEMBER("childrens", _array);
		};

		PUBLIC FUNCTION("array", "setValue") {
			MEMBER("value", _this);
		};

		PUBLIC FUNCTION("","deconstructor") { 
			DELETE_VARIABLE("childrens");
			DELETE_VARIABLE("current");
			DELETE_VARIABLE("parent");
			DELETE_VARIABLE("value");
		};
	ENDCLASS;