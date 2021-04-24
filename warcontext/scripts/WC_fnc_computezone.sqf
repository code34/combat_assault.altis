	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014-2018 Nicolas BOITEUX
	
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
		"_sectors",
		"_size"
	];

	_size = _this;

	for "_i" from 1 to wcnumberofzone do {
		_key = [ceil (random _size), ceil (random _size)];
		["expandSector", _key] call global_controller;
		["expandSectorAround", [_key, 7]] call global_controller;
	};

	{
		_position = getmarkerpos _x;
		_sector = ["getSectorFromPos", _position] call global_grid;
		["expandSector", _sector] call global_controller;
		["expandSectorAround", [_sector, 7]] call global_controller;
	} foreach ("getAirports" call global_atc);

	{
		_position = getmarkerpos _x;
		_sector = ["getSectorFromPos", _position] call global_grid;
		["expandSector", _sector] call global_controller;
		["expandSectorAround", [_sector, 7]] call global_controller;
	} foreach ("getFactorys" call global_factory);