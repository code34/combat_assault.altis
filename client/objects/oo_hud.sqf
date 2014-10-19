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
			private ["_ctrl", "_text", "_weight"];
			disableSerialization;
			cutrsc ['bottomhud','PLAIN'];
			while { true} do {
				if(isnull (uiNamespace getVariable "wcdisplay")) then { cutrsc ['bottomhud','PLAIN'];};
				_ctrl =(uiNamespace getVariable "wcdisplay") displayCtrl -1;
				_text = format ["Stamina: %1", (100 - round(getfatigue player * 100))];
				_text = _text + "<br/>" + format ["Health: %1", (100 - round(getDammage player * 100))];
				_text = _text + "<br/>" + format ["Azimut: %1", round(getdir player)];
				if (systemOfUnits != 2) then {
					_weight = format ["%1 %2", round (((loadAbs player)*0.1)/2.2), "Kg"];
				} else {
					_weight = format ["%1 %2", round ((loadabs player)*0.1), "lb."];
				}; 
				_text = _text + "<br/>" + format ["Weight: %1", _weight];
				_text = _text + "<br/>" + format ["Stats: %1", mystats];
				_ctrl ctrlSetStructuredText parseText _text;
				_ctrl ctrlcommit 0;
				sleep 1;			
			};
		};

		PUBLIC FUNCTION("", "drawPlayerTag") {
			private ["_code", "_vehicle"];
			
			_code = "
					{	_vehicle = _x;
						_distance = (player distance _vehicle) / 15;
						_color = getArray (configFile/'CfgInGameUI'/'SideColors'/'colorFriendly');
						_color set [3, 1 - _distance];
						 drawIcon3D ['', _color, [ visiblePosition _vehicle select 0, visiblePosition _vehicle select 1, (visiblePosition _vehicle select 2) + 1.9 ], 0, 0, 0, name _vehicle, 2, 0.03, 'PuristaMedium' ];
					}foreach playableunits - [player];
			";
			_code;
		};

		PUBLIC FUNCTION("array", "hint") {
			_title = _this select 0;
			_text = _this select 1;

			_title=  "<t color='#ff0000'>"+ _title + "</t><br />";
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