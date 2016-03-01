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

	_title = localize "STR_TELEPORT_TITLE";
	_text = localize "STR_TELEPORT_TEXT";
	["hint", [_title, _text]] call hud;

	wcteleport = [];
	wcteleportposition = [];
	onMapSingleClick {
		wcteleport = [name player, _pos];
		["wcteleport", "server"] call BME_fnc_publicvariable;
	};
	while {count wcteleportposition == 0} do { sleep 0.1;};
	onMapSingleClick "";

	player setpos wcteleportposition;
	hintSilent "";