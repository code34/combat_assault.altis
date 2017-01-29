	// -----------------------------------------------
	// Author: Xeno rework by  code34 nicolas_boiteux@yahoo.fr
	// warcontext - Repair vehicle
	// -----------------------------------------------
	if!(isserver) exitwith {};

	private [
		"_config", 
		"_count",
		"_i",
		"_magazines",
		"_vehicle",
		"_type"
		];

	_vehicle = _this;

	if(isnull _vehicle) exitwith {};
	if(!alive _vehicle) exitWith {};

	_type = typeof _vehicle;
	_magazines = getArray(configFile >> "CfgVehicles" >> _type >> "magazines");

	if (count _magazines > 0) then {
		{
			_vehicle removeMagazine _x;
		} forEach _magazines;
		{
			_vehicle addMagazine _x;
		} forEach _magazines;
	};

	_count = count (configFile >> "CfgVehicles" >> _type >> "Turrets");
	if (_count > 0) then {
		for "_i" from 0 to (_count - 1) do {
			_config = (configFile >> "CfgVehicles" >> _type >> "Turrets") select _i;
			_magazines = getArray(_config >> "magazines");
			{
				_vehicle removeMagazinesTurret [_x, [_i]];
			} forEach _magazines;
			{
				_vehicle addMagazineTurret [_x, [_i]];
			} forEach _magazines;
		};
	};
	
	_vehicle setDamage 0;
	_vehicle setFuel 1;