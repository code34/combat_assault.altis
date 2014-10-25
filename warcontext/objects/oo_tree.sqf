	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014 Nicolas BOITEUX

	CLASS OO_TREE
	
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

	CLASS("OO_TREE")

		PRIVATE VARIABLE("code","root");

		PUBLIC FUNCTION("array","constructor") {
			_root = ["new", [0,0]] call OO_NODE;
			MEMBER("root", _root);
		};

		PUBLIC FUNCTION("","getRoot") FUNC_GETVAR("root");

		PUBLIC FUNCTION("string", "searchKey") {
			private ["_node", "_scalars", "_counter", "_length"];

			_scalars = toArray (_this);
			_node = MEMBER("root", nil);

			{
				scopeName "oo_tree_searchkey";
				_node = ["nextChild", _x ] call _node;
				if(typename _node == "SCALAR") then {
					_node = MEMBER("root", nil); 
					breakout "oo_tree_searchkey";
				};
				sleep 0.0000001;
			}foreach _scalars;
			_node;
		};

		PUBLIC FUNCTION("array", "put") {
			private ["_key", "_value", "_node", "_scalars", "_counter", "_length", "_scalar"];

			_key = _this select 0;
			_value = _this select 1;

			_scalars = toArray (_key);
			_node = MEMBER("root", nil);
			_counter = 0;
			_length = count _scalars;

			while { _counter < _length } do {		
				scopeName "oo_tree_put";
				_scalar = _scalars select _counter;
				if(typename (["nextChild", _scalar ] call _node) == "SCALAR") then {
					breakout "oo_tree_put";
				} else {
					_node = ["nextChild", _scalar ] call _node;
					_counter = _counter + 1;
				};
				sleep 0.0000001;
			};

			while { _counter < _length } do {
				_scalar = _scalars select _counter;
				_node = ["addChild", _scalar] call _node;
				_counter = _counter + 1;
				sleep 0.0000001;
			};

			["setValue", [_value]] call _node;
		};

		PUBLIC FUNCTION("string", "get") {
			private ["_key", "_node"];
			_key = _this;
			_node = MEMBER("searchKey", _key);
			("getValue" call _node) select 0;
		};

		PUBLIC FUNCTION("string", "remove") {
			private ["_scalar", "_node", "_scalars", "_counter", "_length", "_array", "_remove"];

			_scalars = toArray (_this);
			_node = MEMBER("root", nil);
			_array = [_node];

			{
				_node = ["nextChild", _x ] call _node;
				_array = [_node] + _array ;
				sleep 0.0000001;
			}foreach _scalars;

			["setValue", []] call (_array select 0);
			
			// si le noeud n'a pas d enfant
			// si le noeud n'a pas de valeur
			// recuperer le scalar du noeud courant
			// remonter au pere
			// supprimer le fils avec le scalar
			// retirer la reference du fils

			_remove = false;
			{
				if(_remove) then {
					["removeChild", _scalar] call _x;
					_remove = false;
				};
				if(count ("getChildrens" call _x) == 0) then {
					if(count ("getValue" call _x) == 0) then {
						_scalar = "getCurrent" call _x;
						if(_scalar > 0) then {
							["delete", _x] call OO_NODE;
							_remove = true;
						};
					};
				};
				sleep 0.0000001;
			}foreach _array;
		};

		PUBLIC FUNCTION("", "entrySet") {
			_node = MEMBER("root", nil);
			"parseChildEntrySet" call _node;
		};

		PUBLIC FUNCTION("", "keySet") {
			_node = MEMBER("root", nil);
			"parseChildKeySet" call _node;
		};

		PUBLIC FUNCTION("", "size") {
			count MEMBER("entrySet", nil);
		};


		PUBLIC FUNCTION("","deconstructor") { 
			DELETE_VARIABLE("root");
		};
	ENDCLASS;