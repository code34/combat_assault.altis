	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2016-2018 Nicolas BOITEUX

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

	player playMoveNow "Acts_carFixingWheel";
	sleep 2;
	private _path = [(str missionConfigFile), 0, -15] call BIS_fnc_trimString;
	private _sound = _path + "client\sounds\hammer.ogg";
	playSound3D [_sound, player, false, getPosASL player, 2, 1, 150];
	sleep 4;
	if(!alive player)exitWith {};
	["remoteSpawn", ["BME_netcode_server_wcpackbase", "", "server"]] call client_bme;
	private _sound = _path + "client\sounds\builddone.ogg";
	playSound3D [_sound, player, false, getPosASL player, 2, 1, 150];