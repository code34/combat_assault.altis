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

	private ["_commander", "_position", "_array"];

	_position = position player;

	_title = "Select your destination zone";
	_text = "Click on the map where you'd like to Insert!";
	["hint", [_title, _text]] call hud;

	while { _position distance position player < 50 } do {
		wcteleport = [];
		wcteleportposition = [];
		onMapSingleClick {
			wcteleportchopper = [name player, _pos];
			["wcteleportchopper", "server"] call BME_fnc_publicvariable;
		};
		waitUntil{count wcteleportposition > 0};

		_newposition = [wcteleportposition select 0, wcteleportposition select 1, 50];
		_array = [_newposition, 0, "I_Heli_light_03_unarmed_F", west] call bis_fnc_spawnvehicle;
		_vehicle = _array select 0;

		_vehicle removeAllEventHandlers "HandleDamage";
		_vehicle addeventhandler ['HandleDamage', {
			if(damage (_this select 0) > 0.9) then {
					(_this select 0) setdamage 1;
					(_this select 0) removeAllEventHandlers "HandleDamage";
					{
						_x setdamage 1;
					}foreach (crew (_this select 0));
			};
		}];

		{
			_x setdammage 1;
			deletevehicle _x;
		}foreach units (_array select 2);
		deletegroup (_array select 2);
		player moveindriver _vehicle;
		
		onMapSingleClick "";
	};

	hintSilent "";
