	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2013 Nicolas BOITEUX

	CLASS OO_MARKER
	
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

	CLASS("OO_MARKER")
		PRIVATE STATIC_VARIABLE("scalar","instanceid");
		PRIVATE VARIABLE("string","name");
		PRIVATE VARIABLE("array","position");
		PRIVATE VARIABLE("string","marker");
		PRIVATE VARIABLE("bool","blinked");
		PRIVATE VARIABLE("bool","attached");
		PRIVATE VARIABLE("bool","local");
		PRIVATE VARIABLE("scalar","dir");
		PRIVATE VARIABLE("scalar","alpha");
		PRIVATE VARIABLE("string","shape");
		PRIVATE VARIABLE("string","type");
		PRIVATE VARIABLE("string","brush");
		PRIVATE VARIABLE("string","color");
		PRIVATE VARIABLE("string","text");
		PRIVATE VARIABLE("array","size");

		PUBLIC FUNCTION("array","constructor") {
			private ["_instanceid", "_mark", "_name", "_size", "_text"];

			_instanceid = MEMBER("instanceid",nil);
			if (isNil "_instanceid") then {_instanceid = 0;};
			_instanceid = _instanceid + 1;
			MEMBER("instanceid",_instanceid);

			if(isDedicated) then {
				_name = format["SRV_OO_MRK_%1", _instanceid];
			} else {
				_name = format["%1_OO_MRK_%2", name player, _instanceid];				
			};		

			MEMBER("name",_name);
			MEMBER("local", true);
			MEMBER("position", _this);
			MEMBER("dir", 0);
			MEMBER("alpha", 1);
			MEMBER("shape", "ICON");
			MEMBER("type", "mil_dot");
			MEMBER("brush", "Solid");
			MEMBER("color", "ColorBlack");
			_size = [1,1];
			MEMBER("size", _size);
			MEMBER("text", "");
			MEMBER("draw", "");
		};

		PUBLIC FUNCTION("","getName") FUNC_GETVAR("name");
		PUBLIC FUNCTION("","getPosition") FUNC_GETVAR("position");
		PUBLIC FUNCTION("","getDir") FUNC_GETVAR("dir");
		PUBLIC FUNCTION("","getAlpha") FUNC_GETVAR("alpha");
		PUBLIC FUNCTION("","getShape") FUNC_GETVAR("shape");
		PUBLIC FUNCTION("","getType") FUNC_GETVAR("type");
		PUBLIC FUNCTION("","getBrush") FUNC_GETVAR("brush");
		PUBLIC FUNCTION("","getColor") FUNC_GETVAR("color");
		PUBLIC FUNCTION("","getSize") FUNC_GETVAR("size");
		PUBLIC FUNCTION("","getText") FUNC_GETVAR("text");

		PUBLIC FUNCTION("","isBlinked") FUNC_GETVAR("blinked");
		PUBLIC FUNCTION("","isAttached") FUNC_GETVAR("attached");
		PUBLIC FUNCTION("","isLocal") FUNC_GETVAR("local");

		PUBLIC FUNCTION("string", "draw") {
			private ["_mark"];
			_mark = MEMBER("marker", nil);
			if(!isNil "_mark") then { deletemarker _mark;};
			if!(MEMBER("isLocal", nil)) then {
				_mark = createMarker [MEMBER("name", nil), MEMBER("position", nil)];
				_mark setMarkerDir MEMBER("dir", nil);
				_mark setMarkerAlpha MEMBER("alpha", nil);
				_mark setMarkerShape MEMBER("shape", nil);
				_mark setMarkerType MEMBER("type",nil);
				_mark setmarkerbrush MEMBER("brush", nil);
				_mark setmarkercolor MEMBER("color", nil);
				_mark setmarkersize MEMBER("size", nil);
				_mark setmarkertext MEMBER("text", nil);
			} else {
				_mark = createMarkerlocal [MEMBER("name", nil), MEMBER("position", nil)];
				_mark setMarkerDirlocal MEMBER("dir", nil);
				_mark setMarkerAlphalocal MEMBER("alpha", nil);
				_mark setMarkerShapelocal MEMBER("shape", nil);
				_mark setMarkerTypelocal MEMBER("type",nil);
				_mark setmarkerbrushlocal MEMBER("brush", nil);
				_mark setmarkercolorlocal MEMBER("color", nil);
				_mark setmarkersizelocal MEMBER("size", nil);
				_mark setmarkertextlocal MEMBER("text", nil);
			};
			MEMBER("marker", _mark);
		};

		PUBLIC FUNCTION("string", "setName") {
			MEMBER("name", _this);
		};

		PUBLIC FUNCTION("bool", "setLocal") {
			MEMBER("local", _this);
		};

		PUBLIC FUNCTION("string", "setShape") {
			MEMBER("shape", _this);
			MEMBER("draw", "");
		};

		PUBLIC FUNCTION("string", "setType") {
			MEMBER("type", _this);
			MEMBER("draw", "");
		};

		PUBLIC FUNCTION("string", "setBrush") {
			MEMBER("brush", _this);
			MEMBER("draw", "");
		};

		PUBLIC FUNCTION("string", "setColor") {
			MEMBER("color", _this);
			MEMBER("draw", "");
		};

		PUBLIC FUNCTION("array", "setSize") {
			MEMBER("size", _this);
			MEMBER("draw", "");
		};

		PUBLIC FUNCTION("string", "setText") {
			MEMBER("text", _this);
			MEMBER("draw", "");
		};

		PUBLIC FUNCTION("array", "setPos") {
			MEMBER("position", _this);
			MEMBER("draw", "");
		};

		PUBLIC FUNCTION("scalar", "setAlpha") {
			MEMBER("alpha", _this);
			MEMBER("draw", "");
		};

		PUBLIC FUNCTION("scalar", "setDir") {
			MEMBER("dir", _this);
			MEMBER("draw", "");
		};

		PUBLIC FUNCTION("object", "attachTo") {
			MEMBER("attached", true);
			while {MEMBER("attached", nil)} do {
				MEMBER("dir", getdir _this);
				MEMBER("setPos", position _this);
				sleep 0.1;
			};
		};

		PUBLIC FUNCTION("", "detach") {
			MEMBER("attached", false);
		};

		PUBLIC FUNCTION("scalar", "blink") {
			private ["_time"];
			_time = _this;
			MEMBER("blinked", true);
			while {MEMBER("blinked", nil)} do {
				MEMBER("setAlpha", 0);
				sleep _time;
				MEMBER("setAlpha", 1);
				sleep _time;
			};
		};

		PUBLIC FUNCTION("", "unblink") {
			MEMBER("blinked", false);
		};

		PUBLIC FUNCTION("scalar", "fadeIn") {
			private ["_time", "_fade"];
			_time = (_this / 100);
			for "_fade" from 0 to 1 step 0.01 do {
				MEMBER("setAlpha", _fade);
				sleep _time;
			};
		};

		PUBLIC FUNCTION("scalar", "fadeOff") {
			private ["_time", "_fade"];
			_time = (_this / 100);
			for "_fade" from 1 to 0 step -0.01 do {
				MEMBER("setAlpha", _fade);
				sleep _time;
			};
		};


		PUBLIC FUNCTION("","deconstructor") { 
			deleteMarker MEMBER("marker", nil);
			DELETE_VARIABLE("name");
			DELETE_VARIABLE("attached");
			DELETE_VARIABLE("blinked");
			DELETE_VARIABLE("marker");
			DELETE_VARIABLE("position");
			DELETE_VARIABLE("local");
			DELETE_VARIABLE("alpha");
			DELETE_VARIABLE("shape");
			DELETE_VARIABLE("type");
			DELETE_VARIABLE("brush");
			DELETE_VARIABLE("color");
		};
	ENDCLASS;