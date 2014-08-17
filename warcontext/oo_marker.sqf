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
		PRIVATE VARIABLE("scalar","markerid");
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
			private ["_mark", "_markerid", "_size", "_text"];

			_markerid = MEMBER("instanceid",nil);
			if (isNil "_markerid") then {_markerid = 0;};
			_markerid = _markerid + 1;
			MEMBER("instanceid",_markerid);
			MEMBER("markerid",_markerid);
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
			MEMBER("Draw", "");
		};

		PUBLIC FUNCTION("string", "Draw") {
			private ["_mark"];
			_mark = MEMBER("marker", nil);
			if(!isNil "_mark") then { deletemarker _mark;};
			if!(MEMBER("local", nil)) then {
				_mark = createMarker [format["oo_marker_%1", MEMBER("markerid", nil)], MEMBER("position", nil)];
				_mark setMarkerDir MEMBER("dir", nil);
				_mark setMarkerAlpha MEMBER("alpha", nil);
				_mark setMarkerShape MEMBER("shape", nil);
				_mark setMarkerType MEMBER("type",nil);
				_mark setmarkerbrush MEMBER("brush", nil);
				_mark setmarkercolor MEMBER("color", nil);
				_mark setmarkersize MEMBER("size", nil);
				_mark setmarkertext MEMBER("text", nil);
			} else {
				_mark = createMarkerlocal [format["oo_marker_%1", MEMBER("markerid", nil)], MEMBER("position", nil)];
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

		PUBLIC FUNCTION("bool", "SetLocal") {
			MEMBER("local", _this);
		};

		PUBLIC FUNCTION("string", "SetShape") {
			MEMBER("shape", _this);
			MEMBER("Draw", "");
		};

		PUBLIC FUNCTION("string", "SetType") {
			MEMBER("type", _this);
			MEMBER("Draw", "");
		};

		PUBLIC FUNCTION("string", "SetBrush") {
			MEMBER("brush", _this);
			MEMBER("Draw", "");
		};

		PUBLIC FUNCTION("string", "SetColor") {
			MEMBER("color", _this);
			MEMBER("Draw", "");
		};

		PUBLIC FUNCTION("array", "SetSize") {
			MEMBER("size", _this);
			MEMBER("Draw", "");
		};

		PUBLIC FUNCTION("string", "SetText") {
			MEMBER("text", _this);
			MEMBER("Draw", "");
		};

		PUBLIC FUNCTION("array", "SetPos") {
			MEMBER("position", _this);
			MEMBER("Draw", "");
		};

		PUBLIC FUNCTION("scalar", "SetAlpha") {
			MEMBER("alpha", _this);
			MEMBER("Draw", "");
		};

		PUBLIC FUNCTION("scalar", "SetDir") {
			MEMBER("dir", _this);
			MEMBER("Draw", "");
		};

		PUBLIC FUNCTION("object", "Attach") {
			MEMBER("attached", true);
			while {MEMBER("attached", nil)} do {
				MEMBER("dir", getdir _this);
				MEMBER("SetPos", position _this);
				sleep 0.1;
			};
		};

		PUBLIC FUNCTION("", "Detach") {
			MEMBER("attached", false);
		};

		PUBLIC FUNCTION("scalar", "Blink") {
			private ["_time"];
			_time = _this;
			MEMBER("blinked", true);
			while {MEMBER("blinked", nil)} do {
				MEMBER("SetAlpha", 0);
				sleep _time;
				MEMBER("SetAlpha", 1);
				sleep _time;
			};
		};

		PUBLIC FUNCTION("", "Unblink") {
			MEMBER("blinked", false);
		};

		PUBLIC FUNCTION("scalar", "Fadein") {
			private ["_time", "_fade"];
			_time = (_this / 100);
			for "_fade" from 0 to 1 step 0.01 do {
				MEMBER("SetAlpha", _fade);
				sleep _time;
			};
		};

		PUBLIC FUNCTION("scalar", "Fadeoff") {
			private ["_time", "_fade"];
			_time = (_this / 100);
			for "_fade" from 1 to 0 step -0.01 do {
				MEMBER("SetAlpha", _fade);
				sleep _time;
			};
		};


		PUBLIC FUNCTION("","deconstructor") { 
			deleteMarker MEMBER("marker", nil);
			DELETE_VARIABLE("markerid");
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