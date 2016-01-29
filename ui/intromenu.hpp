class intromenu {
	idd = -1;
	movingEnable = false;
	controls[] = { "logo", "start"};
	//controls[] = { "logo", "start", "arsenal", "options"};
	objects[] = {};

	class logo {
		idc = -1;
		type =  CT_STATIC ;
		style = ST_PICTURE;
		colorText[] = COLOR_WHITE;
		colorBackground[] = COLOR_NOALPHA;
		font = FontM;
		sizeEx = 0.1 * safezoneH;
		x = 0.34 * safezoneW + safezoneX;
		w = 0.27 * safezoneW;
		y = 0.23 * safezoneH + safezoneY;
		h = 0.25 * safezoneH;
		text = "pics\logo.paa";
	};

	class start : StdButton {
		idc = -1; 
		x = 0.40* safezoneW + safezoneX;
		w = (0.15 * safezoneW);
		y = 0.50 * safezoneH + safezoneY;
		h = (0.025 * safezoneH);
		text = "Start a New Game";
		action = "closeDialog 0;";
	};

	//class arsenal : StdButton {
	//	idc = -1; 
	//	x = 0.40* safezoneW + safezoneX;
	//	w = (0.15 * safezoneW);
	//	y = 0.54 * safezoneH + safezoneY;
	//	h = (0.025 * safezoneH);
	//	text = "Load a game";
	//	action = "wcaction = 'equipment';";
	//};			

	//class options : StdButton {
	//	idc = -1; 
	//	x = 0.40* safezoneW + safezoneX;
	//	w = (0.15 * safezoneW);
	//	y = 0.58 * safezoneH + safezoneY;
	//	h = (0.025 * safezoneH);
	//	text = "Options";
	//	action = "wcaction = 'equipment';";
	//};	

};