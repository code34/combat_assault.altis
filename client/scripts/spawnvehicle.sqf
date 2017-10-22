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

	private ["_vehicleslist", "_index", "_type", "_air","_armor","_name", "_picture", "_positions", "_list", "_text", "_ctrl"];

	_vehicles = [];
	_positions = [];
	_vehicleslist = [];
	disableSerialization;
	
	// Retrieve airports
	_positions = [getarray (configfile >> "CfgWorlds" >> worldName >> "ilsPosition")];
	"_positions pushBack (getArray (_x >> 'ilsPosition'))" configClasses (configFile >> "CfgWorlds" >> worldName >> "secondaryAirports");

	_air = false;
	{
		if(player distance _x < 300) then {
			_list = (position player) nearEntities [["Man", "Tank"], 300];
			sleep 0.2;
			if(east countside _list == 0) then {
				_air = true;
			};
		};
	} foreach _positions;

	if(isnil "wcairports") then { 
		["remoteSpawn", ["getairports", "", "server"]] call global_bme;
		waitUntil { !isNil "wcairports"; };
	};
	if(isnil "wcfactorys") then { 
		["remoteSpawn", ["getfactorys", "", "server"]] call global_bme;
		waitUntil { !isNil "wcfactorys"; };
	};

	_air = false;
	_armor = false;
	{
		if(position player distance (getMarkerPos _x)  < 300) then {
			_list = (position player) nearEntities [["Man", "Tank"], 300];
			sleep 0.2;
			if(east countside _list == 0) then {
				_air = true;
			};
		};
	} forEach wcairports;

	{
		if(position player distance  (getMarkerPos _x) <150) then {
			_list = (position player) nearEntities [["Man", "Tank"], 300];
			sleep 0.2;
			if(east countside _list == 0) then {
				_armor = true;
			};
		};
	} forEach wcfactorys;

	if(_air) then {
		_temp = "( (getNumber (_x >> 'scope') >= 1) && {getNumber (_x >> 'side') >= 0 && {getText (_x >> 'vehicleClass') in ['Air', 'rhs_vehclass_aircraft', 'rhs_vehclass_helicopter']  } } )" configClasses (configFile >> "CfgVehicles");
		_vehicleslist = _vehicleslist + _temp;
	};

	if(_armor) then {
		_temp = "( (getNumber (_x >> 'scope') >= 1) && {getNumber (_x >> 'side') >= 0 && {getText (_x >> 'vehicleClass') in ['Armored', 'rhs_vehclass_tank']  } } )" configClasses (configFile >> "CfgVehicles");
		_vehicleslist = _vehicleslist + _temp;
	};

	_temp = "( (getNumber (_x >> 'scope') >= 1) && {getNumber (_x >> 'side') >= 0 && {getText (_x >> 'vehicleClass') in ['Car']  } } )" configClasses (configFile >> "CfgVehicles");
	_vehicleslist = _vehicleslist + _temp;

	lbClear 1255;

	_ammobox = (configFile >> "CfgVehicles" >> "B_supplyCrate_F");
	_vehicleslist = [_ammobox] + _vehicleslist;
	{ 
		//if!(_x isEqualTo "PaperCar") then {
			if!((configname _x) isEqualTo "PaperCar") then {
				_name= getText (configFile >> "CfgVehicles" >> configname _x >> "DisplayName");
				lbAdd [1255, _name];
				// skip ammobox (no picture)
				if(_forEachIndex > 0) then {
					_picture = getText (configFile >> "CfgVehicles" >> configname _x >> "picture");
					lbSetPicture [1255, (lbSize 1255)-1, _picture] ;
				};
			} else {
				_vehicleslist = _vehicleslist - [_x];
			};
		//};
	}foreach _vehicleslist;
	lbSetCurSel [ 1255, 0];

	_text = format ["Command channel: DXQ FORM - 472 - %1 to HQ ! Request an immediate materials Air Drop on battlefied, at sector %2. Over !", name player, ["getSectorFromPos", position player] call client_grid];
	_ctrl =(uiNamespace getVariable "wcspawndialog") displayCtrl 1256;
	_ctrl ctrlSetText _text;
	_ctrl ctrlcommit 0;

	wcaction = "";
	while { wcaction != "deploy" && dialog} do {
		_index = (lbCurSel 1255);
		_type = configname (_vehicleslist select _index);
		sleep 0.01;
	};
	closeDialog 0;

	if(wcaction == 'deploy') then {
		["remoteSpawn", ["playervehicle", [name player, position player, _type], "server"]] call global_bme;
	};