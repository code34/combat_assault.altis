		
		private ["_body", "_icon", "_index", "_position", "_mark", "_vehicle", "_group", "_reload"];

		_body = player;
		_vehicle = vehicle player;

		_mark = ["new", position player] call OO_MARKER;

		hud = ["new", []] call OO_HUD;
		"drawAll" spawn hud;

		playertype = player getvariable "type";

		if((playertype == "bomber") or (playertype == "fighter")) then {
			_reload = ["new", []] call OO_RELOADPLANE;
		};

		while {true} do {
			_index = player addEventHandler ["HandleDamage", {false}];
			if !(player hasWeapon "ItemGPS") then {
				player addWeapon "ItemGPS";
			};

			_position = position player;

			_title = "Select your equipment";
			_text = "Take magazines as items of your vest or bag and go ahead to teleport on zone!";
			["hint", [_title, _text]] call hud;
			
			["Open",[true,nil,player]] call bis_fnc_arsenal;

			while { _position distance position player < 2 } do {
				sleep 0.1
			};
	
			openMap [true, true];
			mapAnimAdd [1, 0.01, _body]; 
			mapAnimCommit;
			deletevehicle _body;
			deletevehicle _vehicle;

			switch (playertype) do {
				case "soldier": {
					[] call WC_fnc_teleport;
					_icon =	"mil_arrow";
				};
				case "fighter": {
					[] call WC_fnc_teleportplane;
					"start" spawn _reload;
					_icon = "b_plane";
				};
				case "bomber": {
					[] call WC_fnc_teleportplane;
					"start" spawn _reload;
					_icon = "b_plane";
				};
				case "tank": {
					[] call WC_fnc_teleporttank;
					_icon = "b_armor";
				};

				case "tankaa": {
					[] call WC_fnc_teleporttank;
					_icon = "b_armor";
				};
			};

			openMap [false, false];
			
			player removeEventHandler ["HandleDamage", _index];
			["attachTo", player] spawn _mark;
			["setText", name player] spawn _mark;
			["setColor", "ColorGreen"] spawn _mark;
			["setType", _icon] spawn _mark;
			["setSize", [0.5,0.5]] spawn _mark;
			_body = player;
			_vehicle = vehicle player;
			_group = group player;

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

			if((playertype == "bomber") or (playertype == "fighter")) then {
				"stop" call _reload;
			};

			waituntil {alive player};

			wccam cameraEffect ["terminate","back"];
			camDestroy wccam;
		};