	// init warcontext function
	WC_fnc_skill	 	= compile preprocessFile "warcontext\WC_fnc_setskill.sqf";
	WC_fnc_computezone	= compile preprocessFile "warcontext\WC_fnc_computezone.sqf";
	WC_fnc_spawninfantry 	= compile preprocessFile "warcontext\SpawnInfantry.sqf";
	WC_fnc_spawnVehicle 	= compile preprocessFile "warcontext\SpawnVehicle.sqf";
	WC_fnc_spawnair 	= compile preprocessFile "warcontext\SpawnAir.sqf";
	WC_fnc_teleport 	= compile preprocessFile "warcontext\teleport.sqf";

	call compilefinal preprocessFileLineNumbers "warcontext\oo_hashmap.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\oo_grid.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\oo_sector.sqf";
	call compilefinal preprocessFileLineNumbers "warcontext\oo_marker.sqf";

	for "_i" from 0 to (count paramsArray - 1) do {
		call compile format["%1=%2;", configName ((missionConfigFile >> "Params") select _i), paramsArray select _i];
		sleep 0.01;
	};

	if (isClass(configFile >> "cfgPatches" >> "inidbi")) then {
		call compile preProcessFile "\inidbi\init.sqf";
		wcinidb = true;
	} else {
		wcinidb = false;
	};
	
	// JIP Check (This code should be placed first line of init.sqf file)
	if (!isServer && isNull player) then {isJIP=true;} else {isJIP=false;};

	if(PARAM_dynamicweather == 1) then {		
		[] execVM "real_weather\real_weather.sqf";
	};
	
	if (isServer) then {
		switch(PARAM_TimeOfDay) do {
			case 1: {
				setdate [2013, 09, 25, 04, 00];
			};
		
			case 2: {
				setdate [2013, 09, 25, 12, 00];
			};
		
			case 3: {
				setdate  [2013, 09, 25, 17, 00];
			};
		
			case 4: {
				setdate [2013, 09, 25, 22, 00];
			};
		};
		enableSaving [false, false];
		if(PARAM_headlessclient == 0) then {
			wcamountofredzones = 1 - (PARAM_Redzone/100);
			[] execVM "warcontext\init.sqf";
		};
	};

	if (local player) then {
		enableEnvironment false;

		// synch server & client
		"wcheadlessclientid" addPublicVariableEventHandler {
			wcheadlessclientid = (_this select 1);
			hint format["Headlessclient connected %1", wcheadlessclientid];
		};

		[] spawn {
			private ["_body"];
			_body = player;
			_mark = ["new", position player] call OO_MARKER;

			while {true} do {
				if !(player hasWeapon "ItemGPS") then {
					player addWeapon "ItemGPS";
				};
				openMap [true, true];
				mapAnimAdd [1, 0.01, _body]; 
				mapAnimCommit;
				deletevehicle _body;
				[] call WC_fnc_teleport;
				openMap [false, false];
				["Attach", player] spawn _mark;
				["SetText", name player] spawn _mark;
				["SetColor", "ColorGreen"] spawn _mark;
				["SetType", "mil_arrow"] spawn _mark;
				["SetSize", [0.5,0.5]] spawn _mark;
				_body = player;
				waituntil {!alive player};
				"Detach" spawn _mark;
				["SetColor", "ColorRed"] spawn _mark;
				["SetPos", position _body] spawn _mark;
				["SetType", "mil_flag"] spawn _mark;
				["Draw", "ColorRed"] spawn _mark;
				waituntil {alive player};
			};
		};
	};


	// fast time server & client
	if(PARAM_fastime == 1) then {
		[] spawn {
			while {true} do {
				skiptime 0.01;
				sleep 10;
			};
		};
	};