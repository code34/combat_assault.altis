	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014-2017 Nicolas BOITEUX

	CLASS OO_FACTORY
	
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

	CLASS("OO_FACTORY")
		PRIVATE VARIABLE("bool","run");
		PRIVATE VARIABLE("array","west");
		PRIVATE VARIABLE("array","east");
		PRIVATE VARIABLE("array", "factorys");

		PUBLIC FUNCTION("","constructor") {
			MEMBER("run", false);
			MEMBER("west", []);
			MEMBER("east", []);
			MEMBER("factorys", []);
			MEMBER("discover", nil);
		};

		PUBLIC FUNCTION("","getWest") FUNC_GETVAR("west");
		PUBLIC FUNCTION("","getEast") FUNC_GETVAR("east");
		PUBLIC FUNCTION("","getFactorys") FUNC_GETVAR("factorys");

		PUBLIC FUNCTION("", "discover") {
			private _factorys = [];
			private _center = getArray (configfile >> "CfgWorlds" >> worldName >> "centerPosition");
			private _size = (getNumber (configfile >> "CfgWorlds" >> worldName >> "mapSize") / 2);
			private _objects = nearestObjects [_center, ["Land_dp_mainFactory_F","Land_dp_smallFactory_F", "Land_MilOffices_V1_F", "Land_Factory_Main_F", "Land_Factory_Tunnel_F", "Land_DPP_01_mainFactory_F", "Land_DPP_01_smallFactory_F", "Land_SCF_01_boilerBuilding_F", "Land_SM_01_shed_F", "Land_SM_01_shed_unfinished_F", "Land_SM_01_shelter_narrow_F", "Land_SM_01_shelter_wide_F"], _size];
			private _object = objNull;
			
			for "_x" from 0 to 10 step 1 do {
				_object = _objects deleteAt floor((random(count _objects)));
				_factorys pushBack (position _object);
			};

			private _mark1 = "";
			private _mark2 = "";
			private _name = "";
			private _names = [];
			{
				_name = toUpper (["generateName", (ceil (random 3) + 1)] call global_namegenerator);		
				 _mark1 = createMarker [_name+"_FACTORY", _x];
				_mark1 setMarkerType "respawn_armor";
				_mark1 setMarkerText (_name + " FACTORY");
				_mark1	setMarkerSize [0.5,0.5];
				_mark2 = createMarker [_name, _x];
				_mark2 setMarkerShape "ELLIPSE";
				_mark2 setMarkerSize [50,50];
				_mark2 setMarkerColor "COLORBLUE";
				_mark2 setMarkerBrush "FDiagonal";
				_names pushBack _name;
			}foreach _factorys;
			MEMBER("factorys", _names);
		};

		PUBLIC FUNCTION("", "isFriendly") {	
			private _enemies = false;
			private _sector = [];
			private _around = [];

			MEMBER("west", []);
			MEMBER("east", []);
			{						
				_enemies = false;
				_sector = ["getSectorFromPos", getmarkerpos _x] call global_grid;
				_around = ["getSectorsAroundSector", _sector] call global_grid;
				{
					_sector = ["get", str(_x)] call global_zone_hashmap;
					if(!isnil "_sector") then {
						if("getState" call _sector < 2) then {
							_enemies = true;
						};
					};
					sleep 0.1;
				}foreach _around;
				
				if(_enemies) then {
					_x setmarkercolor "colorRed";
					MEMBER("east", _nil) pushBack _x;
				} else {
					_x setmarkercolor "colorBlue";
					MEMBER("west", _nil) pushBack _x;
				};
				sleep 1;
			}foreach MEMBER("factorys", nil);
		};

		PUBLIC FUNCTION("", "countWest") {
			count MEMBER("west", nil);
		};

		PUBLIC FUNCTION("", "countEast") {
			count MEMBER("east", nil);
		};

		PUBLIC FUNCTION("", "start") {
			MEMBER("run", true);
			while { MEMBER("run", nil) } do {
				MEMBER("isFriendly", nil);
				sleep 1;
			};
		};

		PUBLIC FUNCTION("", "stop") {
			MEMBER("run", false);
		};


		PUBLIC FUNCTION("","deconstructor") { 
			DELETE_VARIABLE("west");
			DELETE_VARIABLE("east");
			DELETE_VARIABLE("run");
		};
	ENDCLASS;