	wcairplayerstype = ["B_Pilot_F"];
	wcgroundplayerstype = ["B_Soldier_F", "B_crew_F", "B_medic_F"];
	
	switch (wcaccurencylevel) do {
		case 1 : {wcskill = 0.2;};
		case 2 : {wcskill = 0.3;};
		case 3:  {wcskill = 0.4;};
		case 4:  {wcskill = 0.5;};
		default {wcskill = 0.3;};
	};
	diag_log format ["COMBAT ASSAULT starts at: %1 %2 difficulty", wcskill, wcaccurencylevel];
