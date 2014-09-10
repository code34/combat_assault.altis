	// -----------------------------------------------
	// Author:  code34 nicolas_boiteux@yahoo.fr
	// warcontext : set skill of ia
	// context: server side
	// -----------------------------------------------

	if (!isServer) exitWith{};

	private [
		"_unit",
		"_type"
		];
	
	_unit 	= _this select 0;
	_type 	= _this select 1; 
	
	_skill = [
		"aimingAccuracy",
		"aimingShake",
		"aimingSpeed",
		"endurance",
		"spotDistance",
		"spotTime",
		"courage",
		"reloadSpeed",
		"commanding",
		"general"
		];

	switch (_type) do {
		case "OIA_InfSquad_Weapons":{
			_unit setskill ["aimingAccuracy", 0.6];
			_unit setskill ["aimingShake", 0.4 + round(random (0.4))];
			_unit setskill ["aimingSpeed", 0.6];
			_unit setskill ["endurance", 0.8];
			_unit setskill ["spotDistance", 0.5];
			_unit setskill ["spotTime", 0.9];
			_unit setskill ["courage", 0.7];
			_unit setskill ["reloadSpeed", 0.7];
			_unit setskill ["commanding", 1];	
		};
			
		case "OIA_InfSquad": {
			_unit setskill ["aimingAccuracy", 0.6];
			_unit setskill ["aimingShake", 0.6];
			_unit setskill ["aimingSpeed", 0.4 + round(random (0.3))];
			_unit setskill ["endurance", 0.8];
			_unit setskill ["spotDistance", 0.5];
			_unit setskill ["spotTime", 0.9];
			_unit setskill ["courage", 0.7];
			_unit setskill ["reloadSpeed", 0.7];
			_unit setskill ["commanding", 1];	
		};

		case "OIA_InfTeam": {
			_unit setskill ["aimingAccuracy", 0.6];
			_unit setskill ["aimingShake", 0.6];
			_unit setskill ["aimingSpeed", 0.4 + round(random (0.3))];
			_unit setskill ["endurance", 0.8];
			_unit setskill ["spotDistance", 0.5];
			_unit setskill ["spotTime", 0.9];
			_unit setskill ["courage", 0.7];
			_unit setskill ["reloadSpeed", 0.7];
			_unit setskill ["commanding", 1];	
		};

		case "OIA_InfTeam_AA": {
			_unit setskill ["aimingAccuracy", 0.6];
			_unit setskill ["aimingShake", 0.6];
			_unit setskill ["aimingSpeed", 0.4 + round(random (0.3))];
			_unit setskill ["endurance", 0.8];
			_unit setskill ["spotDistance", 0.7];
			_unit setskill ["spotTime", 0.7];
			_unit setskill ["courage", 0.7];
			_unit setskill ["reloadSpeed", 0.5];
			_unit setskill ["commanding", 1];	
		};

		case "OIA_InfTeam_AT": {
			_unit setskill ["aimingAccuracy", 0.6];
			_unit setskill ["aimingShake", 0.6];
			_unit setskill ["aimingSpeed", 0.4 + round(random (0.3))];
			_unit setskill ["endurance", 0.8];
			_unit setskill ["spotDistance", 0.7];
			_unit setskill ["spotTime", 0.6];
			_unit setskill ["courage", 0.7];
			_unit setskill ["reloadSpeed", 0.5];
			_unit setskill ["commanding", 1];
		};

		case "OI_SniperTeam": {
			_unit setskill ["aimingAccuracy", 1];
			_unit setskill ["aimingShake", 1];
			_unit setskill ["aimingSpeed", 0.7];
			_unit setskill ["endurance", 0.5];
			_unit setskill ["spotDistance", 1];
			_unit setskill ["spotTime", 0.9];
			_unit setskill ["courage", 0.7];
			_unit setskill ["reloadSpeed", 0.3];
			_unit setskill ["commanding", 0.5];	
		};

		case "OI_ReconTeam": {
			_unit setskill ["aimingAccuracy", 0.7];
			_unit setskill ["aimingShake", 0.8];
			_unit setskill ["aimingSpeed", 0.6];
			_unit setskill ["endurance", 0.8];
			_unit setskill ["spotDistance", 0.5];
			_unit setskill ["spotTime", 0.9];
			_unit setskill ["courage", 0.7];
			_unit setskill ["reloadSpeed", 0.8];
			_unit setskill ["commanding", 1];	
		};

		default {
			_unit setskill ["aimingAccuracy", 0.6];
			_unit setskill ["aimingShake", 0.6];
			_unit setskill ["aimingSpeed", 0.6];
			_unit setskill ["endurance", 0.8];
			_unit setskill ["spotDistance", 0.5];
			_unit setskill ["spotTime", 0.9];
			_unit setskill ["courage", 0.7];
			_unit setskill ["reloadSpeed", 0.7];
			_unit setskill ["commanding", 1];	
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
			(leader (group (_this select 0))) setvariable ['complete', true];
		};
	}];

	_unit addEventHandler ['HandleDamage', {
		if(isplayer(_this select 3)) then {
			(_this select 0) setdamage (damage(_this select 0) + (random 1));
			(leader (group (_this select 0))) setvariable ['complete', true];
		};
		if((_this select 0) distance (_this select 3) > 800) then {
			(leader (group (_this select 0))) setvariable ['support', [(_this select 3)]];
		};
	}];

	true;