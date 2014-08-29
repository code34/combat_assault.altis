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
		PRIVATE VARIABLE("string","marker");
		PRIVATE VARIABLE("bool","blinked");
		PRIVATE VARIABLE("bool","attached");
		PRIVATE VARIABLE("bool","local");

		PUBLIC FUNCTION("array","constructor") {
			private ["_instanceid", "_mark", "_name"];

			_instanceid = MEMBER("instanceid",nil);
			if (isNil "_instanceid") then {_instanceid = 0;};
			_instanceid = _instanceid + 1;
			MEMBER("instanceid",_instanceid);

			if(isDedicated) then {
				_name = format["SRV_OO_MRK_%1", _instanceid];
			} else {
				_name = format["%1_OO_MRK_%2", name player, _instanceid];				
			};		

			MEMBER("name", _name);
			MEMBER("local", false);
			MEMBER("draw", _this);
		};

		PUBLIC FUNCTION("","isBlinked") FUNC_GETVAR("blinked");
		PUBLIC FUNCTION("","isAttached") FUNC_GETVAR("attached");
		PUBLIC FUNCTION("","isLocal") FUNC_GETVAR("local");
		PUBLIC FUNCTION("","getName") FUNC_GETVAR("name");
		PUBLIC FUNCTION("","getMarker") FUNC_GETVAR("marker");

		PRIVATE FUNCTION("array", "draw") {
			private ["_mark"];

			if!(MEMBER("isLocal", nil)) then {
				_mark = createMarker [MEMBER("name", nil), _this];
				_mark setMarkerDir 0;
				_mark setMarkerAlpha 1;
				_mark setMarkerShape "ICON";
				_mark setMarkerType "mil_dot";
				_mark setmarkerbrush "Solid";
				_mark setmarkercolor "ColorBlack";
				_mark setmarkersize [1,1];
				_mark setmarkertext "";
			} else {
				_mark = createMarkerlocal [MEMBER("name", nil), _this];
				_mark setMarkerDirlocal 0;
				_mark setMarkerAlphalocal 1;
				_mark setMarkerShapelocal "ICON";
				_mark setMarkerTypelocal "mil_dot";
				_mark setmarkerbrushlocal "Solid";
				_mark setmarkercolorlocal "ColorBlack";
				_mark setmarkersizelocal [1,1];
				_mark setmarkertextlocal "";
			};
			MEMBER("marker", _mark);
		};

		PRIVATE FUNCTION("", "undraw") {
			deletemarker MEMBER("marker", nil);
		};

		PUBLIC FUNCTION("string", "setName") {
			MEMBER("name", _this);
		};

		PUBLIC FUNCTION("bool", "setLocal") {
			private ["_position", "_dir", "_alpha", "_shape", "_type", "_brush", "_color", "_size", "_text"];

			MEMBER("local", _this);

			_position = MEMBER("getPos", nil);
			_dir = MEMBER("getDir", nil);
			_alpha = MEMBER("getAlpha", nil);
			_shape = MEMBER("getShape", nil);
			_type = MEMBER("getType", nil);
			_brush = MEMBER("getBrush", nil);
			_color = MEMBER("getColor", nil);
			_size = MEMBER("getSize", nil);
			_text = MEMBER("getText", nil);

			MEMBER("undraw", nil);
			MEMBER("draw", _position);

			MEMBER("setDir", _dir);
			MEMBER("setAlpha", _alpha);
			MEMBER("setShape", _shape);
			MEMBER("setType", _type);
			MEMBER("setBrush", _brush);
			MEMBER("setColor", _color);
			MEMBER("setSize", _size);
			MEMBER("setText", _text);
		};

		PUBLIC FUNCTION("","getShape") {
			markerShape MEMBER("marker", nil);
		};

		PUBLIC FUNCTION("string", "setShape") {
			if!(MEMBER("isLocal", nil)) then {
				MEMBER("marker", nil) setMarkerShape _this;
			} else {
				MEMBER("marker", nil) setMarkerShapelocal _this;
			};
		};

		PUBLIC FUNCTION("","getType") {
			markerType MEMBER("marker", nil);
		};

		PUBLIC FUNCTION("string", "setType") {
			if!(MEMBER("isLocal", nil)) then {
				MEMBER("marker", nil) setMarkerType _this;
			} else {
				MEMBER("marker", nil) setMarkerTypelocal _this;
			};
		};

		PUBLIC FUNCTION("","getBrush") {
			markerBrush MEMBER("marker", nil);
		};

		PUBLIC FUNCTION("string", "setBrush") {
			if!(MEMBER("isLocal", nil)) then {
				MEMBER("marker", nil) setmarkerbrush _this;
			} else {
				MEMBER("marker", nil) setmarkerbrushlocal _this;
			};
		};

		PUBLIC FUNCTION("","getColor") {
			markerColor MEMBER("marker", nil);
		};

		PUBLIC FUNCTION("string", "setColor") {
			if!(MEMBER("isLocal", nil)) then {
				MEMBER("marker", nil) setmarkercolor _this;
			} else {
				MEMBER("marker", nil) setmarkercolorlocal _this;
			};
		};

		PUBLIC FUNCTION("","getSize") {
			markerSize MEMBER("marker", nil);
		};

		PUBLIC FUNCTION("array", "setSize") {
			if!(MEMBER("isLocal", nil)) then {
				MEMBER("marker", nil) setmarkersize _this;
			} else {
				MEMBER("marker", nil) setmarkersizelocal _this;
			};
		};

		PUBLIC FUNCTION("","getText") {
			markerText MEMBER("marker", nil);
		};

		PUBLIC FUNCTION("string", "setText") {
			if!(MEMBER("isLocal", nil)) then {
				MEMBER("marker", nil) setmarkertext _this;
			} else {
				MEMBER("marker", nil) setmarkertextlocal _this;
			};
		};

		PUBLIC FUNCTION("","getPos") {
			markerPos MEMBER("marker", nil);
		};

		PUBLIC FUNCTION("array", "setPos") {
			if!(MEMBER("isLocal", nil)) then {
				MEMBER("marker", nil) setMarkerPos _this;
			} else {
				MEMBER("marker", nil) setMarkerPos _this;
			};
		};

		PUBLIC FUNCTION("","getAlpha") {
			markerAlpha MEMBER("marker", nil);
		};

		PUBLIC FUNCTION("scalar", "setAlpha") {
			if!(MEMBER("isLocal", nil)) then {
				MEMBER("marker", nil) setMarkerAlpha _this;
			} else {
				MEMBER("marker", nil) setMarkerAlphalocal _this;
			};
		};

		PUBLIC FUNCTION("","getDir") {
			markerDir MEMBER("marker", nil);
		};

		PUBLIC FUNCTION("scalar", "setDir") {
			if!(MEMBER("isLocal", nil)) then {
				MEMBER("marker", nil) setMarkerDir _this;
			} else {
				MEMBER("marker", nil) setMarkerDirlocal _this;
			};
		};

		PUBLIC FUNCTION("object", "attachTo") {
			MEMBER("attached", true);
			while {MEMBER("attached", nil)} do {
				MEMBER("setDir", getDir _this);
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
			MEMBER("undraw", nil);
			DELETE_VARIABLE("name");
			DELETE_VARIABLE("attached");
			DELETE_VARIABLE("blinked");
			DELETE_VARIABLE("marker");
			DELETE_VARIABLE("local");
		};
	ENDCLASS;