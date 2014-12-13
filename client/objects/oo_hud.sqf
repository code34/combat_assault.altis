	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014 Nicolas BOITEUX

	CLASS OO_HUD
	
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

	#include "oop.h"

	CLASS("OO_HUD")
		PRIVATE VARIABLE("bool","playertag");

		PUBLIC FUNCTION("array","constructor") {
			MEMBER("playertag", true);
			cutrsc ['bottomhud','PLAIN'];
		};

		PUBLIC FUNCTION("", "setPlayerTag") {
			MEMBER("playertag", true);
		};

		PUBLIC FUNCTION("", "scoreboardHud") {
			private ["_ctrl8", "_ctrl9", "_ctrl10", "_ctrl11", "_ctrl12", "_ctrl13", "_ctrl14","_ctrl15"];
			disableSerialization;
			
			while { true} do {
				if((!alive player) or wcboard) then {
					_ctrl8 =(uiNamespace getVariable "wcdisplay") displayCtrl 1007;
					_ctrl8 ctrlSetBackgroundColor [0,0.4,0.8,0.4];

					_scores = "topByScore" call scoreboard;
					_ctrl9 =(uiNamespace getVariable "wcdisplay") displayCtrl 1008;
					_ctrl9 ctrlSetStructuredText parsetext ("Scoreboard - Ticket: " + str(wcticket) + " <t size='0.7'>Press [Tab] to hide</t>");
					_ctrl9 ctrlSetBackgroundColor [0,0.4,0.8,0.6];

					_ctrl10 =(uiNamespace getVariable "wcdisplay") displayCtrl 1009;
					_ctrl10 ctrlSetStructuredText parsetext (_scores select 0);

					_ctrl11 =(uiNamespace getVariable "wcdisplay") displayCtrl 1010;
					_ctrl11 ctrlSetStructuredText parsetext (_scores select 1);

					_ctrl12 =(uiNamespace getVariable "wcdisplay") displayCtrl 1011;
					_ctrl12 ctrlSetStructuredText parsetext (_scores select 2);

					_ctrl13 =(uiNamespace getVariable "wcdisplay") displayCtrl 1012;
					_ctrl13 ctrlSetStructuredText parsetext (_scores select 3);

					_ctrl14 =(uiNamespace getVariable "wcdisplay") displayCtrl 1013;
					_ctrl14 ctrlSetStructuredText parsetext (_scores select 4);

					_ctrl15 =(uiNamespace getVariable "wcdisplay") displayCtrl 1014;
					_ctrl15 ctrlSetStructuredText parsetext (_scores select 5);					
				} else {
					_ctrl8 =(uiNamespace getVariable "wcdisplay") displayCtrl 1007;
					_ctrl8 ctrlSetBackgroundColor [0,0.4,0.8,0];

					_ctrl9 =(uiNamespace getVariable "wcdisplay") displayCtrl 1008;
					_ctrl9 ctrlSetStructuredText parsetext "";
					_ctrl9 ctrlSetBackgroundColor [0,0.4,0.8,0];

					_ctrl10 =(uiNamespace getVariable "wcdisplay") displayCtrl 1009;
					_ctrl10 ctrlSetStructuredText parsetext "";

					_ctrl11 =(uiNamespace getVariable "wcdisplay") displayCtrl 1010;
					_ctrl11 ctrlSetStructuredText parsetext "";

					_ctrl12 =(uiNamespace getVariable "wcdisplay") displayCtrl 1011;
					_ctrl12 ctrlSetStructuredText parsetext "";

					_ctrl13 =(uiNamespace getVariable "wcdisplay") displayCtrl 1012;
					_ctrl13 ctrlSetStructuredText parsetext "";

					_ctrl14 =(uiNamespace getVariable "wcdisplay") displayCtrl 1013;
					_ctrl14 ctrlSetStructuredText parsetext "";

					_ctrl15 =(uiNamespace getVariable "wcdisplay") displayCtrl 1014;
					_ctrl15 ctrlSetStructuredText parsetext "";					
				};
				_ctrl8 ctrlcommit 0;
				_ctrl9 ctrlcommit 0;
				_ctrl10 ctrlcommit 0;
				_ctrl11 ctrlcommit 0;
				_ctrl12 ctrlcommit 0;
				_ctrl13 ctrlcommit 0;
				_ctrl14 ctrlcommit 0;
				_ctrl15 ctrlcommit 0;
				sleep 0.1;
			};
		};

		PUBLIC FUNCTION("", "bottomHud") {
			private ["_ctrl", "_ctrl2", "_ctrl3", "_ctrl4", "_ctrl5", "_ctrl6", "_ctrl7", "_text", "_weight", "_time", "_message", "_scores"];

			_time = 0;
			killzone = [];
			disableSerialization;

			while { true} do {
				if(isnull (uiNamespace getVariable "wcdisplay")) then { cutrsc ['bottomhud','PLAIN'];};

				_ctrl =(uiNamespace getVariable "wcdisplay") displayCtrl 1001;
				_text = "<t align='center'>"+format ["%1", (100 - round(getDammage player * 100))] + "</t>";
				_ctrl ctrlSetStructuredText parseText _text;

				_ctrl2 =(uiNamespace getVariable "wcdisplay") displayCtrl 1002;
				_text = "<t align='center'>"+ format ["%1", (100 - round(getfatigue player * 100))] + "</t>";
				_ctrl2 ctrlSetStructuredText parseText _text;

				_ctrl3 =(uiNamespace getVariable "wcdisplay") displayCtrl 1003;
				_text = "<t align='center'>"+format ["%1", round(getdir player)] + "</t>";
				_ctrl3 ctrlSetStructuredText parseText _text;
		
				_ctrl4 =(uiNamespace getVariable "wcdisplay") displayCtrl 1004;
				
				_score = ["getPlayerScore", name player] call scoreboard;
				_ratio = _score select 0;
				_globalratio = _score select 1;
				_number = _score select 2;

				_rank = ["getRankText", _ratio] call scoreboard;
				_img = [_rank,"texture"] call BIS_fnc_rankParams;
				//_text = "<t color='#66FFFF'><img image='" + _img + "'/> " + format ["%1</t>", _rank];
				_text = "<img image='" + _img + "'/> " + format ["%1", _rank];

				_rank = ["getRankText", _globalratio] call scoreboard;
				//_text = _text + format ["<br/><t color='#66FFFF'><t size='0.7'>Server Ranking: %1</t></t>", _rank];
				_text = _text + format ["<br/><t size='0.7'>Server Ranking: %1</t>", _rank];
				//_text = _text + format ["<br/><t color='#66FFFF'><t size='0.7'>Match: %1</t></t>", _number];
				_text = _text + format ["<br/><t size='0.7'>Match: %1</t>", _number];
				//_text = _text + format ["<br/><t color='#66FFFF'><t size='0.7'>Weight: %1 %2</t></t>", round (((loadAbs player)*0.1)/2.2), "Kg"];
				_text = _text + format ["<br/><t size='0.7'>Weight: %1 %2</t>", round (((loadAbs player)*0.1)/2.2), "Kg"];
				_ctrl4 ctrlSetStructuredText parseText _text;

				if(vehicle player != player) then {
					_ctrl5 =(uiNamespace getVariable "wcdisplay") displayCtrl 1000;
					_text = MEMBER("getCrewText", nil);
					_ctrl5 ctrlSetStructuredText parseText _text;
					_ctrl5 ctrlSetBackgroundColor [0, 0, 0, 0.4];
				
				} else {
					_ctrl5 =(uiNamespace getVariable "wcdisplay") displayCtrl 1000;
					_ctrl5 ctrlSetStructuredText parseText "";
					_ctrl5 ctrlSetBackgroundColor [0, 0, 0, 0];
				};

				_ctrl6 =(uiNamespace getVariable "wcdisplay") displayCtrl 999;
				if(count killzone > 0) then {
					if(_time > 5) then {
						_time = 0;
						killzone set [0, -1];
						killzone = killzone - [-1];
						_ctrl6 ctrlSetStructuredText parseText "";
						_ctrl6 ctrlSetBackgroundColor [0, 0, 0, 0];
					} else {
						_message = killzone select 0;
						_ctrl6 ctrlSetStructuredText parseText _message;
						_ctrl6 ctrlSetBackgroundColor [0, 0, 0, 0.4];
					};
					_time = _time  + 1;
				};

				_ctrl7 =(uiNamespace getVariable "wcdisplay") displayCtrl 1005;
				_ctrl7 ctrlSetStructuredText parsetext rollprintmessage;
				if(rollprintmessage == "") then {
					_ctrl7 ctrlSetBackgroundColor [0, 0, 0, 0];
				} else {
					_ctrl7 ctrlSetBackgroundColor [0, 0, 0, 0.3];
				};

				_ctrl ctrlcommit 0;
				_ctrl2 ctrlcommit 0;
				_ctrl3 ctrlcommit 0;
				_ctrl4 ctrlcommit 0;
				_ctrl5 ctrlcommit 0;
				_ctrl6 ctrlcommit 0;
				_ctrl7 ctrlcommit 0;
				sleep 1;			
			};
		};

		PUBLIC FUNCTION("", "rollMessage") {
			private ["_temp"];

			while { true } do {
				_temp = "";
				{
					sleep 0.001;
					_temp =  _temp  + "<t shadow='1' size='1.2' >" + _x + "</t>";
				}foreach rollmessage;
				rollprintmessage = _temp;
				rollmessage deleteat 0;
				sleep 1.5;
			};
		};

		PUBLIC FUNCTION("", "getCrewText") {
			private ["_name", "_text"];
			_text = "";
			_name= getText (configFile >> "CfgVehicles" >> (typeOf vehicle player) >> "DisplayName");
			_name= format ["<t shadow='true' color='#AAAAFF'>%1</t><br/>", _name];
			{
				_text = "<t color='#99CC00'>+ "+ name _x +"</t><br/>"+_text;
				sleep 0.01;
			}foreach crew (vehicle player);
			_text = _name + _text;
			_text;
		};

		PUBLIC FUNCTION("", "drawPlayerTag") {	
			_code = "
					private ['_code', '_vehicle', '_rank', '_img', '_color'];
					if(vehicle player == player) then {
						{	
							if(_x distance player < 16) then {
								_vehicle = _x;
								_rank = rank _vehicle;
								_img = [_rank, 'texture'] call BIS_fnc_rankParams;
								_distance = (player distance _vehicle) / 15;
								if(side _vehicle == west) then {
									_color = getArray (configFile/'CfgInGameUI'/'SideColors'/'colorFriendly');
								} else {
									_color = getArray (configFile/'CfgInGameUI'/'SideColors'/'colorEnemy');
								};
								_color set [3, 1 - _distance];
								 drawIcon3D [_img, _color, [ visiblePosition _vehicle select 0, visiblePosition _vehicle select 1, (visiblePosition _vehicle select 2) + 1.9 ], 1, 1, 0, name _vehicle, 2, 0.03, 'PuristaMedium' ];
							 };
						}foreach playableUnits;
					};
			";
			_code;
		};

		PUBLIC FUNCTION("array", "hint") {
			_title = _this select 0;
			_text = _this select 1;

			_title=  "<t size='2.2' color='#ff0000'>"+ _title + "</t><br />";
			hintsilent parseText (_title + _text); 			
		};

		PUBLIC FUNCTION("array", "hintScore") {
			_ticket = _this select 0;
			_type = _this select 1;
			_credit = _this select 2;

			_title = str(_ticket);
			_text = format["%2 ticket(s) for %1", _type, _credit];

			waituntil { alive player};
			_title=  "<t size='2.2' color='#ff0000'>"+ _title + "</t><br />";
			hintsilent parseText (_title + _text); 			
		};		

		PUBLIC FUNCTION("", "drawAll") {
			private ["_code"];
			_code = "";
			if(MEMBER("playertag", nil)) then {
				_code = _code + MEMBER("drawPlayerTag", nil);
			};
			call compile format["addMissionEventHandler ['Draw3D', {%1}];", _code];
		};

		PUBLIC FUNCTION("","deconstructor") { 
			DELETE_VARIABLE("playertag");
		};
	ENDCLASS;