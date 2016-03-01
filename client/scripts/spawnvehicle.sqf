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

	private ["_vehicleslist", "_index", "_type", "_air", "_name", "_picture"];


	_vehicles = [];
	_positions = [];
	
	_air = false;
	{
		if(player distance getmarkerpos _x < 300) then {
			if(getmarkercolor _x == "ColorBlue") then {
				_air = true;
			};
		};
	}foreach ["viking","hurricane","crocodile", "coconuts", "liberty"];

	if(_air) then {
		_vehicleslist = "( (getNumber (_x >> 'scope') >= 2) && {getNumber (_x >> 'side') >= 1 && {getText (_x >> 'vehicleClass') in ['Armored', 'Car', 'Air']  } } )" configClasses (configFile >> "CfgVehicles");
	} else {
		_vehicleslist = "( (getNumber (_x >> 'scope') >= 2) && {getNumber (_x >> 'side') >= 1 && {getText (_x >> 'vehicleClass') in ['Armored', 'Car']  } } )" configClasses (configFile >> "CfgVehicles");
	};

	lbClear 1255;

	_ammobox = (configFile >> "CfgVehicles" >> "B_supplyCrate_F");
	_vehicleslist = [_ammobox] + _vehicleslist;
	{ 
		_name= getText (configFile >> "CfgVehicles" >> configname _x >> "DisplayName");
		lbAdd [1255, _name];

		// skip ammobox (no picture)
		if(_forEachIndex > 0) then {
			_picture = getText (configFile >> "CfgVehicles" >> configname _x >> "picture");	
			lbSetPicture [1255, (lbSize 1255)-1, _picture] ;
		};
	}foreach _vehicleslist;
	lbSetCurSel [ 1255, 0];


	wcaction = "";
	while { wcaction != "deploy" && dialog} do {
		_index = (lbCurSel 1255);
		_type = configname (_vehicleslist select _index);
		sleep 0.01;
	};
	closeDialog 0;

	if(wcaction == 'deploy') then {
		playervehicle = [name player, position player, _type];
		["playervehicle", "server"] call BME_fnc_publicvariable;
	};