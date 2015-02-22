	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014 Nicolas BOITEUX
	
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
	
	if (!isServer) exitWith{};

	private [
		"_key",
		"_position",
		"_sector",
		"_sectors"
	];
	
	_sectors = [];
	while { count _sectors < 30 } do {
		_sector = [ceil (random 300), ceil (random 300)];
		_position = ["getPosFromSector", _sector] call global_grid;
		if(getmarkerpos "respawn_west" distance _position > 1300) then {
			if!(surfaceIsWater _position) then {
				_sectors = _sectors + [_sector];
			};
		};
	};

	for "_x" from 0 to wcnumberofzone step 1 do {
		_key = _sectors call BIS_fnc_selectRandom;
		["expandSector", _key] call global_controller;
		["expandSectorAround", [_key, 10]] call global_controller;
	};

	{
		if(random 1 > 0.75) then {
			_position = getmarkerpos _x;
			_sector = ["getSectorFromPos", _position] call global_grid;
			["expandSector", _sector] call global_controller;
			["expandSectorAround", [_sector, 5]] call global_controller;
		};
	} foreach ["viking","hurricane","crocodile", "coconuts", "liberty"];

	{
		if(random 1 > 0.90) then {
			_position = getmarkerpos _x;
			_sector = ["getSectorFromPos", _position] call global_grid;
			["expandSector", _sector] call global_controller;
			["expandSectorAround", [_sector,  3]] call global_controller;
		};
	} foreach ["RADIOCENTER", "RESEARCHCENTER", "MILITARYDEPOT", "GAZFACTORY", "WEAPONSFACTORY", "POWERRELAY", "BLACKCASTLE", "VEHICLEDEPOT", "POWERPLANT1", "POWERPLANT2", "POWERPLANT3", "POWERPLANT4", "CARGODEPOT", "AGIAPORT", "VEHICLEFACTORY", "URANIUMMINE", "FUELFACTORY", "AGIOSHARBOR", "GSMANTENNA"];	