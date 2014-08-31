	// init warcontext function
	WC_fnc_teleport = compile preprocessFile "client\teleport.sqf";
	call compilefinal preprocessFileLineNumbers "client\oo_marker.sqf";
	call compilefinal preprocessFileLineNumbers "client\BME\init.sqf";

	[] execVM "real_weather\real_weather.sqf";

	if (local player) then {
		sleep 1;
		enableEnvironment false;

		private ["_body", "_index"];
		_body = player;
		_mark = ["new", position player] call OO_MARKER;

		player addEventHandler ['Killed', {
			killer = _this select 1;
			death = true;
			["death", "client"] call BME_fnc_publicvariable;
		}];

		player addEventHandler ['HandleDamage', {
			if(side(_this select 3) in [east, resistance]) then {
				(_this select 0) setdamage (damage(_this select 0) + (random 1));
			};
		}];

		while {true} do {
			_index = player addEventHandler ["HandleDamage", {false}];
			if !(player hasWeapon "ItemGPS") then {
				player addWeapon "ItemGPS";
			};

			_position = position player;
			["Open",[true,nil,player]] call bis_fnc_arsenal;
			while { _position distance position player < 2 } do {
				sleep 0.1
			};

			openMap [true, true];
			mapAnimAdd [1, 0.01, _body]; 
			mapAnimCommit;
			deletevehicle _body;
			[] call WC_fnc_teleport;
			openMap [false, false];

			player removeEventHandler ["HandleDamage", _index];
			["attachTo", player] spawn _mark;
			["setText", name player] spawn _mark;
			["setColor", "ColorGreen"] spawn _mark;
			["setType", "mil_arrow"] spawn _mark;
			["setSize", [0.5,0.5]] spawn _mark;
			_body = player;

			waituntil {!alive player};

			wccam = "camera" camCreate (position _body);
			wccam cameraEffect ["internal","back"];
	
			//wccam camsettarget _body;
			//wccam camsetrelpos [0,0,10];
			//wccam CamCommit 0;

			wccam camsettarget killer;
			wccam camCommand "inertia on";
			wccam camSetPos [((position killer) select 0) + 5, ((position killer) select 1) + 5, 10];
			wccam CamCommit 5;

			"detach" spawn _mark;
			["setColor", "ColorRed"] spawn _mark;
			["setPos", position _body] spawn _mark;
			["setType", "mil_flag"] spawn _mark;
			["draw", "ColorRed"] spawn _mark;

			waituntil {alive player};

			wccam cameraEffect ["terminate","back"];
			camDestroy wccam;

			};
	};