	if(wcearplugs) then {
		wcearplugs = false;
		0 fadeSound 1;
		hint localize "STR_EARPLUGSOFF_TEXT"
	} else {
		wcearplugs = true;
		0 fadeSound 0.25;
		hint localize "STR_EARPLUGSON_TEXT"
	};


	

