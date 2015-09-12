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

	private ["_cam", "_body", "_units", "_ctrl", "_list", "_player", "_condition", "_position", "_dir"];

	_body = _this select 0;

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
	sleep 1;
	
	_ctrl = (uiNamespace getVariable 'wcspawndialog') displayCtrl 4005;
	if(wcwithrollmessages) then {
		_ctrl ctrlSetText "ROLLMESSAGE ON";
	} else {
		_ctrl ctrlSetText "ROLLMESSAGE OFF";
	};

	_ctrl = (uiNamespace getVariable 'wcspawndialog') displayCtrl 4006;
	_ctrl ctrlMapAnimAdd [0, 0, _body]; 
	ctrlMapAnimCommit _ctrl;		
		
	// player must be the first elem of array
	_units = playableunits - [player];
	_units = [player] + _units;
	_player = player;
	
	_list = ["new", _units] call OO_CIRCULARLIST;
	_condition = { if(getDammage _this > 0.99) then { false; }else{ true; }; };

	wcchange  = false;

		while { wcaction != "deploy" && dialog} do {
			if(wcaction == "equipment") then {
				closeDialog 0;
				_title = localize "STR_EQUIPMENT_TITLE";
				_text = localize "STR_EQUIPMENT_TEXT";
				["hint", [_title, _text]] call hud;	
				["Open",[true,nil,player]] call bis_fnc_arsenal;
				sleep 5;
				while { !isnull (uinamespace getvariable "BIS_fnc_arsenal_cam") } do {
					sleep 0.01;
				};
				createDialog "spawndialog"; 
				if (needReload player == 1) then {reload player};
				["save", player] spawn inventory;
				wcaction = "";
				_player = player;
				wcchange = true;
			};

			if(wcaction == "rollmessage") then {
				wcaction = "";
				_ctrl = (uiNamespace getVariable 'wcspawndialog') displayCtrl 4005;
				wcwithrollmessages = !wcwithrollmessages;
				if(wcwithrollmessages) then {
					_ctrl ctrlSetText "ROLLMESSAGE ON";
				} else {
					_ctrl ctrlSetText "ROLLMESSAGE OFF";
				};
				_ctrl ctrlcommit 0;				
			};

			if(wcaction == "next") then {
				wcaction = "";
				_player = ["getNext", [_condition, player]] call _list;
				wcchange = true;
			};
			if(wcaction == "prev") then {
				wcaction = "";
				_player = ["getPrev", [_condition, player]] call _list;
				wcchange = true;
			};

			if(wcchange) then {
				if(_player isequalto player) then {
					_units = playableunits - [player];
					_units = [player] + _units;
					["set", _units] call _list;

					_ctrl = (uiNamespace getVariable 'wcspawndialog') displayCtrl 4004;
					_ctrl ctrlSetStructuredText parsetext "<t align='center' color='#FF9933'>MAP</t>";
					_ctrl ctrlcommit 0;

					_ctrl = (uiNamespace getVariable 'wcspawndialog') displayCtrl 4006;
					_ctrl ctrlMapAnimAdd [0, 0, _body]; 
					ctrlMapAnimCommit _ctrl;					
					
					detach _cam;
					_cam cameraEffect ["internal","top"];
					_cam camsettarget _body;
					_cam camSetRelPos [0,100,300];
					_cam CamCommit 0;
				} else {
					_ctrl = (uiNamespace getVariable 'wcspawndialog') displayCtrl 4004;
					_ctrl ctrlSetStructuredText parsetext ("<t align='center' color='#FF9933'>" + name _player+ "</t>");
					_ctrl ctrlcommit 0;

					_ctrl = (uiNamespace getVariable 'wcspawndialog') displayCtrl 4006;
					_ctrl ctrlMapAnimAdd [0, 0, _player]; 
					ctrlMapAnimCommit _ctrl;					

					detach _cam;
					if(vehicle _player == _player) then {
						_cam cameraEffect ["internal", "BACK"];
						_cam camSetTarget _player;
						_cam attachto [_player,[0.7,-2,0], "neck"];
						_cam CamCommit 0;
					} else {
						_cam cameraEffect ["internal", "BACK"];
						_cam camSetTarget (vehicle _player);
						_cam attachto [(vehicle _player),[0,-50,0], "neck"];
						_cam CamCommit 0;
					};
				};
				wcchange  = false;
			};
			sleep 0.01;
		};

	["delete", _list] call OO_CIRCULARLIST;	

	_position = position _cam;
	_dir = getDir _cam;

	_cam cameraEffect ["terminate","back"];
	camDestroy _cam;

	if(_player == player) then {
		openMap [false, false] ;
		openMap [true, true];
		mapAnimAdd [1, 0.04, _body]; 
		mapAnimCommit;
		[] call WC_fnc_teleport;
	} else {
		if(_position distance getmarkerpos "respawn_west" < 1000) then {
			openMap [false, false] ;
			openMap [true, true];
			mapAnimAdd [1, 0.04, _body]; 
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