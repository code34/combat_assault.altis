	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2013 Nicolas BOITEUX

	Bus Message Exchange (BME)
	
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

	private ["_garbage"];

	BME_fnc_queue		= compilefinal preprocessFile "client\BME\BME_queue.sqf";
	BME_fnc_eventhandler	= compilefinal preprocessFile "client\BME\BME_eventhandler.sqf";
	BME_fnc_log		= compilefinal preprocessFile "client\BME\BME_log.sqf";
	BME_fnc_clienthandler	= compilefinal preprocessFile "client\BME\BME_clienthandler.sqf";

	if(isserver) then {
		BME_fnc_serverhandler	= compilefinal preprocessFile "warcontext\BME\BME_serverhandler.sqf";

		bme_queue = [];
		_garbage = [] call BME_fnc_eventhandler;
		_garbage = [] call BME_fnc_serverhandler;
		_garbage = [] spawn BME_fnc_queue;
	};
	
	if((local player) and !(isserver)) then {
		bme_queue = [];
		_garbage = [] call BME_fnc_eventhandler;
		_garbage = [] spawn BME_fnc_queue;
	};

	if(local player) then {
		_garbage = [] call BME_fnc_clienthandler;
	};