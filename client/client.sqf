		private ["_body", "_index", "_position", "_mark", "_vehicle"];

		_body = player;
		_vehicle = vehicle player;

		_mark = ["new", position player] call OO_MARKER;

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
			deletevehicle _vehicle;

			switch (typeof player) do {
				case "B_Soldier_F": {
					[] call WC_fnc_teleport;
				};
				case "B_Pilot_F": {
					[] call WC_fnc_teleportplane;
				};
			};

			openMap [false, false];
			
			player removeEventHandler ["HandleDamage", _index];
			["attachTo", player] spawn _mark;
			["setText", name player] spawn _mark;
			["setColor", "ColorGreen"] spawn _mark;
			["setType", "mil_arrow"] spawn _mark;
			["setSize", [0.5,0.5]] spawn _mark;
			_body = player;
			_vehicle = vehicle player;

			waituntil {!alive player};

			wccam = "camera" camCreate (position killer);
			wccam cameraEffect ["internal","back"];
	
			wccam camsettarget killer;
			wccam camsetrelpos [-10,-10,5];
			wccam CamCommit 0;

			wccam camsettarget _body;
			wccam camCommand "inertia on";
			wccam camSetPos [((position _body) select 0) + 5, ((position _body) select 1) + 5, 10];
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