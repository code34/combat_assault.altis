		// -----------------------------------------------
		// Author: team  code34 nicolas_boiteux@yahoo.fr
		// WARCONTEXT - Description: Handler for all enemy units
		// -----------------------------------------------	

		private ["_vehicle"];

		_vehicle = _this select 0;

		_vehicle removeAllEventHandlers "HandleDamage";
		_vehicle addeventhandler ['HandleDamage', {
			if(damage (_this select 0) > 0.9) then {
					(_this select 0) setdamage 1;
					(_this select 0) removeAllEventHandlers "HandleDamage";
					{
						_x setdamage 1;
					}foreach (crew (_this select 0));
			};
		}];
