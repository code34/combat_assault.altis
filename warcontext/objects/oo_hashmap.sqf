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
		PRIVATE STATIC_VARIABLE("scalar","instanceid");
		PRIVATE VARIABLE("array","index");
		PRIVATE VARIABLE("scalar","keyid");

		PUBLIC FUNCTION("array","constructor") {
			private ["_array", "_instanceid"];
			_array = [];
			MEMBER("index", _array);

			_instanceid = MEMBER("instanceid",nil);
			if (isNil "_instanceid") then {_instanceid = 0;};
			_instanceid = _instanceid + 1;
			MEMBER("instanceid",_instanceid);
			MEMBER("keyid", _instanceid);
		};

		// Removes all of the mappings from this map.
		PUBLIC FUNCTION("", "clear") {
			private ["_array", "_hash"];
			
			{
				_hash = MEMBER("keyName", _x);
				missionNamespace setVariable [_hash, nil];
			}foreach MEMBER("index", nil);
			_array = [];
			MEMBER("index", _array);
		};		

		PUBLIC FUNCTION("string", "keyName") {
			"HSHKEY"+ str(MEMBER("keyid", nil)) + "_" + _this;
		};

		// Returns true if this map contains a mapping for the specified key.
		PUBLIC FUNCTION("string", "containsKey") {
			private ["_hash", "_set"];
			_hash = MEMBER("keyName", _this);
			_set = missionNamespace getVariable _hash;
			if(isnil "_set") then {false;} else {true;};
		};

		// Returns true if this map contains a mapping for the specified value
		PUBLIC FUNCTION("array", "containsValue") {
			private ["_search", "_value", "_return"];

			_search = _this select 0;

			_return = false;
			{
				_value = MEMBER("get", _x);
				if(_value isequalto _search) then {
					_return = true;
				};
			}foreach MEMBER("index", nil);
			_return;			
		};

		// Returns a set view of the mappings contained in this map.
		PUBLIC FUNCTION("","entrySet"){
			private ["_array", "_value"];
			_array = [];
			{
				_value = MEMBER("get", _x);
				_array = _array + [_value];
			}foreach MEMBER("index", nil);
			_array;
		};

		// Returns the value to which the specified key is mapped, or null if this map contains no mapping for the key.
		PUBLIC FUNCTION("string", "get") {
			private ["_key", "_hash"];

			_key = _this;

			if(isnil "_key") exitwith {false};
			if!(typename _key == "STRING") exitwith {false};			

			_hash = MEMBER("keyName", _key);
			missionNamespace getVariable _hash;
		};

		// Returns true if this map contains no key-value mappings.
		PUBLIC FUNCTION("", "isEmpty") {
			if(count MEMBER("index", nil) == 0) then { true; } else { false };
		};

		//Returns a Set view of the keys contained in this map.
		PUBLIC FUNCTION("","keySet") FUNC_GETVAR("index");

		// Associates the specified value with the specified key in this map.
		PUBLIC FUNCTION("array", "put") {
			private ["_array", "_key", "_index", "_value", "_set", "_hash"];

			_key = _this select 0;
			_value = _this select 1;

			if(isnil "_key") exitwith {false};
			if!(typename _key == "STRING") exitwith {false};

			_hash = MEMBER("keyName", _key);
			_set = missionNamespace getVariable _hash;
			
			if(isnil "_set") then {
				_array = MEMBER("index", nil) + [_key];
				MEMBER("index", _array);
			} ;
			missionNamespace setVariable [_hash, _value];
		};

		// Removes the mapping for the specified key from this map if present.
		PUBLIC FUNCTION("string", "remove") {
			private ["_key", "_index", "_value"];

			_key = _this;

			if(isnil "_key") exitwith {false};
			_hash = MEMBER("keyName", _key);
			_array = MEMBER("index", nil) - [_key];
			MEMBER("index", _array);
			missionNamespace setVariable [_hash, nil];
		};

		// Returns the number of key-value mappings in this map
		PUBLIC FUNCTION("", "size") {
			count MEMBER("index", nil);
		};

		PUBLIC FUNCTION("","deconstructor") { 
			DELETE_VARIABLE("index");
			DELETE_VARIABLE("keyid");
		};
	ENDCLASS;