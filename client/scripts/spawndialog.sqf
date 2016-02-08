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

	private ["_cam", "_body",  "_ctrl", "_player", "_position", "_dir",  "_inforoles", "_standard_map_pos", "_frame_pos", "_old_fullmap", "_players", "_indexplayer"];

	_body = _this select 0;

	playertype ='ammobox';

	fullmap = 0;
	_old_fullmap = 0;

	showCinemaBorder false;
	_cam = "camera" camCreate [position _body select 0, position _body select 1, 300];
	detach _cam;
	_cam cameraEffect ["internal","top"];
	_cam camsettarget _body;
	_cam camSetRelPos [0,100,300];
	_cam CamCommit 0;

	disableSerialization;
	wcaction = "";

	createDialog "spawndialog"; 
	sleep 0.01;
	
	_standard_map_pos = ctrlPosition ((uiNamespace getVariable 'wcspawndialog') displayCtrl 2003);
	_frame_pos = ctrlPosition ((uiNamespace getVariable 'wcspawndialog') displayCtrl 2004);

	_ctrl = (uiNamespace getVariable 'wcspawndialog') displayCtrl 2005;
	if(wcwithrollmessages) then {
		_ctrl ctrlSetText (localize "STR_ROLLMESSAGEON_BUTTON");
	} else {
		_ctrl ctrlSetText (localize "STR_ROLLMESSAGEOFF_BUTTON");
	};

	_players = playableUnits;
	lbClear 2002;
	{ 
		if(side _x == side player) then {
			if(alive _x) then {
				lbAdd [2002, name _x];
				if(_x == player) then { _indexplayer = _forEachIndex;};
			};
		} else {
			_players = _players - [_x];
		};
		sleep 0.001;
	}foreach _players;
	lbSetCurSel [ 2002, _indexplayer];
	_player = player;

	_ctrl = (uiNamespace getVariable 'wcspawndialog') displayCtrl 2003;
	_ctrl ctrlMapAnimAdd [0, 0, _body]; 
	ctrlMapAnimCommit _ctrl;		
	
	wcchange  = false;

		while { wcaction != "deploy" && dialog} do {
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
				createDialog "spawndialog"; 
				
				_players = playableUnits;
				lbClear 2002;
				{ 
					if(side _x == side player) then {
						if(alive _x) then {
							lbAdd [2002, name _x];
							if(_x == player) then { _indexplayer = _forEachIndex;};
						};
					} else {
						_players = _players - [_x];
					};
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

			if(wcaction == "rollmessage") then {
				wcaction = "";
				_ctrl = (uiNamespace getVariable 'wcspawndialog') displayCtrl 2005;
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
					 ((uiNamespace getVariable 'wcspawndialog') displayCtrl 2003)  ctrlSetPosition [ (_frame_pos select 0) + (_frame_pos select 2), (_frame_pos select 1), (0.6 * safezoneW), (_frame_pos select 3)];
				} else {
					((uiNamespace getVariable 'wcspawndialog') displayCtrl 2003)  ctrlSetPosition _standard_map_pos;
				};
				((uiNamespace getVariable 'wcspawndialog') displayCtrl 2003)  ctrlCommit 0.2;
			};

			if(wcchange) then {
				if(_player isequalto player) then {
					_ctrl = (uiNamespace getVariable 'wcspawndialog') displayCtrl 2003;
					_ctrl ctrlMapAnimAdd [2, 0, _body]; 
					ctrlMapAnimCommit _ctrl;					
					
					detach _cam;
					_cam cameraEffect ["internal","top"];
					_cam camsettarget _body;
					_cam camSetRelPos [0,100,300];
					_cam CamCommit 0;
				} else {
					_ctrl = (uiNamespace getVariable 'wcspawndialog') displayCtrl 2003;
					_ctrl ctrlMapAnimAdd [2, 0, _player]; 
					ctrlMapAnimCommit _ctrl;					

					detach _cam;
					if(vehicle _player == _player) then {
						_cam cameraEffect ["internal", "BACK"];
						_cam camSetTarget _player;
						_cam attachto [_player,[0.7,-3, + 0.5], "neck"];
						_cam CamCommit 0;
					} else {
						_cam cameraEffect ["internal", "BACK"];
						_cam camSetTarget (vehicle _player);	
						_variation = [-50, -30,-10, 10 ,30, 50];
						_cam attachto [(vehicle _player),[_variation call BIS_fnc_selectRandom,-50,+15], "neck"];
						_cam CamCommit 0;
					};
				};
				wcchange  = false;
			};

			sleep 0.01;
		};


	_playertype = "ammobox";
	_position = position _cam;
	_dir = getDir _cam;

	_cam cameraEffect ["terminate","back"];
	camDestroy _cam;

	if(_player == player) then {
		openMap [false, false] ;
		openMap [true, true];
		mapAnimAdd [1, 0.30, _body]; 
		mapAnimCommit;
		[] call WC_fnc_teleport;
	} else {
		if(_position distance getmarkerpos "respawn_west" < 1000) then {
			openMap [false, false] ;
			openMap [true, true];
			mapAnimAdd [1, 0.30, _body]; 
			mapAnimCommit;
			[] call WC_fnc_teleport;
		} else {
			if(vehicle _player == _player) then {
				player setpos [_position select 0, _position select 1];
				player setdir _dir;
			} else {
				if((vehicle _player) emptyPositions "cargo" == 0) then {
					_position = [position (vehicle _player), 5, random 359] call BIS_fnc_relPos;
					player setpos _position;
					player setdir (getdir (vehicle _player));
				} else {
					player moveInAny (vehicle _player);
				};
			};
		};
	};

	openMap [false, false];
	deletevehicle _body;