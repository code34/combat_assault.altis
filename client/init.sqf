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

	private ["_action", "_body", "_dir", "_index", "_position", "_mark", "_group", "_units", "_view"];

		diag_log "Waiting BIS_fnc_init ...";
		waitUntil {BIS_fnc_init;};

		diag_log "Waiting Time over 0 ...";
		waitUntil {time > 0};

		diag_log "Waiting client read briefing ...";
		waitUntil {getClientState == "BRIEFING READ"};

		diag_log "Waiting player is alive ...";
		waitUntil {alive player;};

	[] spawn {

		WC_fnc_spawndialog = compilefinal preprocessFileLineNumbers "client\scripts\spawndialog.sqf";
		WC_fnc_teleport = compilefinal preprocessFileLineNumbers "client\scripts\teleport.sqf";
		WC_fnc_keymapperup = compilefinal preprocessFileLineNumbers "client\scripts\WC_fnc_keymapperup.sqf";
		WC_fnc_keymapperdown = compilefinal preprocessFileLineNumbers "client\scripts\WC_fnc_keymapperdown.sqf";
		
		call compilefinal preprocessFileLineNumbers "client\scripts\task.sqf";
		call compilefinal preprocessFileLineNumbers "client\objects\oo_circularlist.sqf";
		call compilefinal preprocessFileLineNumbers "client\objects\oo_marker.sqf";
		call compilefinal preprocessFileLineNumbers "client\objects\oo_inventory.sqf";
		call compilefinal preprocessFileLineNumbers "client\objects\oo_hud.sqf";
		call compilefinal preprocessFileLineNumbers "client\objects\oo_reloadplane.sqf";
		call compilefinal preprocessFileLineNumbers "client\objects\oo_scoreboard.sqf";
		call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_hashmap.sqf";
		call compilefinal preprocessFileLineNumbers "warcontext\scripts\paramsarray_parser.sqf";	
		call compilefinal preprocessFileLineNumbers "client\BME\init.sqf";
		call compilefinal preprocessFileLineNumbers "warcontext\objects\oo_grid.sqf";
	};


	WC_fnc_introcam = compileFinal preprocessFileLineNumbers "client\scripts\intro_cam.sqf";
	[] call WC_fnc_introcam;

	// config variables
	wcbannerserver = "TS: COMBAT-ASSAULT.EU";
	wcboard = false;
	wcwithrollmessages = true;

	wcticket = 0;
	playerkill = 0;
	playerdeath = 0;
	
	scoreboard = ["new", []] call OO_SCOREBOARD;
	client_grid = ["new", [31000,31000,100,100]] call OO_GRID;

	rollmessage = ["<br/>", "<br/>","<br/>", "<br/>","<br/>", "<br/>", "<br/>", "<br/>", "<br/>", "<br/>", "<br/>", "<t size='1.2'>"+(localize "STR_INTRO_WELCOME")+"</t><br/>", (localize "STR_INTRO_WEBSITE")+"<br/>","<br/>", (localize "STR_INTRO_TRAIN")+"<br/>", (localize "STR_INTRO_RANK")+"<br/>", (localize "STR_INTRO_WINWAR")+"<br/> ", "<br/>", "<br/>", (localize "STR_INTRO_GOODLUCK")+"<br/>",  (localize "STR_INTRO_AUTHOR")+"<br/><br/>"];
	rollprintmessage = "";

	hud = ["new", []] call OO_HUD;
	"drawAll" spawn hud;
	"rollMessage" spawn hud;
	"bottomHud" spawn hud;
	"scoreboardHud" spawn hud;

	inventory = ["new", []] call OO_INVENTORY;
	["save", player] call inventory;

	[] execVM "real_weather\real_weather.sqf";

	if(wcambiant ==2) then {
		enableEnvironment false;
		enableSentences false;
	};

	player addEventHandler ['Killed', {
		private ["_name", "_weapon"];
		
		killer = _this select 1;
		_name = "";
		_weapon = currentWeapon killer;

		if(killer isKindOf "Man") then {
			_name = name killer;
			if(_name == "Error: No unit") then { _name = "";} ;
		} else {
			_name= getText (configFile >> "CfgVehicles" >> (typeOf killer) >> "DisplayName");
		};

		wcdeath = [name player, playertype, _name, _weapon];
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

	_body = player;
	_view = cameraView;
	_mark = ["new", [position player, true]] call OO_MARKER;

	playertype = "ammobox";

	[] spawn {
		private ["_action", "_script", "_oldplayertype"];
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
					_script = format ["client\scripts\pop%1.sqf", playertype];
					_action = player addAction [format ["Get %1", playertype], _script, nil, 1.5, false];
				};
			} else {
				if(!isnil "_action") then {
					player removeAction _action;
					_action = nil;
				};
			};
			if(!alive player) then {_action = nil;};
			sleep 1;
		};
	};
	
	[] spawn {
		while { true } do {
			if((damage player > 0) and (damage player  < 1.01)) then {
				player setDamage (damage player - 0.01); 
				player setBleedingRemaining 30;
			};
			sleep 1;
		};
	};

	if(wcredeployement isEqualTo 1) then {
		[] spawn {
			private ["_list", "_list2", "_counter", "_text", "_candeploy", "_teleport"];
			
			_counter = 10;
			_teleport = nil;

			while { true } do {
				_list = position player nearEntities [["Man"], 1000];
				_list2 = position player nearEntities [["Tank"], 1000];
				sleep 1;
				{
					_list = _list + crew _x;
					sleep 0.001;
				}foreach _list2;

				_candeploy = false;
				if(player distance getmarkerpos "respawn_west" > 1300) then {
					if((alive player) and (vehicle player == player)) then {		
						if( (east countSide _list == 0) and (resistance countSide _list == 0) ) then {
							_title = localize "STR_REDEPLOY_TITLE";
							_text = localize "STR_REDEPLOY_STANCE";
							["hint", [_title, _text]] call hud;
							_candeploy = true;
						} else {
							hint "";
						};
					};
				};

				if(_candeploy) then {
					if(isnil "_teleport") then {
						_teleport = player addAction ["Deployement", "client\scripts\deployment.sqf", nil, 1.5, false];
					};
				} else {
					if(!isnil "_teleport") then {
						player removeAction _teleport;
						_teleport = nil;
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

	// MAIN LOOP
	while {true} do {
		_index = player addEventHandler ["HandleDamage", {false}];
		setviewdistance 1500;

		if(wcfatigue == 2) then { player enableFatigue false; };
	
		["load", player] spawn inventory;	
		[_body] call WC_fnc_spawndialog;

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