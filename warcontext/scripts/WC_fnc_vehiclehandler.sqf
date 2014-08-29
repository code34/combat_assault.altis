		// -----------------------------------------------
		// Author: team  code34 nicolas_boiteux@yahoo.fr
		// WARCONTEXT - Description: Handler for all enemy units
		// -----------------------------------------------	

		private ["_vehicle"];

		_vehicle = _this select 0;

		_vehicle addeventhandler ['HandleDamage', {
			private ["_name", "_gunner", "_commander"];
			if(side(_this select 3) in [west, civilian]) then {
				if ((_this select 2) > 0.4) then {
					(_this select 0) setHit [(_this select 1), (_this select 2)];
					(_this select 0) setdamage (damage (_this select 0) + (_this select 2));
					if(damage (_this select 0) > 0.9) then {
						(_this select 0) setdamage 1;
						(_this select 0) removeAllEventHandlers "HandleDamage";
					};
				};
			};
		}];
