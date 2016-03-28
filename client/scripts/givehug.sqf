		private ["_players", "_player", "_friends", "_index"];

		createDialog "huglist";
		
		_players = [];
		_friends = wcfriendlist;
		
		{
			if((_x != player) and !((name _x) in _friends)) then {
				_players = _players + [name _x];
				lbAdd [1500, name _x];
			};
		}foreach allplayers;

		{
			lbAdd [1501, _x];
		}foreach wcfriendlist;

		while { dialog} do {
			if(wcaction isEqualTo "add") then {
				_index = (lbCurSel 1500);
				if!(_index == -1) then {
					_player = (_players select _index);				
					_players = _players - [_player];
					_friends = _friends + [_player];
					lbDelete [1500, _index];
					lbAdd [1501, _player];
				};

				wcaction = "";
			};

			if(wcaction isEqualTo "remove") then {
				_index = (lbCurSel 1501);
				if!(_index == -1) then {
					_player = (_friends select _index);
					_players = _players + [_player];
					_friends = _friends - [_player];
					lbDelete [1501, _index];
					lbAdd [1500, _player];
				};
				wcaction = "";
			};
			sleep 0.01;
		};


		{
			["addPlayer",  _x] call playersmarkers;
		}foreach _friends;

		{
			["removePlayer",  _x] call playersmarkers;
		}foreach _players;

		wcfriendlist = _friends;