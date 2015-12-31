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

	private ["_camera", "_target", "_locations", "_positions", "_newx", "_newy", "_startpos", "_endpos"];

	_locations = [];
	_positions = [];
	
	"_locations pushBack configName _x" configClasses (configFile >> "CfgWorlds" >> "Altis" >> "Names");
	"_positions pushBack getarray (_x >> 'position')" configClasses (configFile >> "CfgWorlds" >> "Altis" >> "Names");

	showCinemaBorder true;
	_camera = "camera" camCreate [0,0,0];
	_target = "Sign_Arrow_Blue_F" createVehicleLocal [0,0,0];
	_target hideObject true;
	_camera camSetTarget _target;
	_camera cameraEffect ["internal","back"];
	_camera camcommit 0;

	while { true } do {
		_index = random floor(count(_locations));
		_position = _positions select _index;
		_startpos = [ _position select 0, _position select 1, 30];
		_newx = [-150, -100,-50,0,50,100,150] call BIS_fnc_selectRandom;
		_newy = [-150, -100,-50,0,50,100,150] call BIS_fnc_selectRandom;
		_endpos = [(_startpos select 0) + _newx, (_startpos select 1) + _newy, (_startpos select 2)];

		_camera camSetPos _startpos;
		_camera camCommit 0;

		[ format [ "<t size='1' align='left'>%1<br/>%2</t>", "", _locations select _index ],1,0.8,6,1 ] spawn BIS_fnc_dynamictext;

		_target setpos _endpos;
		_camera camSetPos _endpos;
		_camera camSetTarget _target;
		_camera camSetTarget objnull;
		_camera camCommit 10;

		waitUntil { camCommitted _camera; };
	};


	