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

	private ["_cam", "_deathposition",  "_ctrl", "_ctrl2", "_ctrl3", "_player", "_position", "_dir",  "_inforoles", "_old_fullmap", "_players", "_indexplayer", "_map", "_positionplayer"];

	_deathposition = _this;

	playertype ='ammobox';
	fullmap = 0;
	_old_fullmap = 0;

	_position = [(getMarkerPos "respawn_west") select 0, (getMarkerPos "respawn_west") select 1, 300];
	_positionplayer = position player;

	showCinemaBorder false;
	_cam = "camera" camCreate _position;
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

	_indexplayer = -1;
	
	_players = allplayers;
	lbClear 2002;
	{ 
		//if((name _x in wcfriendlist) or (_x == player)) then {
			if(alive _x) then {
				lbAdd [2002, name _x];
				if(_x == player) then { _indexplayer = _forEachIndex;};
			};
		//} else {
		//	_players = _players - [_x];
		//};
		sleep 0.001;
	}foreach _players;
	lbSetCurSel [ 2002, _indexplayer];
	_player = player;

	_map ctrlMapAnimAdd [0, 0, _deathposition];
	ctrlMapAnimCommit _map;
	
	wcchange  = false;

		while { dialog } do {
			// on ferme le dialog uniquement
			// si la cible n'est pas dans les airs
			// si la cible est vivante
			if(wcaction == "deploy") then {
				if !(((getpos _player) select 2 > 2)  or !(alive _player)) then {
					closeDialog 0;
				};
			};

			if(wcaction == "equipment") then {
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
				
				_players = allplayers;
				lbClear 2002;
				{ 
					//if((side _x == side player) and ((name _x in wcfriendlist) or (_x == player))) then {
						if(alive _x) then {
							lbAdd [2002, name _x];
							if(_x == player) then { _indexplayer = _forEachIndex;};
						};
					//} else {
					//	_players = _players - [_x];
					//};
					sleep 0.001;
				}foreach _players;
				lbSetCurSel [ 2002, _indexplayer];
				_player = player;

				if (needReload player == 1) then {reload player};
				["save", player] spawn inventory;
				wcaction = "";
				_player = player;
				wcchange = true;
			};

			if(wcaction == "friendsmanagement") then {
				//[] execVM "client\scripts\givehug.sqf";
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

			if ((lbCurSel 2002) != -1) then {
				_indexplayer = (lbCurSel 2002);
				_player = _players select _indexplayer;
				wcchange = true;
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

			if(wcchange) then {
				if(_player isequalto player) then {
					_map ctrlMapAnimAdd [0, 0, _deathposition]; 
					ctrlMapAnimCommit _map;
					
					detach _cam;
					_cam cameraEffect ["internal","top"];
					_cam camsettarget player;
					_cam camSetRelPos [0,100,50];
					_cam CamCommit 0;
				} else {
					_map ctrlMapAnimAdd [0, 0, _player]; 
					ctrlMapAnimCommit _map;

					detach _cam;
					if(vehicle _player == _player) then {
						_cam cameraEffect ["internal", "BACK"];
						_cam camSetTarget _player;
						_cam attachto [_player,[0.7,-3, + 0.5], "neck"];
						_cam CamCommit 0;
					} else {
						_cam cameraEffect ["internal", "BACK"];
						_cam camSetTarget (vehicle _player);	
						//_variation = [-50, -30,-10, 10 ,30, 50];
						//_cam attachto [(vehicle _player),[_variation call BIS_fnc_selectRandom,-50,+15], "neck"];
						_cam attachto [(vehicle _player),[-50,-50,+15], "neck"];
						_cam CamCommit 0;
					};
				};
				wcchange  = false;
			};

			sleep 0.01;
		};

	closeDialog 0;
	_playertype = "ammobox";
	_position = position _cam;
	_dir = getDir _cam;

	_cam cameraEffect ["terminate","back"];
	camDestroy _cam;

	if(wcaction isEqualTo "exit") exitWith {};

	if(_player == player) then {
		openMap [false, false] ;
		openMap [true, true];
		mapAnimAdd [1, 0.30, _deathposition]; 
		mapAnimCommit;
		[] call WC_fnc_teleport;
	} else {
		if(_position distance getmarkerpos "respawn_west" < 1000) then {
			openMap [false, false] ;
			openMap [true, true];
			mapAnimAdd [1, 0.30, _deathposition]; 
			mapAnimCommit;
			[] call WC_fnc_teleport;
		} else {
			if(vehicle _player == _player) then {
				player setpos _position;
				player setdir _dir;
				//[] call WC_fnc_teleport;
			} else {
				if((vehicle _player) emptyPositions "cargo" == 0) then {
					_position = [position (vehicle _player), 5, random 359] call BIS_fnc_relPos;
					player setpos _position;
					player setdir (getdir (vehicle _player));
					//[] call WC_fnc_teleport;
				} else {
					player moveInAny (vehicle _player);
				};
			};
		};
	};

	//while { position player distance _positionplayer < 100 } do { sleep 0.1;};
	//closeDialog 0;
	openMap [false, false];
	[] call WC_fnc_spawncam;