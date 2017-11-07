	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014-2018 Nicolas BOITEUX

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
			DEBUG(#, "OO_HUD::constructor")
			MEMBER("playertag", true);
			cutrsc ['bottomhud','PLAIN'];
		};

		PUBLIC FUNCTION("bool", "setPlayerTag") {
			DEBUG(#, "OO_HUD::setPlayerTag")
			MEMBER("playertag", _this);
		};

		PUBLIC FUNCTION("", "scoreboardHud") {
			DEBUG(#, "OO_HUD::scoreboardHud")
			private ["_ctrl8", "_ctrl9", "_ctrl10", "_ctrl11", "_ctrl12", "_ctrl13", "_ctrl14","_ctrl15", "_ctrl16"];
			disableSerialization;
			private _count = 0;
			while { true} do {
				if((!alive player) or wcboard) then {
						_ctrl8 =(uiNamespace getVariable "wcdisplay") displayCtrl 1007;
						_ctrl8 ctrlSetBackgroundColor [0,0.4,0.8,0.4];
						_scores = "topByScore" call scoreboard;
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
						_ctrl16 =(uiNamespace getVariable "wcdisplay") displayCtrl 1016;
						_ctrl16 ctrlSetStructuredText parsetext ("<t align='center'>Tickets: "+ str(wcticket) + "</t>");
						_ctrl16 ctrlSetBackgroundColor [0,0.4,0.8,0.6];
						_count = _count + 1;
						if(_count > 10) then { wcboard = false; _count = 0;};
					} else {
						_ctrl8 =(uiNamespace getVariable "wcdisplay") displayCtrl 1007;
						_ctrl8 ctrlSetBackgroundColor [0,0.4,0.8,0];
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
						_ctrl16 =(uiNamespace getVariable "wcdisplay") displayCtrl 1016;
						_ctrl16 ctrlSetStructuredText parsetext "";		
						_ctrl16 ctrlSetBackgroundColor [0,0.4,0.8,0];								
					};
				{ _x ctrlCommit 0; true; } count  [_ctrl8, _ctrl10, _ctrl11, _ctrl12, _ctrl13, _ctrl14, _ctrl15, _ctrl16];
				sleep 0.1;
			};
		};

		PUBLIC FUNCTION("", "getCompass") {
			DEBUG(#, "OO_HUD::getCompass")
			disableSerialization;
			private _ctrl = "";
			private _dir = 0;
			private _text = "";
			while { true} do {
				if(isnull (uiNamespace getVariable "wcdisplay")) then { cutrsc ['bottomhud','PLAIN'];};
				_ctrl =(uiNamespace getVariable "wcdisplay") displayCtrl 1003;
				_dir = getdir player;
				if((_dir > 340) or (_dir < 20)) then {_direction = "N"};
				if((_dir > 19) or (_dir < 70)) then {_direction = "NE"};
				if((_dir > 69) or (_dir < 110)) then {_direction = "E"};
				if((_dir > 109) or (_dir < 160)) then {_direction = "SE"};
				if((_dir > 159) or (_dir < 210)) then {_direction = "S"};
				if((_dir > 209) or (_dir < 250)) then {_direction = "SW"};
				if((_dir > 249) or (_dir < 290)) then {_direction = "W"};
				if((_dir > 289) or (_dir < 340)) then {_direction = "NW"};
				_text = "<t align='center'>"+format ["%1", _direction] + "</t>";
				_ctrl ctrlSetStructuredText parseText _text;
				_ctrl ctrlcommit 0;
				sleep 0.1;
			};
		};

		PUBLIC FUNCTION("", "bottomHud") {
			DEBUG(#, "OO_HUD::bottomHud")
			disableSerialization;
			private ["_ctrl", "_ctrl2", "_ctrl4", "_ctrl5", "_ctrl6", "_ctrl7", "_ctrl8", "_ctrl9", "_ctrl10" , "_ctrl11", "_text", "_weight", "_time", "_message", "_scores", "_sector", "_dir", "_direction"];
			_time = 0;
			while { true} do {
				if(isnull (uiNamespace getVariable "wcdisplay")) then { cutrsc ['bottomhud','PLAIN'];};
				_ctrl =(uiNamespace getVariable "wcdisplay") displayCtrl 1001;
				_text = "<t align='center'>"+format ["%1", (100 - round(getDammage player * 100))] + "</t>";
				_ctrl ctrlSetStructuredText parseText _text;
				_ctrl2 =(uiNamespace getVariable "wcdisplay") displayCtrl 1002;
				_text = "<t align='center'>"+ format ["%1", (100 - round(getfatigue player * 100))] + "</t>";
				_ctrl2 ctrlSetStructuredText parseText _text;
				_ctrl4 =(uiNamespace getVariable "wcdisplay") displayCtrl 1004;	
				_score = ["getPlayerScore", name player] call scoreboard;
				_ratio = _score select 0;
				_globalratio = _score select 1;
				_number = _score select 2;
				_rank = ["getRankText", _ratio] call scoreboard;
				_img = [_rank,"texture"] call BIS_fnc_rankParams;
				_text = "<t size='2'><img image='" + _img + "'/></t><t size='2.5'>" + format ["%1</t>", _rank];
				_rank = ["getRankText", _globalratio] call scoreboard;
				_text = _text + format ["<br/><t size='1'>Server Ranking: %1</t>", _rank];
				if(wccandeploy) then {
					_text = _text + "<br/><t size='1'>Situation : Safe</t>";
				} else {
					_text = _text + "<br/><t size='1'>Situation : Unsafe</t>";
				};
				_text = _text + format ["<br/><t size='1'>%1</t>", wcbannerserver];
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
					if(_time > 2) then {
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
				if(wcwithrollmessages) then {
					_ctrl7 ctrlSetStructuredText parsetext rollprintmessage;
					if(rollprintmessage == "") then {
						_ctrl7 ctrlSetBackgroundColor [0, 0, 0, 0];
					} else {
						_ctrl7 ctrlSetBackgroundColor [0, 0, 0, 0];
					};
				} else {
					_ctrl7 ctrlSetStructuredText parsetext "";
					_ctrl7 ctrlSetBackgroundColor [0, 0, 0, 0];
				};
				_direction = format["%1°", round(getdir player)];
				if(vehicle player isEqualTo player) then {
					_ctrl8 =(uiNamespace getVariable "wcdisplay") displayCtrl 1017;
					_sector = ["getSectorFromPos", position player] call client_grid;
					_ctrl8 ctrlSetStructuredText parsetext format ["<t shadow='1' size='0.9' >SECTOR %1%2 - %3", _sector select 0, _sector select 1, _direction];
					_ctrl8 ctrlSetBackgroundColor [0,0,0,0.5];	
				} else {
					_ctrl8 =(uiNamespace getVariable "wcdisplay") displayCtrl 1017;
					_ctrl8 ctrlSetStructuredText parsetext "";		
					_ctrl8 ctrlSetBackgroundColor [0,0,0,0];	
				};
				_ctrl9 =(uiNamespace getVariable "wcdisplay") displayCtrl 1018;
				_ctrl9 ctrlSetStructuredText parsetext format ["<t align='center'>%1</t>", playerkill];
				_ctrl10 =(uiNamespace getVariable "wcdisplay") displayCtrl 1019;
				_ctrl10 ctrlSetStructuredText parsetext format ["<t align='center'>%1</t>", playerdeath];
				_ctrl11 =(uiNamespace getVariable "wcdisplay") displayCtrl 1020;
				{ _x ctrlCommit 0; true; } count  [_ctrl, _ctrl2, _ctrl4, _ctrl5, _ctrl6, _ctrl7, _ctrl8, _ctrl9, _ctrl10, _ctrl11];
				sleep 1;			
			};
		};

		PUBLIC FUNCTION("", "rollMessage") {
			DEBUG(#, "OO_HUD::rollMessage")
			private _temp = "";
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
			DEBUG(#, "OO_HUD::getCrewText")
			private _text = "";
			private _name= getText (configFile >> "CfgVehicles" >> (typeOf vehicle player) >> "DisplayName");
			_name= format ["<t shadow='true' color='#AAAAFF'>%1</t><br/>", _name];
			{
				_text = "<t color='#99CC00'>+ "+ name _x +"</t><br/>"+_text;
				sleep 0.01;
			}foreach crew (vehicle player);
			_text = _name + _text;
			_text;
		};

		PUBLIC FUNCTION("", "drawPlayerTag") {
			DEBUG(#, "OO_HUD::drawPlayerTag")
			private _code = "
					private ['_code', '_vehicle', '_rank', '_img', '_color'];
					if(wcwithunitstags) then {
						if(vehicle player == player) then {
							{	
								if(_x distance player < 30) then {
									_vehicle = _x;
									_rank = rank _vehicle;
									_img = [_rank, 'texture'] call BIS_fnc_rankParams;
									_distance = (player distance _vehicle) / 30;
									if((side _vehicle == west) and !(_vehicle in wcblacklist)) then {
										_color = getArray (configFile/'CfgInGameUI'/'SideColors'/'colorFriendly');
										_color set [3, 1 - _distance];
										drawIcon3D [_img, _color, [ getPosATLVisual _vehicle select 0, getPosATLVisual _vehicle select 1, (getPosATLVisual _vehicle select 2) + 1.9 ], 1, 1, 0, name _vehicle, 2, 0.03, 'PuristaSemiBold' ];
									} else {
										_color = getArray (configFile/'CfgInGameUI'/'SideColors'/'colorEnemy');
										_color set [3, 1 - _distance];
										drawIcon3D [_img, _color, [ getPosATLVisual _vehicle select 0, getPosATLVisual _vehicle select 1, (getPosATLVisual _vehicle select 2) + 1.9 ], 1, 1, 0, name _vehicle, 2, 0.03, 'PuristaSemiBold' ];
									};
								 };
							}foreach allunits;
						};
					};
			";
			_code;
		};

		PUBLIC FUNCTION("array", "hint") {
			DEBUG(#, "OO_HUD::hint")
			private _title = _this select 0;
			private _text = _this select 1;
			_title=  "<t size='2.2' color='#ff0000'>"+ _title + "</t><br />";
			hintsilent parseText (_title + _text); 			
		};

		PUBLIC FUNCTION("array", "hintScore") {
			DEBUG(#, "OO_HUD::hintScore")
			private _title = str(_this select 0);
			private _type = _this select 1;
			private _credit = _this select 2;
			private _text = format["%2 ticket(s) for %1", _type, _credit];
			_message = "<t color='#ff0000'>"+ _title + "</t> "+_text+"<br />";
			rollmessage pushBack _message;
		};		

		PUBLIC FUNCTION("", "drawAll") {
			DEBUG(#, "OO_HUD::drawAll")
			private _code = "";
			if(MEMBER("playertag", nil)) then { _code = _code + MEMBER("drawPlayerTag", nil); };
			call compile format["addMissionEventHandler ['Draw3D', {%1}];", _code];
		};

		PUBLIC FUNCTION("","deconstructor") { 
			DEBUG(#, "OO_HUD::deconstructor")
			DELETE_VARIABLE("playertag");
		};
	ENDCLASS;