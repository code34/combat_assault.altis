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
	disableSerialization;

	private _vehicles = [];
	private _positions = [];
	private _vehicleslist = [];
	private _air = false;
	private _list = [];
	private _text = "";
	private _ctrl = "";
	private _armor = false;
	private _type = "";

	if (["remoteCall", ["isPackedBase", "", "server"]] call global_bme) exitWith { closedialog 0; hint "Base should be Unpack";};
	_airports = ["remoteCall", ["getairports", "", "server"]] call global_bme;
	_factorys = ["remoteCall", ["getfactorys", "", "server"]] call global_bme;

	{
		if(position player distance (getMarkerPos _x)  < 300) then {
			_list = (position player) nearEntities [["Man", "Tank"], 300];
			sleep 0.5;
			if(east countside _list isEqualTo 0) then { _air = true;	};
		};
	} forEach _airports;
	_air = true;

	{
		if(position player distance  (getMarkerPos _x) <150) then {
			_list = (position player) nearEntities [["Man", "Tank"], 300];
			sleep 0.5;
			if(east countside _list isEqualTo 0) then { _armor = true; };
		};
	} forEach _factorys;

	if(_air) then {
		_temp = "( (getNumber (_x >> 'scope') >= 1) && {getNumber (_x >> 'side') >= 0 && {getText (_x >> 'vehicleClass') in ['Air', 'rhs_vehclass_aircraft', 'rhs_vehclass_helicopter']  } } )" configClasses (configFile >> "CfgVehicles");
		_vehicleslist append _temp;
	};

	if(_armor) then {
		_temp = "( (getNumber (_x >> 'scope') >= 1) && {getNumber (_x >> 'side') >= 0 && {getText (_x >> 'vehicleClass') in ['Armored', 'rhs_vehclass_tank']  } } )" configClasses (configFile >> "CfgVehicles");
		_vehicleslist append _temp;
	};

	_temp = "( (getNumber (_x >> 'scope') >= 1) && {getNumber (_x >> 'side') >= 0 && {getText (_x >> 'vehicleClass') in ['Car']  } } )" configClasses (configFile >> "CfgVehicles");
	_vehicleslist append _temp;

	lbClear 1255;

	_ammobox = (configFile >> "CfgVehicles" >> "B_supplyCrate_F");
	_vehicleslist = [_ammobox] + _vehicleslist;
	{ 
		//if!(_x isEqualTo "PaperCar") then {
			if!((configname _x) isEqualTo "PaperCar") then {
				lbAdd [1255, (getText (configFile >> "CfgVehicles" >> configname _x >> "DisplayName"))];
				// skip ammobox (no picture)
				if(_forEachIndex > 0) then { lbSetPicture [1255, (lbSize 1255)-1, (getText (configFile >> "CfgVehicles" >> configname _x >> "picture"))] ; };
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
		_type = configname (_vehicleslist select (lbCurSel 1255));
		sleep 0.01;
	};
	closeDialog 0;

	if(wcaction == 'deploy') then {
		["remoteSpawn", ["playervehicle", [name player, position player, _type], "server"]] call global_bme;
	};