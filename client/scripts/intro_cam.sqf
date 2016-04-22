	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014-2016 Nicolas BOITEUX
	
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

	private ["_camera", "_target", "_locations", "_positions", "_newx", "_newy", "_startpos", "_endpos", "_condition", "_loop", "_count", "_preload"];

	_locations = [];
	_positions = [];
	
	"_locations pushBack configName _x" configClasses (configFile >> "CfgWorlds" >> "Altis" >> "Names");
	"_positions pushBack getarray (_x >> 'position')" configClasses (configFile >> "CfgWorlds" >> "Altis" >> "Names");

	_dialog = createDialog "intromenu";
	_condition = true;
	_preload = false;

	while { _condition } do {
		_index = random floor(count(_locations) - 1);
		_position = _positions select _index;
		_oldh = [10, 20,30,40,50,60,70] call BIS_fnc_selectRandom;
		_startpos = [ _position select 0, _position select 1, 30];
		
		_newx = [-150, -100,-50,0,50,100,150] call BIS_fnc_selectRandom;
		_newy = [-150, -100,-50,0,50,100,150] call BIS_fnc_selectRandom;
		_newh = [10, 20,30,40,50,60,70] call BIS_fnc_selectRandom;
		_endpos = [(_startpos select 0) + _newx, (_startpos select 1) + _newy, _newh];

		if(_preload) then { waitUntil {preloadCamera _startpos;}; };
		_preload = true;

		if(isnil "_camera") then {
			_camera = "camera" camCreate _startpos;
			_camera cameraEffect ["internal","back"];
			_camera camcommit 0;
			showCinemaBorder true;
		};

		_camera camSetPos _startpos;
		_camera camCommit 0;

		[ format [ "<t size='1' align='left'>%1<br/>%2</t>", "", _locations select _index ],1,0.8,6,1 ] spawn BIS_fnc_dynamictext;

		_camera camSetDir [360, 270,180,90, 0] call BIS_fnc_selectRandom;
		_camera camSetPos _endpos;
		_camera camSetTarget objnull;
		_camera camCommit 12;

		_loop = true;
		_count = 0;
		while { _loop } do {
			sleep 0.1;
			_count = _count + 1;
			if(_count > 60) then { _loop = false;};
			if(!dialog) then {_condition = false; _loop = false;};
		};
	};

	_camera cameraEffect ["Terminate", "BACK"];
	camDestroy _camera;

	