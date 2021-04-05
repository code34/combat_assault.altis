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

	private ["_ctrl", "_ctrl2", "_ctrl3", "_ctrl4", "_player", "_dir", "_players", "_indexplayer", "_map", "_newevent"];

	private _deathposition = _this;
	fullmap = 0;
	private _old_fullmap = 1;
	private _camtarget = objNull;
	private _position = [(getMarkerPos "respawn_west") select 0, (getMarkerPos "respawn_west") select 1, 300];
	private _baseposition = _position;

	showCinemaBorder false;
	private _cam = "camera" camCreate _position;
	detach _cam;
	_cam cameraEffect ["internal","top"];
	_cam camsettarget player;
	_cam camSetRelPos [0,100,50];
	_cam CamCommit 0;

	disableSerialization;
	wcaction = "";

	createDialog "spawndialog"; 
	sleep 0.01;
	_map = ((uiNamespace getVariable 'wcspawndialog') displayCtrl 2003);
	_ctrl = (uiNamespace getVariable 'wcspawndialog') displayCtrl 2005;
	_ctrl2 = (uiNamespace getVariable 'wcspawndialog') displayCtrl 2006;
	_ctrl3 = (uiNamespace getVariable 'wcspawndialog') displayCtrl 2007;
	_ctrl4 = (uiNamespace getVariable 'wcspawndialog') displayCtrl 2008;
	_ctrl5 = (uiNamespace getVariable 'wcspawndialog') displayCtrl 2009;

	if(wcwithfriendsmarkers) then {
		_ctrl3 ctrlSetText (localize "STR_FRIENDSMARKERSON_BUTTON");
	} else {
		_ctrl3 ctrlSetText (localize "STR_FRIENDSMARKERSOFF_BUTTON");
	};

	if(wcwithrollmessages) then {
		_ctrl ctrlSetText (localize "STR_ROLLMESSAGEON_BUTTON");
	} else {
		_ctrl ctrlSetText (localize "STR_ROLLMESSAGEOFF_BUTTON");
	};

	if(wcwithunitstagslocked) then {
		_ctrl5 ctrlEnable false;
		_ctrl5 ctrlSetText (localize "STR_UNITTAGOFF_BUTTON");
	} else {
		if(wcwithunitstags) then {
			_ctrl5 ctrlSetText (localize "STR_UNITTAGON_BUTTON");
		} else {
			_ctrl5 ctrlSetText (localize "STR_UNITTAGOFF_BUTTON");
		};
	};

	_indexplayer = -1;
	_players = allPlayers;
	lbClear 2002;
	{ 
			if(alive _x) then {
				lbAdd [2002, name _x];
				if(_x == player) then { _indexplayer = _forEachIndex;};
			};
		sleep 0.001;
	}foreach _players;
	lbSetCurSel [ 2002, _indexplayer];
	_player = player;

	_map ctrlMapAnimAdd [0, 0, _baseposition];
	ctrlMapAnimCommit _map;
	
	_newevent  = false;
	while { dialog } do {
		// on ferme le dialog uniquement
		// si la cible n'est pas dans les airs
		// si la cible est vivante
		if(wcaction == "deploy") then {
			if !(((getpos _player) select 2 > 2)  or !(alive _player)) then {
				closeDialog 0;
			};
		};

		if(wcaction isEqualTo "equipment") then {
			closeDialog 0;
			_title = localize "STR_EQUIPMENT_TITLE";
			_text = localize "STR_EQUIPMENT_TEXT";
			["hint", [_title, _text]] call hud;	
			["Open",[true,nil,player]] call bis_fnc_arsenal;
			sleep 1;
			while { !isnull (uinamespace getvariable "BIS_fnc_arsenal_cam") } do {
				sleep 0.01;
			};
			player addWeapon "ItemMap";
			createDialog "spawndialog"; 
			sleep 0.01;

			_map = (uiNamespace getVariable 'wcspawndialog') displayCtrl 2003;
			_ctrl = (uiNamespace getVariable 'wcspawndialog') displayCtrl 2005;
			_ctrl2 = (uiNamespace getVariable 'wcspawndialog') displayCtrl 2006;
			_ctrl3 = (uiNamespace getVariable 'wcspawndialog') displayCtrl 2007;
			_ctrl4 = (uiNamespace getVariable 'wcspawndialog') displayCtrl 2008;
			_ctrl5 = (uiNamespace getVariable 'wcspawndialog') displayCtrl 2009;

			if(wcwithfriendsmarkers) then {
				_ctrl3 ctrlSetText (localize "STR_FRIENDSMARKERSON_BUTTON");
			} else {
				_ctrl3 ctrlSetText (localize "STR_FRIENDSMARKERSOFF_BUTTON");
			};

			if(wcwithrollmessages) then {
				_ctrl ctrlSetText (localize "STR_ROLLMESSAGEON_BUTTON");
			} else {
				_ctrl ctrlSetText (localize "STR_ROLLMESSAGEOFF_BUTTON");
			};

			if(wcwithunitstagslocked) then {
				_ctrl5 ctrlEnable false;
				_ctrl5 ctrlSetText (localize "STR_UNITTAGOFF_BUTTON");
			} else {
				if(wcwithunitstags) then {
					_ctrl5 ctrlSetText (localize "STR_UNITTAGON_BUTTON");
				} else {
					_ctrl5 ctrlSetText (localize "STR_UNITTAGOFF_BUTTON");
				};
			};

			_indexplayer = -1;
			_players = allPlayers;
			lbClear 2002;
			{ 
				if(alive _x) then {
					lbAdd [2002, name _x];
					if(_x == player) then { _indexplayer = _forEachIndex;};
				};
				sleep 0.001;
			}foreach _players;
			lbSetCurSel [ 2002, _indexplayer];
			_player = player;

			if (needReload player == 1) then {reload player};
			["save", player] spawn inventory;
			wcaction = "";
			_player = player;
			_newevent = true;
		};

		if(wcaction isEqualTo "friendsmanagement") then {
			wcaction = "";
			wcwithfriendsmarkers = !wcwithfriendsmarkers;
			if(wcwithfriendsmarkers) then {
				_ctrl3 ctrlSetText (localize "STR_FRIENDSMARKERSON_BUTTON");
			} else {
				_ctrl3 ctrlSetText (localize "STR_FRIENDSMARKERSOFF_BUTTON");
			};
			_ctrl3 ctrlcommit 0;
		};


		if(wcaction == "rollmessage") then {
			wcaction = "";
			wcwithrollmessages = !wcwithrollmessages;
			if(wcwithrollmessages) then {
				_ctrl ctrlSetText (localize "STR_ROLLMESSAGEON_BUTTON");
			} else {
				_ctrl ctrlSetText (localize "STR_ROLLMESSAGEOFF_BUTTON");
			};
			_ctrl ctrlcommit 0;
		};

		if(wcaction == "unittags") then {
			wcaction = "";
			wcwithunitstags = !wcwithunitstags;
			if(wcwithunitstags) then {
				_ctrl5 ctrlSetText (localize "STR_UNITTAGON_BUTTON");
			} else {
				_ctrl5 ctrlSetText (localize "STR_UNITTAGOFF_BUTTON");
			};
			_ctrl5 ctrlcommit 0;	
		};

		if ((lbCurSel 2002) != -1) then {
			_indexplayer = (lbCurSel 2002);
			_player = _players select _indexplayer;
			_newevent = true;
		};

		if ( _old_fullmap != fullmap ) then {
			_old_fullmap = fullmap;
			if ( fullmap % 2 == 1 ) then {
				_map ctrlShow false;
				_map ctrlCommit 0;
				_ctrl2 ctrlSetText (localize "STR_SHOWMAP_BUTTON");
			} else {
				_map ctrlShow true;
				_map ctrlCommit 0;
				_ctrl2 ctrlSetText (localize "STR_HIDEMAP_BUTTON");
			};
			_map  ctrlCommit 0.2;
		};

		if(_newevent) then {
			if!(_camtarget isEqualTo _player) then {
				_camtarget = _player;
				// si le joueur ne choisit rien
				// on lui propose le paradrop
				if(_player isequalto player) then {
					_ctrl4 ctrlSetText (localize "STR_PARADROP_BUTTON");	
					_map ctrlMapAnimAdd [0, 0, _baseposition]; 
					ctrlMapAnimCommit _map;
					
					detach _cam;
					_cam cameraEffect ["internal","top"];
					_cam camsettarget player;
					_cam camSetRelPos [0,100,50];
					_cam CamCommit 0;
				} else {
					// si le joueur choisit un autre joueur
					// on affiche la camera derrière le joueur
					// on propose le bouton deployer
					_ctrl4 ctrlSetText (localize "STR_DEPLOY_BUTTON");
					_map ctrlMapAnimAdd [0, 0, _player]; 
					ctrlMapAnimCommit _map;
					detach _cam;
					if(vehicle _player isEqualTo _player) then {
						_cam cameraEffect ["internal", "BACK"];
						_cam camSetTarget _player;
						_cam attachto [_player,[0.7,-3, + 0.5], "neck"];
						_cam CamCommit 0;
					} else {
						_cam cameraEffect ["internal", "BACK"];
						_cam camSetTarget (vehicle _player);	
						_cam attachto [(vehicle _player),[-50,-50,+15], "neck"];
						_cam CamCommit 0;
					};
				};
				_newevent  = false;
			};
		};
		sleep 0.1;
	};
	closeDialog 0;

	_position = position _cam;
	_dir = getDir _cam;
	_cam cameraEffect ["terminate","back"];
	camDestroy _cam;

	if(wcaction != "deploy") exitWith {};

	if(_player == player) then {
		// si le joueur se selectionne
		// alors ouverture de la map + paradrop
		if(!isNil "newdeploymentmark") then {
			_position = getMarkerPos "newdeploymentmark";
			deleteMarkerLocal "newdeploymentmark";
			_position call WC_fnc_paradrop2;
		};
	} else {
		// si le joueur selectionne un autre joueur loin de la base
		// alors on le teleport sur _position + _dir de la camere derrière le joueur
		if(vehicle _player == _player) then {
			player setpos _position;
			player setdir _dir;
		} else {
			if((vehicle _player) emptyPositions "cargo" < 1) then {
				_position = [position (vehicle _player), 10, random 359] call BIS_fnc_relPos;
				player setpos _position;
				player setdir (getdir (vehicle _player));
			} else {
				player moveInAny (vehicle _player);
			};
		};
	};
	[] call WC_fnc_spawncam;