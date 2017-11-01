	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2016-2018 Nicolas BOITEUX

	CLASS OO_QUEUE
	
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

	CLASS("OO_QUEUE")
		PRIVATE VARIABLE("array","queue");

		PUBLIC FUNCTION("string","constructor") { 
			MEMBER("queue", []);
		};

		/*
		Return an array containing all the elements of the queue
		Return : array
		*/
		PUBLIC FUNCTION("", "toArray") {
			MEMBER("queue", nil);
		};

		/*
		Count the number of elements in the Queue
		Return : scalar
		*/
		PUBLIC FUNCTION("", "count") {
			private _count = 0;
			{
				if!(isnil "_x") then { _count = _count + count(_x); };
				sleep 0.0001;
			} foreach MEMBER("queue", nil);
			_count;
		};

		/*
		Removes all of the elements from this priority queue
		Return : nothing
		*/
		PUBLIC FUNCTION("", "clearQueue") {
			MEMBER("queue", []);
		};

		/*
		Test if the priority queue is empty 
		Return : boolean 
		*/
		PUBLIC FUNCTION("", "isEmpty") {
			if(MEMBER("count", nil) > 0) then { false; } else { true;};
		};

		/*
		Get next first in element according its priority, and remove it
		Param : default return value, if queue is empty
		Return : default return value
		*/
		PUBLIC FUNCTION("ANY", "get") {
			if(isnil "_this") exitwith { diag_log "OO_QUEUE: getNextPrior requires a return default value";};
			private _result = _this;
			private _index = nil;
			private _array = [];

			{
				scopeName "oo_queue";
				if!(isnil "_x") then {
					If(count _x > 0) then {
						_index = _foreachindex;
						breakout "oo_queue";
					};
				};
				sleep 0.0001;
			} foreach MEMBER("queue", nil);
			if!(isnil "_index") then {
				_array = [_index, _result];
				_result = MEMBER("getInQueue", _array);
			};
			_result;
		};

		/*
		Get the first in element, and remove it, according its priority
		 params : array 
		 	1- priority - (0 highest priority)
		 	2 - default return
		 Return : default return
		*/
		PRIVATE FUNCTION("array","getInQueue") {
			private _queueid = _this select 0;
			private _element = _this select 1;
			private _queue = MEMBER("queue", nil) select _queueid;
			if(count(_queue) > 0) then {_element = _queue deleteat 0; };		
			MEMBER("queue", nil) set [_queueid, _queue];
			_element;
		};

		/*
		Insert an element in priority queue according its priority
		 params : array
		 	1 - priority - (0 highest priority)
		 	2 - Element to insert in the queue
		*/
		PUBLIC FUNCTION("array","put") {
			private _queueid = _this select 0;
			private _element = _this select 1;
			private _queue = [];
			if!(_queueid isEqualType 0) exitwith {false;};	
			if (count MEMBER("queue", nil)  >= _queueid) then { 
				_queue = MEMBER("queue", nil)  select _queueid;
				if(isnil "_queue") then { _queue = []; };
			};			
			_queue pushBack _element;
			MEMBER("queue", nil) set [_queueid, _queue];
			true;
		};

		PUBLIC FUNCTION("","deconstructor") { 
			DELETE_VARIABLE("queue");
		};
	ENDCLASS;