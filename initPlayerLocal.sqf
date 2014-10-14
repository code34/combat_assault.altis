	if (local player) then {
		// init warcontext function
		WC_fnc_teleport = compilefinal preprocessFile "client\teleport.sqf";
		WC_fnc_teleportplane = compilefinal preprocessFile "client\teleport_plane.sqf";
		WC_fnc_teleporttank = compilefinal preprocessFile "client\teleport_tank.sqf";
		WC_fnc_teleportchopper = compilefinal preprocessFile "client\teleport_chopper.sqf";
		WC_fnc_client = compilefinal preprocessFileLineNumbers "client\client.sqf";

		call compilefinal preprocessFileLineNumbers "client\oo_marker.sqf";
		call compilefinal preprocessFileLineNumbers "client\oo_hud.sqf";
		call compilefinal preprocessFileLineNumbers "client\oo_reloadplane.sqf";
		call compilefinal preprocessFileLineNumbers "client\BME\init.sqf";	

		hud = ["new", []] call OO_HUD;
		"drawAll" spawn hud;

		[] execVM "real_weather\real_weather.sqf";

		sleep 1;
		enableEnvironment false;

		player addEventHandler ['Killed', {
			killer = _this select 1;
			wcdeath = [name player, playertype];
			["wcdeath", "server"] call BME_fnc_publicvariable;
		}];

		player addEventHandler ['HandleDamage', {
			if(side(_this select 3) in [east, resistance]) then {
				if(alive (_this select 0)) then {
					_damage = 1 - damage(_this select 0);
					(_this select 0) setdamage (damage(_this select 0) + random(_damage));
				};
			};
		}];

		player createDiaryRecord ["Diary", ["Situation", "Things are going bad on Altis Island. Try to find a way to defeat the enemy and perphaps you will have a luck to go out of this doom maze"]];
		_task = player createSimpleTask ["Mission"];
		_task setSimpleTaskDescription ["Hi! you just come back to Altis Island. A Pretty nice island where you went on holidays. A this time, it is a fucking island with hot temperatures, under enemies control. Soldier, you have to go to Altis Island and organise the takeover of this island", "Go and retrieve the Altis Island", "Task HUD Title"];

		playMusic "intro";
		["<t size='3'>COMBAT ASSAULT</t><br/><br/><t size='2'><t color='#ff9900'>Beta</t> Version<br/>Author: code34</t><br/><t size='1'>Make Arma Not War contest 2014<br/>Website: combat-assault.eu<br/>Teamspeak: combat-assault.eu<br/></t>",0.02,-0.7,25,5,2,3011] spawn bis_fnc_dynamicText;

		[] spawn WC_fnc_client;
	};