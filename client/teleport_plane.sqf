	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2013 Nicolas BOITEUX

	Real weather for MP GAMES v 1.2 
	
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

	private ["_position", "_array"];

	_position = position player;

	hintSilent "Click on the map where your plane insert.";

	while { _position distance position player < 50 } do {
		wcteleport = [];
		wcteleportposition = [];
		onMapSingleClick {
			wcteleport = [name player, _pos];
			["wcteleport", "server"] call BME_fnc_publicvariable;
		};
		waitUntil{count wcteleportposition > 0};
		_newposition = [wcteleportposition select 0, wcteleportposition select 1, 500];
		_array = [_newposition, 0, "B_Plane_CAS_01_F", west] call bis_fnc_spawnvehicle;
		{
			_x setdammage 1;
			deletevehicle _x;
		}foreach units (_array select 2);
		player moveindriver (_array select 0);
		onMapSingleClick "";
	};
