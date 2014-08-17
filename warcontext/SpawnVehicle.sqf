	// -----------------------------------------------
	// Author : ?
	// fix code34 nicolas_boiteux@yahoo.fr
	// -----------------------------------------------
	if (!isServer) exitwith {};

	private [
			"_array",
			"_handle",
			"_marker",
			"_markersize",
			"_markerpos",
			"_type",
			"_sector",
			"_position",
			"_group",
			"_units",
			"_vehicle"
		];

	_sector 		= _this select 0;
	_marker			=  "getMarker" call _sector;

	_markerpos 		= getmarkerpos _marker;
	_markersize		= (getMarkerSize _marker) select 1;

	if(random 1 > 0.5) then {
		//light vehicle
		_vehicle = ["O_MRAP_02_F","O_MRAP_02_hmg_F","O_MRAP_02_gmg_F", "I_MRAP_03_F","I_MRAP_03_hmg_F","I_MRAP_03_gmg_F"] call BIS_fnc_selectRandom;
	} else {
		//heavy vehicle
		_vehicle = ["O_APC_Tracked_02_cannon_F","O_APC_Tracked_02_AA_F","O_MBT_02_cannon_F","O_MBT_02_arty_F","O_APC_Wheeled_02_rcws_F","I_APC_Wheeled_03_cannon_F"] call BIS_fnc_selectRandom;
	};

	_position = [_markerpos, random (_markersize -15), random 359] call BIS_fnc_relPos;
	_position = [_position, 0,50,10,0,2000,0] call BIS_fnc_findSafePos;


	_array = [_position, random 359, _vehicle, east] call bis_fnc_spawnvehicle;

	_vehicle = _array select 0;
	_group = _array select 2;

	_handle = [_group, position (leader _group), 400, _sector] execVM "warcontext\WC_fnc_patrol.sqf";	
	_vehicle setVehicleLock "LOCKED";

	{
		wcgarbage = [_x, ""] spawn WC_fnc_skill;
		sleep 0.5;
	}foreach (units _group);

	_units = units _group;
	_units;