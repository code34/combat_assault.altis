	// -----------------------------------------------
	// Author:  code34 nicolas_boiteux@yahoo.fr
	// WARCONTEXT - Simple Seek & destroy patrol script

	private [
		"_areasize",
		"_around",
		"_alert",
		"_cible", 
		"_cibles", 
		"_shadows",
		"_counter",
		"_formationtype",
		"_group", 
		"_grid",
		"_list",
		"_move",
		"_newposition",
		"_newx",
		"_newy",
		"_position",
		"_positions",
		"_originalsize",
		"_enemyside",
		"_sector",
		"_wp",
		"_wptype",
		"_vehicle"
	];

	_group = _this select 0;
	_position = _this select 1;
	_areasize = _this select 2;
	_sector = _this select 3;
	_vehicle = _this select 4;

	_grid = ["new", [31000,31000,100,100]] call OO_GRID;
	_positions = [];

	_around = ["getSectorAllAround", ["getSector" call _sector, 8]] call _grid;
	{
		_pos = ["getPosFromSector", _x] call _grid;
		_positions = _positions + [_pos];
	}foreach _around;

	_newposition = [];
	_newx = 0;
	_newy = 0;

	if (isnil "_areasize") exitwith {
		hintc "WARCONTEXT: patrolscript: areasize parameter is not set";
	};

	_enemyside = [west];

	_alert = false;

	while { (count (units _group) > 0) } do {
		_cibles = [];
		_shadows = [];
		_list = _position nearEntities [["Man"], 400];
		if(count _list > 0) then {
			{
				if((side _x in _enemyside) and (isPlayer _x)) then {
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

			if(vehicle (leader _group) != leader _group) then {
				_newposition = [position _cible, random (_areasize), random 359] call BIS_fnc_relPos;
			} else {
				_newposition = position _cible;
			};

			{
				_x dotarget _cible;
				_x domove _newposition;
			}foreach (units _group);

			while { moveToCompleted (driver _vehicle)} do {
				sleep 1;
			};
		} else {
			_group setBehaviour "AWARE";
			_group setCombatMode "GREEN";

			_newposition = _positions call BIS_fnc_selectRandom;

			while { (position (leader _group)) distance _newposition < 50 } do {
				_newposition = _positions call BIS_fnc_selectRandom;
				sleep 0.1;
			};

			(driver _vehicle) domove _newposition;
			while { moveToCompleted (driver _vehicle)} do {
				sleep 1;
			};
		};
		sleep 0.1;
	};
