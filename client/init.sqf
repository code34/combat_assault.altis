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

	private ["_body", "_icon", "_index", "_position", "_mark", "_vehicle", "_group", "_reload", "_markchopper"];

	WC_fnc_teleport = compilefinal preprocessFile "client\scripts\teleport.sqf";
	WC_fnc_teleportplane = compilefinal preprocessFile "client\scripts\teleport_plane.sqf";
	WC_fnc_teleporttank = compilefinal preprocessFile "client\scripts\teleport_tank.sqf";
	WC_fnc_teleportchopper = compilefinal preprocessFile "client\scripts\teleport_chopper.sqf";

	call compilefinal preprocessFileLineNumbers "client\objects\oo_marker.sqf";
	call compilefinal preprocessFileLineNumbers "client\objects\oo_hud.sqf";
	call compilefinal preprocessFileLineNumbers "client\objects\oo_reloadplane.sqf";
	call compilefinal preprocessFileLineNumbers "client\BME\init.sqf";	

	mystats = [0,0,0];

	hud = ["new", []] call OO_HUD;
	"drawAll" spawn hud;
	"bottomHud" spawn hud;

	[] execVM "real_weather\real_weather.sqf";

	sleep 1;
	enableEnvironment false;

	player addEventHandler ['Killed', {
		private ["_name"];
		
		killer = _this select 1;
		_name = "";

		if(killer isKindOf "Man") then {
			_name = name killer;
			if(_name == "Error: No unit") then { _name = "";} ;
		} else {
			_name= getText (configFile >> "CfgVehicles" >> (typeOf killer) >> "DisplayName");
		};

		wcdeath = [name player, playertype, _name];
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
	//playMusic ["LeadTrack01a_F", 2];

	["<t size='3'>COMBAT ASSAULT</t><br/><br/><t size='2'><t color='#ff9900'>Beta</t> Version<br/>Author: code34</t><br/><t size='1'>Make Arma Not War contest 2014<br/>Website: combat-assault.eu<br/>Teamspeak: combat-assault.eu<br/></t>",0.02,-0.7,25,5,2,3011] spawn bis_fnc_dynamicText;

	_body = player;
	_vehicle = vehicle player;

	_mark = ["new", position player] call OO_MARKER;
	localplayerstats = [];

	playertype = player getvariable "type";
	if((playertype == "bomber") or (playertype == "fighter")) then {
		setviewdistance 3000;
		_reload = ["new", [playertype]] call OO_RELOADPLANE;
	};

	if(playertype == "chopper") then {
		setviewdistance 3000;
		_markchopper = ["new", position player] call OO_MARKER;
		["attachTo", player] spawn _markchopper;
		["setShape", "ELLIPSE"] spawn _markchopper;
		["setText", name player] spawn _markchopper;
		["setColor", "ColorBlue"] spawn _markchopper;
		["setSize", [1,1]] spawn _markchopper;
	};

	// MAIN LOOP
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
		_vehicle spawn {
			while { count (crew _this) > 0 } do { sleep 1; };
			deletevehicle _this;
		};
		

		switch (playertype) do {
			case "soldier": {
				[] call WC_fnc_teleport;
				_icon =	"mil_arrow2";
			};

			case "medic": {
				[] call WC_fnc_teleport;
				_icon = "b_med";
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

			case "chopper": {
				[] call WC_fnc_teleportchopper;
				_icon = "b_air";
				["setSize", [150,150]] spawn _markchopper;
				["attachTo", player] spawn _markchopper;
			};
		};

		openMap [false, false];
		// debug end	
		//player removeEventHandler ["HandleDamage", _index];
		["attachTo", player] spawn _mark;
		["setText", name player] spawn _mark;
		["setColor", "ColorGreen"] spawn _mark;
		["setType", _icon] spawn _mark;
		["setSize", [0.5,0.5]] spawn _mark;
		_body = player;
		_vehicle = vehicle player;
		_group = group player;

		waituntil {!alive player};

		if(isnil "killer") then { killer = _body;};
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

		if(playertype == "chopper") then {
			"detach" spawn _markchopper;
			["setSize", [1,1]] spawn _markchopper;
		};

		waituntil {alive player};

		wccam cameraEffect ["terminate","back"];
		camDestroy wccam;
	};