	// -----------------------------------------------
	// Author : ?
	// fix code34 nicolas_boiteux@yahoo.fr
	// -----------------------------------------------
	if (!isServer) exitwith {};

	private [
			"_handle",
			"_marker",
			"_markersize",
			"_markerpos",
			"_type",
			"_sector",
			"_position",
			"_group"
		];

	_sector 		= _this select 0;
	_marker			=  "getMarker" call _sector;

	_markerpos 		= getmarkerpos _marker;
	_markersize		= (getMarkerSize _marker) select 1;

	_type = ["OIA_InfSquad_Weapons","OIA_InfSquad", "OIA_InfTeam", "OIA_InfTeam_AA", "OIA_InfTeam_AT", "OI_SniperTeam", "OI_ReconTeam"] call BIS_fnc_selectRandom;

	_position = [_markerpos, random (_markersize -15), random 359] call BIS_fnc_relPos;

	_group = [_position, east, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "infantry" >> _type)] call BIS_fnc_spawnGroup;

	{
		_handle = [_x, _type] spawn WC_fnc_skill;
	}foreach (units _group);

	_handle = [_group, position (leader _group), _markersize, _sector] execVM "warcontext\WC_fnc_patrol.sqf";

	units _group;
	