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

	hintSilent "Click on the map where your tank insert.";

	while { _position distance position player < 50 } do {
		wcteleport = [];
		wcteleportposition = [];
		onMapSingleClick {
			wcteleporttank = [name player, _pos];
			["wcteleporttank", "server"] call BME_fnc_publicvariable;
		};
		waitUntil{count wcteleportposition > 0};
		_newposition = [wcteleportposition select 0, wcteleportposition select 1, 0];

		if(playertype == "tank") then {
			_vehicle = createVehicle ["B_MBT_01_cannon_F", _newposition,[], 0, "NONE"];
		};

		if(playertype == "tankaa") then {
			_vehicle = createVehicle ["B_APC_Tracked_01_AA_F", _newposition,[], 0, "NONE"];
		};

		_vehicle removeAllEventHandlers "HandleDamage";
		_vehicle addeventhandler ['HandleDamage', {
			if(getdammage (_this select 0) > 0.9) then {
					(_this select 0) setdamage 1;
					(_this select 0) removeAllEventHandlers "HandleDamage";
					{
						_x setdamage 1;
					}foreach (crew (_this select 0));
			};
		}];
		
		player moveIndriver _vehicle;
		
		onMapSingleClick "";
	};
