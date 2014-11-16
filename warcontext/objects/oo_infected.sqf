	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014 Nicolas BOITEUX

	CLASS OO_INFECTED
	
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

	CLASS("OO_INFECTED")
		PRIVATE VARIABLE("object","zombie");
		PRIVATE VARIABLE("object","target");

		PUBLIC FUNCTION("object","constructor") {
			MEMBER("zombie", _this);
			MEMBER("setInventory", _this);

			//_this disableAI "FSM";
			_this disableAI "AUTOTARGET";
			_this disableAI "TARGET";
			_this enableFatigue false;
			_this disableConversation true;
		};

		PUBLIC FUNCTION("object","setInventory") {
			removeallweapons _this;
			removeAllAssignedItems _this;
			removeBackpack _this;
			//removeGoggles _this;
			//removeHeadgear _this;
		};

		PUBLIC FUNCTION("", "monitor") {
			private ["_zombie", "_targets"];

			_zombie = MEMBER("zombie", nil);

			// wait around init
			sleep 5;

			while { alive _zombie} do {
				_targets = MEMBER("scanTarget", nil);
				if(count _targets > 0) then {
					MEMBER("defineTarget", _targets);
					MEMBER("killTarget", nil);
					MEMBER("eat", nil);
				};
				sleep 1;
			};
			sleep 60;
			MEMBER("deconstructor", nil);
		};

		PUBLIC FUNCTION("", "scanTarget") {
			private ["_list", "_targets", "_zombie"];
			_targets = [];
			_zombie = MEMBER("zombie", nil);
			_list = nearestObjects [_zombie, ["MAN"], 500];
			{
				if(side _x in [west, east]) then {
					_targets = _targets + [_x];
				};
			}foreach _list;
			_targets;
		};

		PUBLIC FUNCTION("array", "defineTarget") {
			private ["_min", "_targets", "_target", "_temp"];
			_targets = _this;
			_min = -1;
			{
				_temp = MEMBER("zombie", nil) knowsAbout _x;
				if(_temp > _min) then {
					_min = _temp;
					_target = _x;
				};
			}foreach _targets;
			MEMBER("target", _target);
		};

		PUBLIC FUNCTION("", "killTarget") {
			private ["_run", "_target", "_zombie"];
			
			_run = true;
			_target =MEMBER("target", nil);
			_zombie = MEMBER("zombie", nil);
			(group _zombie) setSpeedMode "FULL";
			(group _zombie) setCombatMode "BLUE";
			(group _zombie) setBehaviour "CARELESS";

			_zombie addEventHandler ['HandleDamage', {
				private ["_damage"];
				_damage = damage(_this select 0);
				if(_this select 1 == "head") then {
					if((_this select 2) > 1) then {
						(_this select 0) setdammage 1;
					};
				} else {
					if((_this select 2) < 2) then {
						false;
					};
				};
			}];

			while { _run } do {
				if(!alive _target) then { _run = false;};
				if(!alive _zombie) then { _run = false;};
				MEMBER("moveTo", nil);
				if(_zombie distance _target < 2) then {
					MEMBER("attack", nil);
				};
				if(_zombie distance _target > 200) then {
					_run = false;
				};
				sleep 1;
			};
		};

		PUBLIC FUNCTION("", "moveTo") {
			MEMBER("zombie", nil) domove getposatl MEMBER("target", nil);
		};

		PUBLIC FUNCTION("", "attack") {
			MEMBER("zombie", nil) dowatch MEMBER("target", nil);
			MEMBER("zombie", nil) switchMove "AwopPercMstpSgthWnonDnon_end";
			MEMBER("zombie", nil) say format["zomb%1", round random (6)];
			_damage = getdammage MEMBER("target", nil);
			MEMBER("target", nil) setdammage ( _damage+ random 1);
		};			

		PUBLIC FUNCTION("", "eat") {
			MEMBER("zombie", nil) dowatch MEMBER("target", nil);
			MEMBER("zombie", nil) switchMove "AmovPercMstpSnonWnonDnon_Scared";
			sleep 0.5;
		};

		PUBLIC FUNCTION("","deconstructor") { 
			deletevehicle MEMBER("zombie", nil);
			DELETE_VARIABLE("zombie");
			DELETE_VARIABLE("run");
		};
	ENDCLASS;