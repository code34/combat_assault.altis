	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014 Nicolas BOITEUX

	CLASS OO_HASMAP
	
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

	CLASS("OO_HASHMAP")
		PRIVATE VARIABLE("array","index");
		PRIVATE VARIABLE("array","map");

		PUBLIC FUNCTION("array","constructor") {
			private ["_array"];
			_array = [];
			MEMBER("index", _array);
			MEMBER("map", _array);
		};

		// Removes all of the mappings from this map.
		PUBLIC FUNCTION("", "Clear") {
			private ["_array"];
			_array = [];
			MEMBER("index", _array);
			MEMBER("map", _array);
		};		


		// Returns true if this map contains a mapping for the specified key.
		PUBLIC FUNCTION("array", "containsKey") {
			private ["_return", "_key"];

			_key = _this select 0;
			_return = false;

			{
				scopename "oo_hashmap_key";
				if(format["%1", _key] == format["%1", _x]) then {
					_return = true;
					breakout "oo_hashmap_key";
				};
				sleep 0.000000001;
			}foreach MEMBER("index", nil);
			_return;
		};

		// Returns true if this map maps one or more keys to the specified value.
		PUBLIC FUNCTION("array", "containsValue") {
			private ["_return", "_value"];

			_value = _this select 0;
			_return = false;

			{
				scopename "oo_hashmap_value";
				if(format["%1", _value] == format["%1", _x]) then {
					_return = true;
					breakout "oo_hashmap_value";
				};
				sleep 0.000000001;
			}foreach MEMBER("map", nil);

			_return;
			
		};

		// Returns a Set view of the mappings contained in this map.
		PUBLIC FUNCTION("","entrySet") FUNC_GETVAR("map");



		// Returns the value to which the specified key is mapped, or null if this map contains no mapping for the key.
		PUBLIC FUNCTION("array", "Get") {
			private ["_key", "_index", "_map", "_return"];

			_key = _this;

			_index = MEMBER("SearchIndex", _key);
			if(_index == -1) then {
				_return = "null";
			} else {
				_return = MEMBER("map", nil) select _index;
			};
			_return;
		};

		// Set the value to which the specified key is mapped, or null if this map contains no mapping for the key.
		PUBLIC FUNCTION("array", "Set") {
			private ["_key", "_index", "_value"];

			_key = [_this select 0];
			_value = _this select 1;

			_index = MEMBER("SearchIndex", _key);				
			MEMBER("map", nil) set [_index, _value];
		};

		// Returns true if this map contains no key-value mappings.
		PUBLIC FUNCTION("", "IsEmpty") {
			if(count MEMBER("index", nil) == 0) then { true; } else { false };
		};

		//Returns a Set view of the keys contained in this map.
		PUBLIC FUNCTION("","keySet") FUNC_GETVAR("index");

		// Associates the specified value with the specified key in this map.
		PUBLIC FUNCTION("array", "Put") {
			private ["_index", "_key", "_map", "_value"];

			_key = [_this select 0];
			_value = [_this select 1];

			if(count _key == 0) exitwith {false};
			_index = MEMBER("index", nil) + _key;
			_map = MEMBER("map", nil) + _value;

			MEMBER("index", _index);
			MEMBER("map", _map);
		};

		// Copies all of the mappings from the specified map to this map.
		PUBLIC FUNCTION("array", "PutAll") {	
			private ["_return", "_extmap", "_index", "_map"];

			_extmap = _this select 0;
			
			_return = true;
			{
				if(MEMBER("containsKey", _x)) then {
					_return = false;
				};
				sleep 0.000000001;
			}foreach ("keySet" call _extmap);

			if(_return) then {
				_index = MEMBER("index", nil) + ("keySet" call _extmap);
				_map = MEMBER("map", nil) + ("entrySet" call _extmap);
				MEMBER("index", _index);
				MEMBER("index", _map);
			};
			_return;
		};

		// Removes the mapping for the specified key from this map if present.
		PUBLIC FUNCTION("array", "Remove") {
			private ["_index", "_map"];

			if(isnil "_this") exitwith {false};

			_index = MEMBER("SearchIndex", _this);
						
			MEMBER("index", nil) set [_index, "hasmapdeletedobject"];
			MEMBER("map", nil) set [_index, "hasmapdeletedobject"];

			_index =  MEMBER("index", nil) - ["hasmapdeletedobject"];
			_map =  MEMBER("map", nil) - ["hasmapdeletedobject"];

			MEMBER("index", _index);
			MEMBER("map", _map);			
		};

		// Returns the number of key-value mappings in this map
		PUBLIC FUNCTION("", "Size") {
			count MEMBER("index", nil);
		};


		// search index of the array for a specific key
		PUBLIC FUNCTION("array", "SearchIndex") {
			private ["_i", "_index", "_key"];
			
			_key = _this select 0;

			_index = -1;
			_i = 0;

			{
				scopename "oo_hashmap_search";
				if(format["%1", _key] == format["%1", _x]) then {
					_index = _i;
					breakout "oo_hashmap_search";
				};
				_i = _i + 1;
				sleep 0.000000001;
			}foreach MEMBER("index", nil);
			_index;
		};


		PUBLIC FUNCTION("","deconstructor") { 
			DELETE_VARIABLE("index");
			DELETE_VARIABLE("map");
		};
	ENDCLASS;