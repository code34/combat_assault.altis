	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2016 Nicolas BOITEUX

	CLASS OO_BASEGENERATOR
	
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

	CLASS("OO_BASEGENERATOR")
		PRIVATE VARIABLE("array","position");
		PRIVATE VARIABLE("array", "structures");

		PUBLIC FUNCTION("array","constructor") {
			MEMBER("position", _this);
		};

		PUBLIC FUNCTION("","getPosition") FUNC_GETVAR("position");

		PUBLIC FUNCTION("", "generate"){
			private ["_position", "_structures"];

			_position = MEMBER("position", nil);
			_structures = [];

			{ _x hideObjectGlobal true } foreach (nearestTerrainObjects [_position,[], 100]);

			_temp = "Land_LampAirport_F" createVehicle (_position findEmptyPosition [30,60]);
			_temp setdir (random 360);
			_structures = _structures + [_temp];

			_temp = "Land_Cargo_HQ_V2_F" createVehicle (_position findEmptyPosition [40,100]);
			_temp setdir (random 360);
			_structures = _structures + [_temp];
			
			_temp = "Land_Cargo_House_V1_F" createVehicle (_position findEmptyPosition [30,100]);
			_temp setdir (random 360);
			_structures = _structures + [_temp];
			
			_temp = "Land_Medevac_house_V1_F" createVehicle (_position findEmptyPosition [30,100]);
			_temp setdir (random 360);
			_structures = _structures + [_temp];
			
			_temp = "B_Truck_01_transport_F" createVehicle (_position findEmptyPosition [30,100]);
			_structures = _structures + [_temp];
			
			_temp = "B_APC_Wheeled_01_cannon_F" createVehicle (_position findEmptyPosition [30,100]);
			_structures = _structures + [_temp];

			MEMBER("structures", _structures);
		};


		PUBLIC FUNCTION("", "deleteBase"){
			{
				deleteVehicle _x;
				sleep 0.01;
			}foreach MEMBER("structures", nil);
		};		

		PUBLIC FUNCTION("","deconstructor") { 
			MEMBER("deleteBase", nil);
			DELETE_VARIABLE("structures");
			DELETE_VARIABLE("position");
		};
	ENDCLASS;