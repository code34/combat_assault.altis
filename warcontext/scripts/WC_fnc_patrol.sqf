	// -----------------------------------------------
	// Author:  code34 nicolas_boiteux@yahoo.fr
	// WARCONTEXT - Simple Seek & destroy patrol script

	private [
		"_areasize",
		"_alert",
		"_cible", 
		"_cibles", 
		"_shadows",
		"_counter",
		"_formationtype",
		"_group", 
		"_grid",
		"_key",
		"_list",
		"_move",
		"_newposition",
		"_position",
		"_originalsize",
		"_object",
		"_enemyside",
		"_sector",
		"_wp",
		"_wptype"
	];

	_group = _this select 0;
	_position = _this select 1;
	_areasize = _this select 2;
	_sector = _this select 3;

	_newposition = [];
	(leader _group) setvariable ['support', []];

	_enemyside = [west];
	_alert = false;

	while { (count (units _group) > 0) } do {
		_cibles = [];
		_shadows = [];
		_list = _position nearEntities [["Man", "Tank"], 600];
		if(count _list > 0) then {
			{
				if(side _x in _enemyside) then {
					if((leader _group) knowsAbout _x > 0.4) then {
						_cibles = _cibles + [_x];
					} else {
						_shadows = _shadows + [_x];
					};
				} else {			
					_list = _list - [_x];
				};
				sleep 0.1;
			}foreach _list;
			if(count _cibles > 0) then {
				_alert = true;
				["setAlertAround", true] call _sector;
			} else {
				_alert = false;
			};
		};

		if((_alert) or ("getAlert" call _sector)) then {
			_group setBehaviour "COMBAT";
			_group setCombatMode "RED";

			if(count _cibles > 0) then {
				_cible = (_cibles call BIS_fnc_selectRandom);
			} else {
				_cible = (_shadows call BIS_fnc_selectRandom);
			};

			_newposition = [position _cible, (50 + random (_areasize)), random 359] call BIS_fnc_relPos;
			while { (position _cible) distance _newposition < 25 } do {
				_newposition = [position _cible, (50 + random (_areasize)), random 359] call BIS_fnc_relPos;
				sleep 0.1;
			};

			_wp = _group addWaypoint [_newposition, 25];
			_wp setWaypointPosition [_newposition, 25];
			_wp setWaypointType "MOVE";
			_wp waypointAttachVehicle _cible;

			_wp setWaypointSpeed "FULL";
			_group setCurrentWaypoint _wp;

			sleep 30;
			deletewaypoint _wp;
		} else {
			_wptype = ["GUARD"];
			_group setBehaviour "SAFE";
			_group setCombatMode "GREEN";

			_formationtype = ["COLUMN", "STAG COLUMN","WEDGE","ECH LEFT","ECH RIGHT","VEE","LINE","FILE","DIAMOND"] call BIS_fnc_selectRandom;
			_group setFormation _formationtype;

			_newposition = [_position, random (_areasize), random 359] call BIS_fnc_relPos;
			while { (position (leader _group)) distance _newposition < 20 } do {
				_newposition = [_position, random (_areasize), random 359] call BIS_fnc_relPos;
				sleep 0.1;
			};

			_wp = _group addWaypoint [_newposition, 25];
			_wp setWaypointPosition [_newposition, 25];
			_wp setWaypointType (_wptype call BIS_fnc_selectRandom);
			_wp setWaypointVisible true;
			_wp setWaypointSpeed "LIMITED";
			_wp setWaypointStatements ["true", "this setvariable ['complete', true]; false"];
			_group setCurrentWaypoint _wp;

			_move = true;
			_originalsize = count (units _group);
			_counter = 0;

			while { _move } do {
				_counter = _counter + 1;
				if(format["%1", (leader _group) getVariable "complete"] == "true") then {
					(leader _group) setvariable ['complete', false];
					_move = false;
				};
				if(_counter > 29) then {
					_move = false;
				};			
				if(count (units _group) < _originalsize) then {
					_move = false;
					_alert = true;
					["setAlert", true] call _sector;
				};
				sleep 1;
			};
			deletewaypoint _wp;
		};
		sleep 0.1;
	};
