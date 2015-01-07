	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2013 Nicolas BOITEUX

	CLASS OO_INVENTORY simple save/restory inventory class
	
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

	CLASS("OO_INVENTORY")
		PRIVATE VARIABLE("array","inventory");

		PUBLIC FUNCTION("array","constructor") { 
			MEMBER("inventory", _this);
		};

		PUBLIC FUNCTION("object","clear") {
			removeallweapons _this;
			removeGoggles _this;
			removeHeadgear _this;
			removeVest _this;
			removeUniform _this;
			removeAllAssignedItems _this;
			removeBackpack _this;
		};

		PUBLIC FUNCTION("","getInventory") FUNC_GETVAR("inventory");
		
		PUBLIC FUNCTION("array","setInventory") {
			MEMBER("inventory", _this);
		};

		PUBLIC FUNCTION("object","save") {
			private ["_DB", "_result", "_array"];

			_array = [
				(headgear _this), 
				(goggles _this), 
				(uniform _this), 
				(UniformItems _this), 
				(vest _this), 
				(VestItems _this), 
				(backpack _this), 
				(backpackItems _this), 
				(primaryWeapon _this), 
				(primaryWeaponItems _this),
				(primaryWeaponMagazine _this),
				(secondaryWeapon _this),
				(secondaryWeaponItems _this),
				(secondaryWeaponMagazine _this),
				(handgunWeapon _this),
				(handgunItems _this),
				(handgunMagazine _this),
				(assignedItems _this)
			];
			MEMBER("inventory", _array);
		};

		PUBLIC FUNCTION("object","load") {
			private ["_temp", "_array", "_headgear", "_goggles", "_uniform", "_uniformitems", "_vest", "_vestitems", "_backpack", "_backpackitems", "_primaryweapon", "_primaryweaponitems", "_primaryweaponmagazine", "_secondaryweapon", "_secondaryweaponitems", "_secondaryweaponmagazine", "_handgun", "_handgunweaponitems", "_handgunweaponmagazine", "_assigneditems", "_position", "_damage", "_dir"];

			_array = MEMBER("inventory", nil);
			if(count _array == 0) exitwith {false;};
			
			MEMBER("clear", _this);

			_headgear = _array select 0;
			_goggles = _array select 1;
			_uniform = _array select 2;
			_uniformitems = _array select 3;
			_vest = _array select 4;
			_vestitems = _array select 5;
			_backpack = _array select 6;
			_backpackitems = _array select 7;
			_primaryweapon = _array select 8;
			_primaryweaponitems = _array select 9;
			_primaryweaponmagazine = _array select 10;
			_secondaryweapon = _array select 11;
			_secondaryweaponitems = _array select 12;
			_secondaryweaponmagazine = _array select 13;
			_handgunweapon = _array select 14;
			_handgunweaponitems = _array select 15;
			_handgunweaponmagazine = _array select 16;
			_assigneditems = _array select 17;

			_this addHeadgear _headgear;
			_this forceAddUniform _uniform;
			_this addGoggles _goggles;
			_this addVest _vest;


			{
				if(_x != "") then {
					_this addItemToUniform _x;
				};
			}foreach _uniformitems;
	
			{
				if(_x != "") then {
					_this addItemToVest _x;
				};
			}foreach _vestitems;
	
			if(format["%1", _backpack] != "") then {
				_this addbackpack _backpack;
				{
					if(_x != "") then {
						_this addItemToBackpack _x;
					};
				} foreach _backpackitems;
			};
	
			{
				if(_x != "") then {
					_this addMagazine _x;
				};
			} foreach _primaryweaponmagazine;

			//must be after assign items to secure loading mags
			_this addweapon _primaryweapon;
	
			{
				if(_x != "") then {
					_this addPrimaryWeaponItem _x;
				};
			} foreach _primaryweaponitems;
	
			{
				if(_x != "") then {
					_this addMagazine _x;
				};
			} foreach _secondaryweaponmagazine;

			_this addweapon _secondaryweapon;
	
			{
				if(_x != "") then {
					_this addSecondaryWeaponItem _x;
				};
			} foreach _secondaryweaponitems;
	
	
			{
				if(_x != "") then {
					_this addMagazine _x;
				};
			} foreach _handgunweaponmagazine;

			_this addweapon _handgunweapon;
	
			{
				if(_x != "") then {
					_this addHandgunItem _x;
				};
			} foreach _handgunweaponitems;
	
			{
				if(_x != "") then {
					_this additem _x;
					_this assignItem _x;
				};
			} foreach _assigneditems;

			_this addWeapon "ItemGPS";

			if (needReload player == 1) then {reload player};
			true;
		};

		PUBLIC FUNCTION("","deconstructor") {
			DELETE_VARIABLE("inventory");
		 };
	ENDCLASS;