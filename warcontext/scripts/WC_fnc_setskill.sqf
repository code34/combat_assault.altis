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

	private ["_unit", "_type"];
	
	_unit 	= _this select 0;
	_type 	= _this select 1; 

	switch (wclevel) do {
		case "novice": {
			_unit setskill (random wcskill);
		};

		case "recruit": {
			_unit setskill (wcskill + (random 0.1));
		};

		case "veteran": {
			_unit setskill (wcskill + (random 0.2));
		};

		case "cheated":{
			switch (_type) do {
				case "OIA_InfSquad_Weapons":{
					_unit setskill ["aimingAccuracy", wcskill + round(random 0.4)];
					_unit setskill ["aimingShake", wcskill + round(random 0.4)];
					_unit setskill ["aimingSpeed", 0.6];
					_unit setskill ["endurance", 0.8];
					_unit setskill ["spotDistance", 0.5];
					_unit setskill ["spotTime", 0.9];
					_unit setskill ["courage", 1];
					_unit setskill ["reloadSpeed", 0.7];
					_unit setskill ["commanding", 1];	
				};
					
				case "OIA_InfSquad": {
					_unit setskill ["aimingAccuracy", wcskill + round(random 0.4)];
					_unit setskill ["aimingShake", wcskill + round(random 0.4)];
					_unit setskill ["aimingSpeed", wcskill + round(random 0.4)];
					_unit setskill ["endurance", 0.8];
					_unit setskill ["spotDistance", 0.5];
					_unit setskill ["spotTime", 0.9];
					_unit setskill ["courage", 1];
					_unit setskill ["reloadSpeed", 0.7];
					_unit setskill ["commanding", 1];	
				};

				case "OIA_InfTeam": {
					_unit setskill ["aimingAccuracy", wcskill + round(random 0.4)];
					_unit setskill ["aimingShake", wcskill + round(random 0.4)];
					_unit setskill ["aimingSpeed", wcskill + round(random 0.4)];
					_unit setskill ["endurance", 0.8];
					_unit setskill ["spotDistance", 0.5];
					_unit setskill ["spotTime", 0.9];
					_unit setskill ["courage", 1];
					_unit setskill ["reloadSpeed", 0.7];
					_unit setskill ["commanding", 1];	
				};

				case "OIA_InfTeam_AA": {
					_unit setskill ["aimingAccuracy", wcskill + round(random 0.4)];
					_unit setskill ["aimingShake", wcskill + round(random 0.4)];
					_unit setskill ["aimingSpeed", wcskill + round(random 0.4)];
					_unit setskill ["endurance", 0.8];
					_unit setskill ["spotDistance", 0.7];
					_unit setskill ["spotTime", 0.7];
					_unit setskill ["courage", 1];
					_unit setskill ["reloadSpeed", 0.5];
					_unit setskill ["commanding", 1];	
				};

				case "OIA_InfTeam_AT": {
					_unit setskill ["aimingAccuracy", wcskill + round(random 0.4)];
					_unit setskill ["aimingShake", wcskill + round(random 0.4)];
					_unit setskill ["aimingSpeed", wcskill + round(random 0.4)];
					_unit setskill ["endurance", 0.8];
					_unit setskill ["spotDistance", 0.7];
					_unit setskill ["spotTime", 0.6];
					_unit setskill ["courage", 1];
					_unit setskill ["reloadSpeed", 0.5];
					_unit setskill ["commanding", 1];
				};

				case "OI_SniperTeam": {
					_unit setskill ["aimingAccuracy", 0.8];
					_unit setskill ["aimingShake", 0.8];
					_unit setskill ["aimingSpeed", 0.7];
					_unit setskill ["endurance", 0.5];
					_unit setskill ["spotDistance", 1];
					_unit setskill ["spotTime", 0.9];
					_unit setskill ["courage", 1];
					_unit setskill ["reloadSpeed", 0.3];
					_unit setskill ["commanding", 1];	
				};

				case "OI_ReconTeam": {
					_unit setskill ["aimingAccuracy", wcskill + round(random 0.4)];
					_unit setskill ["aimingShake", wcskill + round(random 0.4)];
					_unit setskill ["aimingSpeed", 0.6];
					_unit setskill ["endurance", 0.8];
					_unit setskill ["spotDistance", 0.5];
					_unit setskill ["spotTime", 0.9];
					_unit setskill ["courage", 1];
					_unit setskill ["reloadSpeed", 0.8];
					_unit setskill ["commanding", 1];	
				};

				default {
					_unit setskill ["aimingAccuracy", wcskill + round(random 0.4)];
					_unit setskill ["aimingShake", wcskill + round(random 0.4)];
					_unit setskill ["aimingSpeed", wcskill + round(random 0.4)];
					_unit setskill ["endurance", 0.8];
					_unit setskill ["spotDistance", 0.5];
					_unit setskill ["spotTime", 0.9];
					_unit setskill ["courage", 1];
					_unit setskill ["reloadSpeed", 0.7];
					_unit setskill ["commanding", 1];	
				};
			};
		};	

		default {
			_unit setskill (random wcskill);
		};
	};

	_unit addeventhandler ['FiredNear', {
		if(side(_this select 1) in [west, civilian]) then {
			private ["_name"];
			_name = currentMagazine (_this select 1);
			_name = getText (configFile >> "CfgMagazines" >> _name >> "displayNameShort");
			if!(_name == "SD") then {
				(_this select 0) doTarget (_this select 1);
				(_this select 0) reveal (_this select 1);
				(_this select 0) doFire (_this select 1);
				(_this select 0) setmimic "Agresive";
				{
					_x reveal (_this select 1);
				}foreach (units (group (_this select 0)));
			};
			(leader (group (_this select 0))) setvariable ['combat', true];
		};
	}];

	_unit addEventHandler ['HandleDamage', {
		if(isplayer(_this select 3)) then {
			if(alive (_this select 0)) then {
				_damage = 1 - damage(_this select 0);
				(_this select 0) setdamage (damage(_this select 0) + random(_damage));
			};
			(leader (group (_this select 0))) setvariable ['combat', true];
			{
				_x reveal (_this select 3);
			}foreach (units (group (_this select 0)));
		};
	}];

	_unit addeventhandler ['Killed', {
		["remoteSpawn", ["BME_netcode_server_setDeath", [(_this select 0), (_this select 1)], "server"]] call server_bme;
		["remoteSpawn", ["BME_netcode_client_hintDeath", [(_this select 0), (_this select 1)], "client"]] call server_bme;
	}];

	true;