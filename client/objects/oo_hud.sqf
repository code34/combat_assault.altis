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
		};

		PUBLIC FUNCTION("", "setPlayerTag") {
			MEMBER("playertag", true);
		};

		PUBLIC FUNCTION("", "bottomHud") {
			private ["_ctrl", "_ctrl2", "_ctrl3", "_ctrl4", "_ctrl5", "_ctrl6", "_text", "_weight", "_time", "_message"];

			disableSerialization;
			cutrsc ['bottomhud','PLAIN'];

			_time = 0;
			killzone = [];

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
				_text = format ["Weight: %1 %2", round (((loadAbs player)*0.1)/2.2), "Kg"];
				
				_ratio = mystats select 0;
				_globalratio = mystats select 1;
				_number = mystats select 2;

				_rank = MEMBER("getRankText", _ratio);
				_img = [_rank,"texture"] call BIS_fnc_rankParams;
				_text = _text + "<br/><img image='" + _img + "'/> " + format ["%1", _rank];

				_rank = MEMBER("getRankText", _globalratio);
				_text = _text + format ["<br/><t size='0.7'>Server Ranking: %1</t>", _rank];
				_text = _text + format ["<br/><t size='0.7'>Match: %1</t>", _number];
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
					_temp =  _temp  + _x;
				}foreach rollmessage;
				rollprintmessage = _temp;
				rollmessage deleteat 0;
				sleep 1;
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


		PUBLIC FUNCTION("scalar", "getRankText") {
			private ["_ratio","_rank"];
			
			_ratio = _this;

			switch (true) do {
				case (_ratio < 2) : {
					_rank = "PRIVATE";
				};

				case (_ratio > 1.99 and _ratio < 4) : {
					_rank = "CORPORAL";
				};

				case (_ratio > 3.99 and _ratio < 6) : {
					_rank = "SERGEANT";
				};

				case (_ratio > 5.99 and _ratio < 8) : {
					_rank = "LIEUTENANT";
				};

				case (_ratio > 7.99 and _ratio < 10) : {
					_rank = "CAPTAIN";
				};

				case (_ratio > 9.99 and _ratio < 12) : {
					_rank = "MAJOR";
				};				

				case (_ratio > 11.99) : {
					_rank = "COLONEL" ;
				};		

				default {
					_rank = "PRIVATE";
				};
			};
			_rank;
		};

		PUBLIC FUNCTION("", "drawPlayerTag") {
			private ["_code", "_vehicle"];
			
			_code = "
					if(vehicle player == player) then {
						{	_vehicle = _x;
							_distance = (player distance _vehicle) / 15;
							_color = getArray (configFile/'CfgInGameUI'/'SideColors'/'colorFriendly');
							_color set [3, 1 - _distance];
							 drawIcon3D ['', _color, [ visiblePosition _vehicle select 0, visiblePosition _vehicle select 1, (visiblePosition _vehicle select 2) + 1.9 ], 0, 0, 0, name _vehicle, 2, 0.03, 'PuristaMedium' ];
						}foreach playableunits - [player];
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
			DELETE_VARIABLE("playertag", nil);
		};
	ENDCLASS;