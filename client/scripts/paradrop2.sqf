	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2021 Nicolas BOITEUX

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

	private _position = [_this select 0, _this select 1];
	if(_position distance getMarkerPos "respawn_west" < 100) exitWith {};
	if (["remoteCall", ["BME_netcode_server_isPackedBase", "", 2, false, 2]] call client_bme) exitWith { 
		(localize "STR_PARADROP_BUTTON") hintC (localize "STR_PARADROP_BASEREQUIREMENT");
	};
	if(_position distance getMarkerPos "respawn_west" > (getMarkerSize "globalbasedeploy" select 0)) exitWith {
		_title = localize "STR_TELEPORT_TITLE_TOOFAR";
		_text = localize "STR_TELEPORT_TEXT_TOOFAR";
		["hint", [_title, _text]] call hud;
	};

	player setpos [_this select 0, _this select 1, 500];
	player setVelocity [0, 0, 10];

	player switchmove "HaloFreeFall_non";
	private _backpack = backpack player;
	private _items = backpackItems player;
	removeBackpack player;
	player addBackPack "B_parachute";

	[_backpack, _items] spawn {
		_backpack = _this select 0;
		_items = _this select 1;

		while { (getpos player) select 2 >  0.5 } do { sleep 0.5;};

		player addBackpack _backpack;
		{
			player addItemToBackpack _x;
		} foreach _items;
	};