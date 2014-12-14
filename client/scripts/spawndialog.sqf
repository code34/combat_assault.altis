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

	private ["_units", "_ctrl"];

	disableSerialization;

	wcaction = "";

	createDialog "spawndialog"; 
		
	_units = playableunits - [player];
	wcindex = -1;
	wcindexmax = count _units;
	wcchange  = false;

		while { wcaction != "deploy" && dialog} do {
			if(wcaction == "equipment") then {
				closeDialog 0;
				_title = "Select your equipment";
				_text = "Take magazines as items of your vest or bag and go ahead to teleport on zone!";
				["hint", [_title, _text]] call hud;	
				["Open",[true,nil,player]] call bis_fnc_arsenal;
				sleep 5;
				while { !isnull (uinamespace getvariable "BIS_fnc_arsenal_cam") } do {
					sleep 0.1;
				};
				["save", player] call inventory;
				createDialog "spawndialog"; 
				wcaction = "";
				wcindex = -1;
				wcchange = true;
			};

			if(wcaction == "next") then {
				wcaction = "";
				wcindex = wcindex + 1;
				wcchange = true;
			};
			if(wcaction == "prev") then {
				wcaction = "";
				wcindex = wcindex - 1;
				wcchange = true;
			};
			if(wcchange) then {
				if(wcindex == wcindexmax) then {
					_units = playableunits - [player];
					wcindex = -1;
					wcindexmax = count _units;
				};
				if(wcindex < -1) then {
					_units = playableunits - [player];
					wcindex = (count _units) - 1;
				};
				if(wcindex < 0) then {
					_ctrl = (uiNamespace getVariable 'wcspawndialog') displayCtrl 4004;
					_ctrl ctrlSetStructuredText parsetext "<t align='center'>MAP</t>";
					_ctrl ctrlcommit 0;
					
					detach cam;
					cam cameraEffect ["internal","top"];
					cam camsettarget _body;
					cam camSetRelPos [0,0,300];
					cam CamCommit 0;
				} else {
					_ctrl = (uiNamespace getVariable 'wcspawndialog') displayCtrl 4004;
					_ctrl ctrlSetStructuredText parsetext ("<t align='center' color='#FF9933'>" + name (_units select wcindex) + "</t>");
					_ctrl ctrlcommit 0;

					detach cam;
					cam cameraEffect ["internal", "BACK"];
					cam camSetTarget (_units select wcindex);
					cam attachto [(_units select wcindex),[0.7,-2,0], "neck"];
					cam CamCommit 0;
				};
				wcchange  = false;
			};
			sleep 0.1;
		};