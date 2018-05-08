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
		PRIVATE VARIABLE("code","this");
		PRIVATE VARIABLE("array","sendspawnqueue");
		PRIVATE VARIABLE("array","sendcallqueue");
		PRIVATE VARIABLE("array","receivespawnqueue");
		PRIVATE VARIABLE("array","receivecallqueue");
		PRIVATE VARIABLE("array","receiveloopbackqueue");
		PRIVATE VARIABLE("scalar","transactid");
		PRIVATE VARIABLE("scalar","callreleasetime");
		PRIVATE VARIABLE("array","handlers");
		
		PUBLIC FUNCTION("","constructor") {
			DEBUG(#, "OO_BME::constructor")
			MEMBER("sendspawnqueue", []);
			MEMBER("receivespawnqueue", []);
			MEMBER("sendcallqueue", []);
			MEMBER("receivecallqueue", []);
			MEMBER("receiveloopbackqueue", []);
			MEMBER("transactid", -1);
			MEMBER("callreleasetime", 3);
			MEMBER("declareHandler", nil);
			MEMBER("handlers", []);

			MEMBER("handlers", nil) pushBack (["runReceiveCallQueue", 0.05] spawn MEMBER("this", nil));
			MEMBER("handlers", nil) pushBack (["runReceiveSpawnQueue", 0.05] spawn MEMBER("this", nil));
			MEMBER("handlers", nil) pushBack (["runSendCallQueue", 0.05] spawn MEMBER("this", nil));
			MEMBER("handlers", nil) pushBack (["runSendSpawnQueue", 0.05] spawn MEMBER("this", nil));
			MEMBER("handlers", nil) pushBack ("garbageReceiveLoopBackQueue" spawn MEMBER("this", nil));
		};

		// Declare connexion handlers
		PUBLIC FUNCTION("","declareHandler") {
			DEBUG(#, "OO_BME::declareHandler")
			"bme_add_spawnqueue" addPublicVariableEventHandler compile format["['addReceiveSpawnQueue', _this select 1] spawn %1", MEMBER("this", nil)];
			"bme_add_callqueue" addPublicVariableEventHandler compile format["['addReceiveCallQueue', _this select 1] spawn %1", MEMBER("this", nil)];
			"bme_add_loopback" addPublicVariableEventHandler compile format["['addReceiveLoopbackQueue', _this select 1] spawn %1", MEMBER("this", nil)];
		};

		// Entry function for remote call
		// Endpoint for loopback result
		//	private _remotefunction 	= _this select 0;
		//	private _parameters 		=  _this select 1;
		//	private _targetid 		= _this select 3;
		//	private _defaultreturn		= _this select 4;
		PUBLIC FUNCTION("array","remoteCall") {
			DEBUG(#, "OO_BME::remoteCall")
			private _remotefunction = _this select 0;
			private _parameters = _this select 1;
			private _targetid = _this select 2;
			private _defaultreturn = param [3, []];
			private _timeout = param [4, 3, [0]];
			private _transactid = (MEMBER("transactid", nil) + 1);
			private _log = "";
			if(_transactid > 99) then { _transactid = 0;};
			MEMBER("transactid", _transactid);

			if!(_remotefunction isEqualType "") exitwith { MEMBER("log", "Wrong type variablename parameter, should be STRING"); false; };
			if(isnil "_parameters") exitwith { _log = format["Parameters data for %1 handler is nil", _remotefunction]; MEMBER("log", _log); false; };
			if(isNil "_targetid") exitwith {MEMBER("log", "Client targetID must be define"); false; };

			MEMBER("receiveloopbackqueue", nil) set [_transactid, [_defaultreturn, time + _timeout, false]];
			MEMBER("sendcallqueue", nil) pushBack [_remotefunction, _parameters, clientOwner, _targetid, _transactid];
			MEMBER("getLoopBackReturn", _transactid);
		};

		// unpop queue of call send messages
		// execute the corresponding code
		//[_remotefunction, _parameters, _sourceid, _targetid, _transactid];
		PUBLIC FUNCTION("scalar","runSendCallQueue") {
			DEBUG(#, "OO_BME::runSendCallQueue")
			private _parsingtime = _this;
			private _destination = "";
			while { true } do {
				bme_add_callqueue = MEMBER("sendcallqueue", nil) deleteAt 0;
				if(!isnil "bme_add_callqueue") then {
					if((bme_add_callqueue select 3) isEqualTo 2) then {
						publicvariableserver "bme_add_callqueue";
					} else {
						if!((bme_add_callqueue select 2) isEqualTo (bme_add_callqueue select 3)) then{
							(bme_add_callqueue select 3) publicvariableclient "bme_add_callqueue";
						} else {
							if((local player) and (isserver)) then { MEMBER("addReceiveCallQueue", bme_add_callqueue);	};
						};
					};
				};
				uiSleep _parsingtime;
			};
		};

		// function call by addPublicVariableEventHandler
		// insert message in call queue for server / client
		// _function = _this select 0;
		// _parameters = _this select 1;
		// _sourceid = _this select 2;
		// _targetid = _this select 3;
		//_transactid = _this select 4;
		PUBLIC FUNCTION("array","addReceiveCallQueue") {
			DEBUG(#, "OO_BME::addReceiveCallQueue")
			// insert message in the queue if its for server
			if((isserver) and ((_this select 3) isEqualTo 2)) then {
				MEMBER("receivecallqueue", nil) pushBack _this;
			} else {
				// insert message in the queue if its for specific client
				if((local player) and ((_this select 3) isEqualTo clientOwner)) then {
					MEMBER("receivecallqueue", nil) pushBack _this;
				};
			};
		};

		// function loopback by addPublicVariableEventHandler
		// insert message in loopback queue for server / client
		// _transactid = _this select 0;
		// _return = _this select 1;
		PUBLIC FUNCTION("array","addReceiveLoopBackQueue") {
			DEBUG(#, "OO_BME::addReceiveLoopBackQueue")
			private _array = MEMBER("receiveloopbackqueue", nil);
			if!(isNil {_array select (_this select 0)} ) then {
				_array select (_this select 0) set [0, _this select 1]; 
				_array select (_this select 0) set [2, true]; 
			};
		};

		// unpop queue of call receive messages
		// execute the corresponding code
		PUBLIC FUNCTION("scalar","runReceiveCallQueue") {
			DEBUG(#, "OO_BME::runReceiveCallQueue")
			private _parsingtime = _this;
			private _message = [];
			private _remotefunction = "";
			private _parameters = "";
			private _sourceid = 0;
			private _transactid = 0;
			private _code = nil;
			private _array = [];
			private _log = "";

			while { true } do {
				_message = MEMBER("receivecallqueue", nil) deleteAt 0;
				if(!isnil "_message") then {
					_remotefunction	= _message select 0;
					_parameters		= _message select 1;
					_sourceid		= _message select 2;
					_transactid		= _message select 4;
					_code 	= {};

					_code = missionNamespace getVariable _remotefunction;
					if!(isnil "_code") then {
						if !(typeName _code isEqualTo "CODE") then {
							_log = format ["Server receive an unknow remote call: %1", _remotefunction];
							MEMBER("log", _log);
						} else {
							bme_add_loopback = [_transactid, (_parameters call _code)];
							_sourceid publicVariableClient "bme_add_loopback";
						};
					} else {
						_log = format["Server handler function for %1 doesnt exist", _remotefunction];
						MEMBER("log", _log);
					};
				};
				uiSleep _parsingtime;
			};
		};		

		// unpop queue of loopback receive messages
		// execute the corresponding code
		// private _transactid = _this;
		// MEMBER("receiveloopbackqueue", nil)  = [_transactid, [_defaultreturn, time + MEMBER("callreleasetime", nil), false]
		PUBLIC FUNCTION("scalar","getLoopBackReturn") {
			DEBUG(#, "OO_BME::getLoopBackReturn")
			private _run = true;
			private _transactid = _this;
			private _return = "";

			while { _run } do {
				if ((time > (MEMBER("receiveloopbackqueue", nil) select _transactid) select 1) || ((MEMBER("receiveloopbackqueue", nil) select _transactid) select 2)) then {
					_return = (MEMBER("receiveloopbackqueue", nil) select _transactid) select 0;
					MEMBER("receiveloopbackqueue", nil) set [_transactid, nil];
					_run = false;
				};
				uiSleep 0.01;
			};
			_return;
		};

		//  Entry function for remote spawn
		PUBLIC FUNCTION("array","remoteSpawn") {
			DEBUG(#, "OO_BME::remoteSpawn")
			private _remotefunction 	= _this select 0;
			private _parameters 		=  _this select 1;
			private _destination		= tolower(_this select 2);
			private _targetid 		= _this select 3;
			private _log			= "";

			if!(_remotefunction isEqualType "") exitwith { MEMBER("log", "Wrong type variablename parameter, should be STRING"); false; };
			if(isnil "_parameters") exitwith { _log = format["Parameters data for %1 handler is nil", _remotefunction];MEMBER("log", _log); false; };
			if!(_destination isEqualType "") exitwith { MEMBER("log", "Wrong type destination parameter, should be STRING"); false; };
			if!(_destination in ["client", "server", "all"]) exitwith {MEMBER("log", "Wrong destination parameter should be client|server|all"); false; };

			if(isNil "_targetid") then {
				MEMBER("sendspawnqueue", nil) pushBack [_remotefunction, _parameters, _destination];
			} else {
				MEMBER("sendspawnqueue", nil) pushBack [_remotefunction, _parameters, _destination, _targetid];
			};
			true;
		};		

		// function call by addPublicVariableEventHandler
		// insert message in spawn queue for server / client / all
		//	private _remotefunction 	= _this select 0;
		//	private _parameters 		=  _this select 1;
		//	private _destination		= tolower(_this select 2);
		//	private _targetid 		= _this select 3;
		PUBLIC FUNCTION("array","addReceiveSpawnQueue") {
			DEBUG(#, "OO_BME::addReceiveSpawnQueue")
			if((isserver) and (((_this select 2) isEqualTo "server") or ((_this select 2) isEqualTo "all"))) then {
				MEMBER("receivespawnqueue", nil) pushBack [_this select 0, _this select 1, "server", _this select 3];
			};

			// insert message in the queue if its for client or everybody
			// _destination = _this select 2;
			if((local player) and (((_this select 2) isEqualTo "client") or ((_this select 2) isEqualTo "all"))) then {	
				MEMBER("receivespawnqueue", nil) pushBack [_this select 0, _this select 1, "client", _this select 3];
			};
		};

		// unpop queue of spawn receive messages
		// execute the corresponding code
		// return nothing
		PUBLIC FUNCTION("scalar","runReceiveSpawnQueue") {
			DEBUG(#, "OO_BME::runReceiveSpawnQueue")
			private _parsingtime = _this;
			private _message = [];
			private _remotefunction = "";
			private _parameters = "";
			private _destination = "";
			private _targetid = 0;
			private _code = nil;
			private _log = "";

			while { true } do {
				_message = MEMBER("receivespawnqueue", nil) deleteAt 0;
				if(!isnil "_message") then {
					_remotefunction	= _message select 0;
					_parameters		= _message select 1;
					_destination 		= _message select 2;
					_targetid		= _message select 3;
					_code 			= {};

					if (isNil "_targetid") then { _targetid = 0;};

					if(isserver and ((_destination isEqualTo "server") or (_destination isEqualTo "all"))) then {
						_code = missionNamespace getVariable _remotefunction;
						if!(isnil "_code") then {
							if !(typeName _code isEqualTo "CODE") then {
								_log = format ["Server receive an unknow remote spawn: %1", _remotefunction];
								MEMBER("log", _log);
							} else {
								_parameters spawn _code;
							};
						} else {
							_log = format["Server handler function for %1 doesnt exist", _remotefunction];
							MEMBER("log", _log);
						};
					};

					if(local player and ((_destination isEqualTo "client") or (_destination isEqualTo "all"))) then {
						_code = missionNamespace getVariable _remotefunction;
						if!(isnil "_code") then {
							if !(typeName _code isEqualTo "CODE") then { 
								_log = format ["Client receive an unknow remote spawn: %1", _remotefunction];
								MEMBER("log", _log);
							} else {
								_parameters spawn _code;
							};
						} else {
							_log = format["Client handler function for %1 doesnt exist", _remotefunction];
							MEMBER("log", _log);
						};
					};
				};
				uiSleep _parsingtime;
			};
		};

		// unpop queue of spawn send messages
		// execute the corresponding code
		PUBLIC FUNCTION("scalar","runSendSpawnQueue") {
			DEBUG(#, "OO_BME::runSendSpawnQueue")
			private _parsingtime = _this;
			while { true } do {
				bme_add_spawnqueue = MEMBER("sendspawnqueue", nil) deleteAt 0;
				if(!isnil "bme_add_spawnqueue") then {
					switch (bme_add_spawnqueue select 2) do {
						case "server": { publicvariableserver "bme_add_spawnqueue"; };
						case "client": {
							if(count bme_add_spawnqueue > 3) then {
								(bme_add_spawnqueue select 3) publicvariableclient "bme_add_spawnqueue";
							} else {
								if((local player) and (isserver)) then { MEMBER("addReceiveSpawnQueue", bme_add_spawnqueue); };
								publicvariable "bme_add_spawnqueue";
							};
						};
						default {
							if(isserver) then {
								if!(local player) then { publicvariableserver "bme_add_spawnqueue"; };
							} ;
							if(local player) then { MEMBER("addReceiveSpawnQueue", bme_add_spawnqueue);	};
							publicvariable "bme_add_spawnqueue";
						};
					};
				};
				uiSleep _parsingtime;
			};
		};

		PUBLIC FUNCTION("string","log") {
			DEBUG(#, "OO_BME::log")
			hintc format["BME: %1", _this];
			diag_log format["BME: %1", _this];
		};

		PUBLIC FUNCTION("","deconstructor") { 
			DEBUG(#, "OO_BME::deconstructor")
			{ terminate _x; } foreach MEMBER("handlers", nil);
			DELETE_VARIABLE("handlers");
			DELETE_VARIABLE("this");
			DELETE_VARIABLE("transactid");
			DELETE_VARIABLE("sendspawnqueue");
			DELETE_VARIABLE("sendcallqueue");
			DELETE_VARIABLE("receivespawnqueue");
			DELETE_VARIABLE("receivecallqueue");
			DELETE_VARIABLE("receiveloopbackqueue");
			DELETE_VARIABLE("callreleasetime");
		};
	ENDCLASS;