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
		"_group", 
		"_grid",
		"_list",
		"_nextsector",
		"_position",
		"_sector",
		"_sectors",
		"_target",
		"_vehicle"
	];

	_group = _this select 0;
	_position = _this select 1;
	_areasize = _this select 2;
	_sector = _this select 3;
	_vehicle = _this select 4;

	_grid = ["new", [31000,31000,100,100]] call OO_GRID;
	_around = ["getSectorAllAround", ["getSector" call _sector, 10]] call _grid;

	while { (count (units _group) > 0) } do {
		_sectors = [];
		{
			if(["containsKey", [_x]] call global_zone_hashmap ) then {
				_nextsector = ["Get", [_x]] call global_zone_hashmap;
				if("getAlert" call _nextsector) then {
					_sectors = _sectors + [_nextsector];
				};
			};
			sleep 0.001;
		} foreach _around;

		if(count _sectors > 0) then {		
			_nextsector = "getSector" call (_sectors call BIS_fnc_selectRandom);
			_alert = true;
		} else {
			_nextsector = (_around call BIS_fnc_selectRandom);
			_alert = false;
		};
		_position = ["getPosFromSector", _nextsector] call _grid;

		if(_alert) then {
			_list = _position nearEntities [["Man"], 200];
			_group setBehaviour "COMBAT";
			_group setCombatMode "RED";
		} else {
			_group setBehaviour "SAFE";
			_group setCombatMode "GREEN";
			_list = [];
		};

		if(count _list > 0) then {
			_target = [_list call BIS_fnc_selectRandom];
			_position = position (_target select 0);
		} else {
			_target = [];
		};

		_attack = true;
		while { _attack } do {
			if(count _target > 0) then {
				if(alive (_target select 0)) then {
					{
						_x dotarget (_target select 0);
						_x domove ([_position, random 20, random 359] call BIS_fnc_relPos);
					}foreach (units _group);
					sleep 20;
				} else {
					_target = [];
					_attack = false;
				};
			} else {
				_groundpos = [(position _vehicle) select 0, (position _vehicle) select 1];
				if(_groundpos distance _position < 200) then {
					_attack = false;
				} else {
					{
						_x  domove _position;
					}foreach (units _group);
					sleep 20;
				};
			};
		};
	};