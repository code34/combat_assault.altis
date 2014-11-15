	wcairplayerstype = ["B_Pilot_F"];
	wcgroundplayerstype = ["B_Soldier_F", "B_crew_F", "B_medic_F"];
	
	switch (wcaccurencylevel) do {
		case 1 : {wclevel = "novice";};
		case 2 : {wclevel = "recruit";};
		case 3 : {wclevel = "veteran";};
		case 4 : {wclevel = "cheated";};
		default {wclevel = "novice";};
	};
	diag_log format ["COMBAT ASSAULT starts at: %1 %2 difficulty", wclevel, wcaccurencylevel];
