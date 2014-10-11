	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014 Nicolas BOITEUX

	CLASS OO_GRID STRATEGIC GRID
	
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

	CLASS("OO_GRID")
		PRIVATE VARIABLE("scalar","markerindex");
		PRIVATE VARIABLE("scalar","xstart");
		PRIVATE VARIABLE("scalar","ystart");
		PRIVATE VARIABLE("scalar","xsize");
		PRIVATE VARIABLE("scalar","ysize");
		PRIVATE VARIABLE("scalar","xsector");
		PRIVATE VARIABLE("scalar","ysector");
		PRIVATE VARIABLE("array","gridmarker");
		PRIVATE VARIABLE("array","playersector");
		PRIVATE VARIABLE("bool","monitored");
		PRIVATE VARIABLE("bool","printed");

		PUBLIC FUNCTION("array","constructor") {
			private["_array"];
			_array = [];
			MEMBER("markerindex", 0);
			MEMBER("gridmarker", _array);
			MEMBER("playersector", _array);
			MEMBER("monitored", false);
			MEMBER("printed", false);
			MEMBER("xsize", _this select 0);
			MEMBER("ysize", _this select 1);
			MEMBER("xsector", _this select 2);
			MEMBER("ysector", _this select 3);
			MEMBER("xstart", MEMBER("xsector", nil) / 2);
			MEMBER("ystart", MEMBER("ysector", nil) / 2);
		};	
		PUBLIC FUNCTION("scalar","setXstart") {
			MEMBER("xstart", _this);
		};
		PUBLIC FUNCTION("scalar","setYstart") {
			MEMBER("ystart", _this);
		};
		PUBLIC FUNCTION("scalar","setXsize") {
			MEMBER("xsize", _this);
		};
		PUBLIC FUNCTION("scalar","setYsize") {
			MEMBER("ysize", _this);
		};
		PUBLIC FUNCTION("scalar","setXsector") {
			MEMBER("xsector", _this);
		};
		PUBLIC FUNCTION("scalar","setYsector") {
			MEMBER("ysector", _this);
		};
		PUBLIC FUNCTION("","getXstart") FUNC_GETVAR("xstart");
		PUBLIC FUNCTION("","getYstart") FUNC_GETVAR("ystart");
		PUBLIC FUNCTION("","getXsize") FUNC_GETVAR("xsize");
		PUBLIC FUNCTION("","getYsize") FUNC_GETVAR("ysize");
		PUBLIC FUNCTION("","getXsector") FUNC_GETVAR("xsector");
		PUBLIC FUNCTION("","getYsector") FUNC_GETVAR("ysector");
		PUBLIC FUNCTION("","getPlayersector") FUNC_GETVAR("playersector");

		PUBLIC FUNCTION("string", "Draw") {

			private["_index", "_marker", "_y", "_x", "_position", "_gridmarker", "_sector"];

			MEMBER("xstart", MEMBER("xsector", nil) / 2);
			MEMBER("ystart", MEMBER("ysector", nil) / 2);

			_index = 0;
			_gridmarker = MEMBER("gridmarker", nil);

			for "_y" from MEMBER("ystart", nil) to MEMBER("ysize", nil) step MEMBER("ysector", nil) do {
				for "_x" from MEMBER("xstart", nil) to MEMBER("xsize", nil) step MEMBER("xsector", nil) do {

					_position = [_x, _y];
					_sector = MEMBER("getSectorFromPos", _position);

					_marker = createMarker [format["mrk_text_%1", _index], _position];
					_marker setMarkerShape "ICON";
					_marker setMarkerType "mil_triangle";
					_marker setmarkerbrush "Solid";
					_marker setmarkercolor "ColorBlack";
					_marker setmarkersize [0.5,0.5];

					_marker setmarkertext format["%1", _sector];
					_gridmarker = _gridmarker + [_marker];
		
					_marker = createMarker [format["mrk_grid_%1", _index], _position];
					_marker setMarkerShape "RECTANGLE";
					_marker setMarkerType "mil_triangle";
					_marker setmarkerbrush "Border";
					_marker setmarkercolor "ColorBlack";
					_marker setmarkersize [(MEMBER("xsector", nil)/2),(MEMBER("ysector", nil)/2)];
					_gridmarker = _gridmarker + [_marker];
					_index = _index + 1;
				};
			};
			MEMBER("gridmarker", _gridmarker);
		};

		PUBLIC FUNCTION("array", "DrawSector") {
			private ["_index", "_gridmarker", "_marker", "_sector"];

			_sector = _this;
			_index = MEMBER("markerindex", nil);
			_gridmarker = MEMBER("gridmarker", nil);

			_position = MEMBER("getPosFromSector", _sector);

			_marker = createMarker [format["mrk_text_%1", _index], _position];
			_marker setMarkerShape "ICON";
			_marker setMarkerType "mil_triangle";
			_marker setmarkerbrush "Solid";
			_marker setmarkercolor "ColorBlack";
			_marker setmarkersize [0.5,0.5];

			_marker setmarkertext format["%1", _sector];
			_gridmarker = _gridmarker + [_marker];
		
			_marker = createMarker [format["mrk_grid_%1", _index], _position];
			_marker setMarkerShape "RECTANGLE";
			_marker setMarkerType "mil_triangle";
			_marker setmarkerbrush "Border";
			_marker setmarkercolor "ColorBlack";
			_marker setmarkersize [(MEMBER("xsector", nil)/2),(MEMBER("ysector", nil)/2)];
			_gridmarker = _gridmarker + [_marker];

			_index = _index + 1;
			MEMBER("gridmarker", _gridmarker);
			MEMBER("markerindex", _index);
		};

		PUBLIC FUNCTION("", "UnDraw") {
			private["_array"];
			{
				deletemarker _x;
			}foreach MEMBER("gridmarker", nil);
			_array = [];
			MEMBER("gridmarker", _array);			
		};


		// call a loopback parsing function and return sectors that are concerned
		// example of string parameter
		// _function = "isBuilding";
		// retur sector with buildings

		PUBLIC FUNCTION("string", "parseAllSectors") {
			private["_array", "_function", "_position", "_result", "_sector", "_x", "_y"];

			_function = _this;
			_array = [];

			for "_y" from MEMBER("ystart", nil) to MEMBER("ysize", nil) step MEMBER("ysector", nil) do {
				for "_x" from MEMBER("xstart", nil) to MEMBER("xsize", nil) step MEMBER("xsector", nil) do {
					_position = [_x, _y];
					_sector = MEMBER("getSectorFromPos", _position);
					if(MEMBER(_function, _sector)) then {
						_array = _array + [_sector];
					};
					//hint format["%1 %2 %3", _array, _function, _sector];
				};
			};
			_array;
		};

		// Return sector where is object
		PUBLIC FUNCTION("array", "getSectorFromPos") {
			private ["_position", "_xpos", "_ypos"];

			_position = _this;

			_xpos = floor((_position select 0) / MEMBER("xsector", nil));
			_ypos = floor((_position select 1) / MEMBER("ysector", nil));

			[_xpos, _ypos];
		};

		PUBLIC FUNCTION("array", "getMiddlePos") {
			_position = _this;
			_sector = MEMBER("getSectorFromPos", _position);
			_position = MEMBER("getPosFromSector", _sector);
			_position;
		};

		PUBLIC FUNCTION("array", "getSectorAround") {
			private ["_grid", "_params", "_sector"];

			_sector = _this;	
			_params = [_sector, 1];
			
			_grid = MEMBER("getSectorAllAround", _params);

			_grid;
		};

		PUBLIC FUNCTION("array", "getSectorCrossAround") {
			private ["_grid", "_sector"];

			_sector = _this select 0;

			_grid = [
				[(_sector select 0), (_sector select 1) - 1],
				[(_sector select 0)-1, (_sector select 1)],
				[(_sector select 0)+1, (_sector select 1)],
				[(_sector select 0), (_sector select 1) + 1]
				];
			_grid;
		};


		PUBLIC FUNCTION("array", "getSectorAllAround") {
			private ["_grid", "_scale", "_sector", "_botx", "_boty", "_topx", "_topy", "_x", "_y"];

			_sector = _this select 0;
			_scale = _this select 1;

			_botx = (_sector select 0) - _scale;
			_boty = (_sector select 1) - _scale;
			_topx = (_sector select 0) + _scale;
			_topy = (_sector select 1) + _scale;

			_grid = [];
			
			for "_y" from _boty to _topy do {
				for "_x" from _botx to _topx do {
					_grid = _grid + [[_x, _y]];
				};
			};
			_grid;
		};


		PUBLIC FUNCTION("array", "addSucessor") {
			private ["_grid", "_position", "_sector"];

			_sector = _this;
			_grid = MEMBER("getSectorAround", _sector);
			
			{
				_position = MEMBER("getPosFromSector", _x);
				if!(surfaceIsWater _position) then {
					_cost = 10;
				} else {
					_cost = 1;
				};
			}foreach _grid;
		};

		PUBLIC FUNCTION("array", "isBuilding") {
			private ["_positions", "_result"];

			_sector = _this;
			_positions = MEMBER("getPositionsBuilding", _sector);
			if (count _positions > 10) then { _result = true;} else { _result = false;};
			_result;
		};

		PUBLIC FUNCTION("array", "getPositionsBuilding") {
			private ["_index", "_buildings", "_position", "_positions", "_result"];

			_sector = _this;
			_position = MEMBER("getPosFromSector", _sector);
			_positions = [];
			
			if!(surfaceIsWater _position) then {
				_buildings = nearestObjects[_position,["House_F"], MEMBER("xsector", nil)];
	
				{
					_index = 0;
					while { format ["%1", _x buildingPos _index] != "[0,0,0]" } do {
						_positions = _positions + [(_x buildingPos _index)];
						_index = _index + 1;
					};
				}foreach _buildings;
			};
			_positions;
		};


		PUBLIC FUNCTION("array", "getPosFromSector") {		
			private ["_sector", "_x", "_y"];

			_sector = _this;

			_x = ((_sector select 0) * MEMBER("xsector", nil)) + (MEMBER("xsector", nil) / 2);
			_y = ((_sector select 1) * MEMBER("ysector", nil)) + (MEMBER("ysector", nil) / 2);

			[_x,_y];
		};

		PUBLIC FUNCTION("array", "GetEstimateCost") {
			private ["_start", "_dx", "_dy", "_goal"];

			_start = _this select 0;	
			_goal = _this select 1;

			_dx = abs((_start select 0) - (_goal select 0));
			_dy = abs((_start select 1) - (_goal select 1));

			_dy max _dx;
		};

		PUBLIC FUNCTION("array", "getNextSector") {
			private ["_currentsector", "_dx", "_dy", "_goalsector", "_neighbors", "_nextsector", "_performance", "_position"];

			_currentsector = _this select 0;	
			_goalsector = _this select 1;

			_neighbors = MEMBER("getSectorAround", _currentsector);

			_performance = 1000000;
			{				
				_position = MEMBER("getPosFromSector", _x);
				if!(surfaceIsWater _position) then {
					_dx = abs((_x select 0) - (_goalsector select 0));
					_dy = abs((_x select 1) - (_goalsector select 1));
					if (_dx + _dy < _performance) then {
						_performance = _dx + _dy;
						_nextsector = _x;
					};
				};
				sleep 0.001;
			}foreach _neighbors;

			_nextsector;
		};

		PUBLIC FUNCTION("array", "getPathToSector") {
			private ["_array", "_sectors", "_currentsector", "_goalsector"];

			_currentsector = _this select 0;	
			_goalsector = _this select 1;
			_sectors = [];

			while { format["%1", _currentsector] != format["%1", _goalsector] } do {
				_sectors = _sectors + [_currentsector];
				_array = [_currentsector, _goalsector];
				_currentsector = MEMBER("getNextSector", _array);
				["DrawSector", _currentsector] call _grid;
				sleep 0.001;
			};
			_sectors;
		};

		PUBLIC FUNCTION("", "Monitor") {
			private ["sector", "_sectors"];
			MEMBER("monitored", true);
			while { MEMBER("monitored", nil) } do {
				_sectors = [];
				{
					_sector = MEMBER("getSectorFromPos", position _x);
					_sectors = _sectors + [sector];
					sleep 0.1;
				}foreach playableunits;
				MEMBER("playersector", _sectors);
				sleep 10;
			};
			_sectors = [];
			MEMBER("playersector", _sectors);
		};

		PUBLIC FUNCTION("", "UnMonitor") {
			MEMBER("monitored", false);
		};


		PUBLIC FUNCTION("", "Print") {
			MEMBER("printed", true);
			while { MEMBER("printed", nil) } do {
				hint format["Players Sector: %1", MEMBER("playersector", nil)];
				sleep 1;
			};
		};

		PUBLIC FUNCTION("", "UnPrinted") {
			MEMBER("printed", false);
		};

		PUBLIC FUNCTION("","deconstructor") { 
			DELETE_VARIABLE("markerindex");
			DELETE_VARIABLE("playersector");
			DELETE_VARIABLE("gridmarker");
			DELETE_VARIABLE("monitored");
			DELETE_VARIABLE("printed");
			DELETE_VARIABLE("xstart");
			DELETE_VARIABLE("ystart");
			DELETE_VARIABLE("xsize");
			DELETE_VARIABLE("ysize");
			DELETE_VARIABLE("xsector");
			DELETE_VARIABLE("ysector");
		};
	ENDCLASS;