	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2016-2018 Nicolas BOITEUX

	CLASS OO_BME
	
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

	CLASS("OO_BME")
		PRIVATE VARIABLE("array","sendqueue");
		PRIVATE VARIABLE("array","receivequeue");
		
		PUBLIC FUNCTION("","constructor") {
			MEMBER("sendqueue", []);
			MEMBER("receivequeue", []);

			["runReceiveQueue", 0.1] spawn _self;
			["runSendQueue", 0.1] spawn _self;
		};

		PUBLIC FUNCTION("array","remoteSpawn") {
			private ["_remotefunction", "_variable", "_destination", "_playerid"];

			_remotefunction 	= _this select 0;
			_variable 		=  _this select 1;
			_destination		= tolower(_this select 2);
			_playerid 		= _this select 3;
			
			if!(_remotefunction isEqualType "") exitwith { MEMBER("log", "BME: wrong type variablename parameter, should be STRING"); false; };
			if(isnil "_variable") exitwith { MEMBER("log", format["BME:  Variable data for %1 handler is nil", _remotefunction]); false; };
			if!(_destination isEqualType "") exitwith { MEMBER("log", "BME: wrong type destination parameter, should be STRING"); false; };
			if!(_destination in ["client", "server", "all"]) exitwith {MEMBER("log", "BME: wrong destination parameter should be client|server|all"); false; };
			
			if(isNil "_playerid") then {
				MEMBER("sendqueue", nil) pushBack [_remotefunction, _variable, _destination];
			} else {
				MEMBER("sendqueue", nil) pushBack [_remotefunction, _variable, _destination, _playerid];
			};
			true;
		};

		PUBLIC FUNCTION("array","addReceiveQueue") {
			// insert message in the queue if its for server or everybody
			// _destination = _this select 2;
			if((isserver) and (((_this select 2) isEqualTo "server") or ((_this select 2) isEqualTo "all"))) then {
				MEMBER("receivequeue", nil) pushBack [_this select 0, _this select 1, "server"];
			};
			
			// insert message in the queue if its for client or everybody
			// _destination = _this select 2;
			if((local player) and (((_this select 2) isEqualTo "client") or ((_this select 2) isEqualTo "all"))) then {	
				MEMBER("receivequeue", nil) pushBack [_this select 0, _this select 1, "client"];
			};
		};

		PUBLIC FUNCTION("scalar","runReceiveQueue") {
			private ["_code", "_destination", "_garbage", "_message", "_variable", "_remotefunction", "_playerid", "_parsingtime"];

			_parsingtime = _this;

			while { true } do {
				_message = MEMBER("receivequeue", nil) deleteAt 0;
				if(!isnil "_message") then {
					_remotefunction	= _message select 0;
					_variable		= _message select 1;
					_destination 		= _message select 2;
					_playerid		= _message select 3;
					_code 			= nil;
					if (isNil "_playerid") then { _playerid = owner player;};

					if(isserver and ((_destination isEqualTo "server") or (_destination isEqualTo "all"))) then {
						_code = (missionNamespace getVariable (format ["BME_netcode_server_%1", _remotefunction]));
						if!(isnil "_code") then {
							_garbage = _variable spawn _code;
						} else {
							MEMBER("log", format["BME: server handler function for %1 doesnt exist", _remotefunction]);
						};
					};

					if(local player and (_playerid isEqualTo owner player) and ((_destination isEqualTo "client") or (_destination isEqualTo "all"))) then {
						_code = (missionNamespace getVariable (format ["BME_netcode_client_%1", _remotefunction]));
						if!(isnil "_code") then {
							_garbage = _variable spawn _code;
						} else {
							MEMBER("log", format["BME: client handler function for %1 doesnt exist", _remotefunction]);
						};
					};
				};
				sleep _parsingtime;
			};
		};

		PUBLIC FUNCTION("scalar","runSendQueue") {
			private ["_code", "_destination", "_garbage", "_message", "_variable", "_handlername", "_parsingtime"];

			_parsingtime = _this;

			while { true } do {
				bme_addqueue = MEMBER("sendqueue", nil) deleteAt 0;		
				if(!isnil "bme_addqueue") then {
					_destination = bme_addqueue select 2;
					switch (_destination) do {
						case "server": {
							publicvariableserver "bme_addqueue";
						};

						case "client": {
							if(count bme_addqueue > 3) then {
								(bme_addqueue select 3) publicvariableclient "bme_addqueue";
							} else {
								if((local player) and (isserver)) then { MEMBER("addReceiveQueue", bme_addqueue);	};
								publicvariable "bme_addqueue";
							};
						};

						default {
							if(isserver) then {
								if!(local player) then { publicvariableserver "bme_addqueue"; };
							} ;
							if(local player) then { MEMBER("addReceiveQueue", bme_addqueue);	};
							publicvariable "bme_addqueue";
						};
					};
				};
				sleep _parsingtime;
			};
		};

		PUBLIC FUNCTION("string","log") {
			hint format["%1", _this];
			diag_log format["%1", _this];
		};

		PUBLIC FUNCTION("","deconstructor") { 
			DELETE_VARIABLE("sendqueue");
			DELETE_VARIABLE("receivequeue");
		};
	ENDCLASS;