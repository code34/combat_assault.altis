	// -----------------------------------------------
	// Author:  code34 nicolas_boiteux@yahoo.fr
	// WARCONTEXT - Simple Seek & destroy patrol script

	private [
		"_artillery",
		"_areasize",
		"_alert",
		"_canartillery",
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
		"_round",
		"_smokeposition", 
		"_sector",
		"_support",
		"_wp",
		"_wptype"
	];

	_group = _this select 0;
	_position = _this select 1;
	_areasize = _this select 2;
	_sector = _this select 3;

	if("isArtillery" call _sector) then {
		_artillery = "getArtillery" call _sector;
		_canartillery = true;
		_grid = ["new", [31000,31000,100,100]] call OO_GRID;
	} else {
		_canartillery = false;
	};

	_newposition = [];

	if (isnil "_areasize") exitwith {
		hintc "WARCONTEXT: patrolscript: areasize parameter is not set";
	};

	// artillery support
	(leader _group) setvariable ['support', []];

	switch (side (leader _group)) do {
		case west: {
			_enemyside = [east];
		};

		case east: {
			_enemyside = [west];
		};

		default {
			_enemyside = [west];
		};
	};

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
				["setAlert", true] call _sector;
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

			if(_canartillery) then {
				_support = (leader _group) getVariable "support";
				if(count _support > 0) then {
					["setTarget", (_support select 0)] call _artillery;
					"autoSetAmmo" call _artillery;
					"doFire" call _artillery;
					(leader _group) setvariable ['support', []];
				};

				if(random 1 > 0.95) then {
					_key = ["getSectorFromPos", position _cible] call _grid;
					_sector = ["Get", str(_key)] call global_zone_hashmap;
					if(!isnil "_sector") then {
						["setSuppression", true] call _artillery;
					} else {
						["setSuppression", false] call _artillery;
					};
					["setTarget", _cible] call _artillery;
					"autoSetAmmo" call _artillery;
					"doFire" call _artillery;
				};
			};

			if(vehicle (leader _group) != leader _group) then {
				_newposition = [position _cible, random (_areasize), random 359] call BIS_fnc_relPos;
			} else {
				_newposition = position _cible;
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

					if(random 1 > 0.97) then {
						_round = ceil(random 3);
						for "_x" from 0 to _round step 1 do {
							_smokeposition = [position (leader _group), 5, random 359] call BIS_fnc_relPos;
							_smoke = createVehicle ["G_40mm_Smoke", _smokeposition, [], 0, "NONE"];
						};
					};
				};
				sleep 1;
			};
			deletewaypoint _wp;
		};
		sleep 0.1;
	};
