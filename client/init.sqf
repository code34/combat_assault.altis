	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2013-2021 Nicolas BOITEUX
	
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

	private ["_action", "_body", "_dir", "_index", "_position", "_mark", "_group", "_units", "_view"];

	15203 cutText ["Loading...","BLACK FADED", 1000];
	//startLoadingScreen ["Loading Mission", _layer2];

	diag_log "Waiting BIS_fnc_init ...";
	waitUntil {BIS_fnc_init;};

	diag_log "Waiting Time over 0 ...";
	waitUntil {time > 0};

	diag_log "Waiting client read briefing ...";
	waitUntil {getClientState == "BRIEFING READ"};

	diag_log "Waiting player is alive ...";
	waitUntil {alive player && !(isNull player);};

	while { (getMarkerPos "globalbase") isEqualTo [0,0,0] } do { 
		sleep 0.1; 
	};

	//progressLoadingScreen 1;
	_position = ((getMarkerPos "globalbase") findEmptyPosition [10,100]);
	player setpos _position;

	WC_fnc_spawndialog 	= compilefinal preprocessFileLineNumbers "client\scripts\spawndialog.sqf";
	WC_fnc_paradrop	= compilefinal preprocessFileLineNumbers "client\scripts\paradrop.sqf";
	WC_fnc_paradrop2	= compilefinal preprocessFileLineNumbers "client\scripts\paradrop2.sqf";
	WC_fnc_keymapperup 	= compilefinal preprocessFileLineNumbers "client\scripts\WC_fnc_keymapperup.sqf";
	WC_fnc_keymapperdown = compilefinal preprocessFileLineNumbers "client\scripts\WC_fnc_keymapperdown.sqf";
	WC_fnc_introcam 	= compileFinal preprocessFileLineNumbers "client\scripts\intro_cam.sqf";
	WC_fnc_spawncam 	= compileFinal preprocessFileLineNumbers "client\scripts\spawn_cam.sqf";
	WC_fnc_newdeployment 	= compileFinal preprocessFileLineNumbers "client\scripts\newdeployment.sqf";

	call compile preprocessFileLineNumbers "client\scripts\task.sqf";
	call compile preprocessFileLineNumbers "warcontext\scripts\paramsarray_parser.sqf";
	call compile preprocessFileLineNumbers "client\scripts\BME_clienthandler.sqf";
	call compile preprocessFileLineNumbers "client\objects\oo_bme.sqf";
	call compile preprocessFileLineNumbers "client\objects\oo_circularlist.sqf";
	call compile preprocessFileLineNumbers "client\objects\oo_marker.sqf";
	call compile preprocessFileLineNumbers "client\objects\oo_inventory.sqf";
	call compile preprocessFileLineNumbers "client\objects\oo_hud.sqf";
	call compile preprocessFileLineNumbers "client\objects\oo_reloadplane.sqf";
	call compile preprocessFileLineNumbers "client\objects\oo_scoreboard.sqf";
	call compile preprocessFileLineNumbers "client\objects\oo_playersmarker.sqf";
	call compile preprocessFileLineNumbers "client\objects\oo_camera.sqf";
	call compile preprocessFileLineNumbers "warcontext\objects\oo_grid.sqf";
	call compile preprocessFileLineNumbers "warcontext\objects\oo_hashmap.sqf";

	client_bme = "new" call OO_BME;

	rollmessage = [];
	killzone = [];
	rollprintmessage = "";
	wcblacklist = [name player];
	wcfriendlist = [];
	wcbannerserver = parsetext (localize "STR_MISSION_TITLE");
	wcboard = false;
	wcwithrollmessages = true;
	wcwithfriendsmarkers = true;	
	wcearplugs = false;
	wcticket = 0;
	playerkill = 0;
	playerdeath = 0;
	wccandeploy = true;
	wcmaxviewdistance = wcviewdistance;
	wcmaxvehicleviewdistance = wcvehicleviewdistance;
	wcmaxairvehicleviewdistance = wcairvehicleviewdistance;
	
	if(wcwithunitstagsparam isEqualTo 0) then {
		wcwithunitstags = false;
		wcwithunitstagslocked = true;
	}else{
		wcwithunitstags = true;
		wcwithunitstagslocked = false;
	};

	//endLoadingScreen;
	sleep 2;
	15203 cutText ["","PLAIN", 0];
	[] call WC_fnc_introcam;
	
	scoreboard = ["new", []] call OO_SCOREBOARD;
	_size = getNumber (configfile >> "CfgWorlds" >> worldName >> "mapSize");
	client_grid = ["new", [0,0, _size, _size,100,100]] call OO_GRID;
	
	playersmarkers = ["new", []] call OO_PLAYERSMARKER;
	"start" spawn playersmarkers;

	rollmessage = ["<br/>", "<br/>","<br/>", "<br/>","<br/>", "<br/>", "<br/>", "<br/>", "<br/>", "<br/>", "<br/>", "<t size='1.2'>"+(localize "STR_INTRO_WELCOME")+"</t><br/>", (localize "STR_INTRO_WEBSITE")+"<br/>","<br/>", (localize "STR_INTRO_TRAIN")+"<br/>", (localize "STR_INTRO_RANK")+"<br/>", (localize "STR_INTRO_WINWAR")+"<br/> ", "<br/>", "<br/>", (localize "STR_INTRO_GOODLUCK")+"<br/>",  (localize "STR_INTRO_AUTHOR")+"<br/><br/>"];
	rollprintmessage = "";

	hud = ["new", []] call OO_HUD;
	"drawAll" spawn hud;
	"rollMessage" spawn hud;
	"bottomHud" spawn hud;
	"scoreboardHud" spawn hud;

	switch (wcwithunitstags) do {
		case 1 :{["setPlayerTag", true] spawn hud;};
		case 2: {["setPlayerTag", false] spawn hud;};
		default {["setPlayerTag", true] spawn hud;};
	};

	inventory = ["new", []] call OO_INVENTORY;
	["save", player] call inventory;

	[] execVM "real_weather\real_weather.sqf";

	setGroupIconsVisible [false,false];
	disableUserInput false;
	disableUserInput true;
	disableUserInput false;

	if(wcambiant isEqualTo 0) then {
		enableEnvironment false;
		enableSentences false;
		player disableConversation true;
		enableRadio false;
		showSubtitles false;
		player setVariable ["BIS_noCoreConversations", true];
		systemchat "Ambiant life is off";
	} else {
		systemchat "Ambiant life is on";
	};

	player addEventHandler ['Killed', {
		killer = (_this select 1);
		["remoteSpawn", ["BME_netcode_server_setDeath", [(_this select 0), (_this select 1)], "server"]] call client_bme;
	}];

	player addEventHandler ['HandleDamage', {
		if(side(_this select 3) in [east, resistance]) then {
			if(alive (_this select 0)) then {
				_damage = 1 - damage(_this select 0);
				(_this select 0) setdamage (damage(_this select 0) + random(_damage));
			};
		};
	}];

	playertype = "ammobox";
	[] spawn {
		private ["_action", "_script", "_oldplayertype", "_earplug"];
		_oldplayertype = playertype;

		while { true} do {
			if(_oldplayertype != playertype) then {
				_oldplayertype = playertype;
				if(!isnil "_action") then {
					player removeAction _action;
					_action = nil;
				};
			};
			if(vehicle player == player) then {
				if(isnil "_action") then {
					_action = player addAction [localize "STR_VEHICLESSERVICING_TITLE", "client\scripts\popvehicle.sqf", nil, 1.5, false];
				};
			} else {
				if(!isnil "_action") then {
					player removeAction _action;
					_action = nil;
				};
			};
			if(isnil "_earplug") then {
				_earplug = player addAction ["Add/Remove earplugs", "client\scripts\earplugs.sqf", nil, 1.5, false, true];	
			};
			if(!alive player) then {
				_action = nil; 
				_earplug = nil;
			};
			sleep 1;
		};
	};

	// systeme de regen de vie auto ne fonctionne que si ACE est off
	private _isace = isClass(configFile >> "CfgPatches" >> "ace_main");
	if((wcwithhealthregen isEqualTo 1) and !_isace) then {
		systemchat "Health regen is on";
		[] spawn {
			while { true } do {
				switch (true) do {
					case (damage player < 0.40) : {
						player setDamage (damage player - 0.01); 
						player setBleedingRemaining 30;
						sleep 0.5;
					};

					case (damage player < 0.60) : {
						player setDamage (damage player - 0.01); 
						player setBleedingRemaining 30;
						sleep 0.6;
					};

					case (damage player < 0.70) : {
						player setDamage (damage player - 0.01); 
						player setBleedingRemaining 30;
						sleep 0.7;
					};

					case (damage player < 0.80) : {
						player setDamage (damage player - 0.01); 
						player setBleedingRemaining 30;
						sleep 0.8;
					};			

					case (damage player < 1.01) : {
						player setDamage (damage player - 0.01); 
						player setBleedingRemaining 30;
						sleep 0.9;
					};			
				};

			};
		};
	} else {
		systemchat "Health autoregen is off";
	};

	if(wcredeployement isEqualTo 1) then {
		[] spawn {
			private ["_list", "_list2", "_counter", "_candeploy", "_teleport"];
			
			_counter = 10;
			_teleport = nil;

			while { true } do {
				_list = position player nearEntities [["Man"], 1000];
				_list2 = position player nearEntities [["Tank"], 1000];
				sleep 1;
				{
					_list append crew _x;
					sleep 0.001;
				}foreach _list2;

				_candeploy = false;
				if((alive player) and (vehicle player == player)) then {
					if( (east countSide _list == 0) and (resistance countSide _list == 0) ) then {
						_candeploy = true;
					} else {
						hint "";
					};
				};

				if(_candeploy) then {
					if(isnil "_teleport") then {
						_teleport = player addAction [localize "STR_REDEPLOY_TITLE", "client\scripts\deployment.sqf", nil, 1.5, false];
						wccandeploy = true;
					};
				} else {
					if(!isnil "_teleport") then {
						player removeAction _teleport;
						_teleport = nil;
						wccandeploy = false;
					};
				};
			};
		};
	};

	[] spawn {
		sleep 5;
		findDisplay 46 displayAddEventHandler ["KeyDown", {_this call WC_fnc_keymapperdown;}];
		findDisplay 46 displayAddEventHandler ["KeyUp", {_this call WC_fnc_keymapperup;}];
	};


	_body = player;
	_view = cameraView;
	_mark = ["new", [position player, true]] call OO_MARKER;

	// set viewdistance
	[] spawn {
		while { true} do {
			if(vehicle player == player) then {
				setviewdistance wcviewdistance;
			} else {
				if(vehicle player isKindOf "Air") then {
					setviewdistance wcairvehicleviewdistance;
				} else {
					setviewdistance wcvehicleviewdistance;
				};
			};
			sleep 10;
		};
	};

	if(wcfatigue isEqualTo 0) then { 
		systemchat "Fatigue is off";
	} else {
		systemchat "Fatigue is on";
	};

	// MAIN LOOP
	while {true} do {
		if(wcspeedcoeef == 1) then {
			player setAnimSpeedCoef 1.2;
		};
		
		// Should be here to be effective each respawn
		if(wcfatigue isEqualTo 0) then { 
			player enableFatigue false; 
			player enableStamina false;
			player allowSprint true;
		};

		if(wcsway == 2) then { player setCustomAimCoef 0;};

		_index = player addEventHandler ["HandleDamage", {false}];
		["load", player] spawn inventory;	
		(position _body) call WC_fnc_spawndialog;
		 player switchCamera _view;

		// debug end	
		player removeEventHandler ["HandleDamage", _index];
		["attachTo", player] spawn _mark;
		["setText", name player] spawn _mark;
		["setColor", "ColorGreen"] spawn _mark;
		["setType", "mil_arrow2"] spawn _mark;
		["setSize", [0.5,0.5]] spawn _mark;
		
		_body = player;
		_group = group player;
		waituntil {!alive player};
		_view = cameraView;
		if(isnil "killer") then { killer = _body;};
		if(isNull killer) then  { killer = _body;};

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

		waituntil {alive player};
		deletevehicle _body;

		wccam cameraEffect ["terminate","back"];
		camDestroy wccam;
	};