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

	private ["_position", "_list", "_vehicle"];

	_position = position player;

	_title = "Select your destination zone";
	_text = "Click on the map where you'd like to Insert!";
	["hint", [_title, _text]] call hud;

	while { _position distance position player < 50 } do {
		wcteleport = [];
		wcteleportposition = [];
		onMapSingleClick {
			wcteleport = [name player, _pos];
			["wcteleport", "server"] call BME_fnc_publicvariable;
		};
		while {count wcteleportposition == 0} do { sleep 0.1;};
		onMapSingleClick "";
		
		_list = wcteleportposition nearEntities ["B_Heli_Transport_01_camo_F", 150];
		if (count _list > 0) then {
			_vehicle = _list select 0;
			if (count (crew _vehicle) < 10) then {
				player moveInAny _vehicle;
			} else {
				player setpos wcteleportposition;
			};
		} else {
			player setpos wcteleportposition;
		};
	};

	hintSilent "";
