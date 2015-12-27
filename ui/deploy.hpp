class spawndialog { 
	idd = -1; 
	movingEnable = true; 
	enableSimulation = false; 
	controlsBackground[] = { }; 
	objects[] = { }; 
	controls[] = { map, deploy, playername, previous, next, rollmessage, equipment, infotext, background, infantry2, infantry, tank2, tank, tankaa2, tankaa, bomber2, bomber, fighter2, fighter, chopper2, chopper, achopper2, achopper}; 
	onLoad = "uiNamespace setVariable ['wcspawndialog', _this select 0];";

	class infotext {
		idc = -1; 
		type = CT_STRUCTURED_TEXT; 
		style = ST_VCENTER; 		
		x = -0.05; 
		y = -0.045; 
		w = 1.05; 
		h = 0.04; 
		text = "<t align='center'>SELECT YOUR ROLE</t>";
		font = "EtelkaNarrowMediumPro"; 
		size = 0.038; 
		colorBackground[] = {0,0,0,0.6}; 
		colorText[] = {0.5,1,1,1}; 		
	};

	class background {
		idc = -1; 
		type = CT_STRUCTURED_TEXT; 
		style = ST_VCENTER; 		
		x = -0.05; 
		y = 0; 
		w = 1.05; 
		h = 0.2; 
		text = "";
		font = "EtelkaNarrowMediumPro"; 
		size = 0.038; 
		colorBackground[] = {0,0,0,0.6}; 
		colorText[] = {0.5,1,1,1}; 		
	};

	class infantry : RscButton
	{
		idc = -1; 
		x = -0.05; 
		y = 0; 
		w = 0.15; 
		h = 0.2; 
		text = "INFANTRY";
		action = "playertype ='ammobox'; ";
		colorBackground[] = {0,0,0,0};
	};

	class infantry2 { 
		idc = -1; 
		type = CT_STATIC;
		style = ST_TILE_PICTURE; 
		x = -0.05; 
		y = 0; 
		w = 0.15; 
		h = 0.2; 
		font = "EtelkaNarrowMediumPro"; 
		size = 0.035;
		colorBackground[] = {0,0.4,0.8,0.4};
		colorText[] = {1,1,1,1}; 
		text = "\A3\Ui_f\data\IGUI\RscIngameUI\RscUnitInfo\SI_stand_ca.paa"; 
		sizeEx = 0;
	}; 	

	class tank : RscButton
	{
		idc = -1; 
		x = 0.10; 
		y = 0; 
		w = 0.15; 
		h = 0.2; 
		text = "TANK";
		action = "playertype ='tank'; ";
		colorBackground[] = {0,0,0,0};
	};

	class tank2 { 
		idc = -1; 
		type = CT_STATIC;
		style = ST_TILE_PICTURE; 
		x = 0.10; 
		y = 0; 
		w = 0.15; 
		h = 0.2; 
		font = "EtelkaNarrowMediumPro"; 
		size = 0.035;
		colorBackground[] = {0,0.4,0.8,0.2};
		colorText[] = {1,1,1,1}; 
		text = "\A3\armor_f_gamma\MBT_01\Data\ui\map_slammer_mk4_ca.paa"; 
		sizeEx = 0;
	}; 	

	class tankaa : RscButton
	{
		idc = -1; 
		x = 0.25; 
		y = 0; 
		w = 0.15; 
		h = 0.2; 
		text = "TANK AA";
		action = "playertype ='tankaa'; ";
		colorBackground[] = {0,0,0,0};
	};

	class tankaa2 { 
		idc = -1; 
		type = CT_STATIC;
		style = ST_TILE_PICTURE; 
		x = 0.25; 
		y = 0; 
		w = 0.15; 
		h = 0.2; 
		font = "EtelkaNarrowMediumPro"; 
		size = 0.035;
		colorBackground[] = {0,0.4,0.8,0.2};
		colorText[] = {1,1,1,1}; 
		text = "\A3\armor_f_beta\APC_Tracked_01\Data\ui\map_APC_Tracked_01_aa_ca.paa"; 
		sizeEx = 0;
	}; 	

	class bomber : RscButton
	{
		idc = -1; 
		x = 0.40; 
		y = 0; 
		w = 0.15; 
		h = 0.2; 
		text = "BOMBER";
		action = "playertype ='bomber'; ";
		colorBackground[] = {0,0,0,0};
	};

	class bomber2 { 
		idc = -1; 
		type = CT_STATIC;
		style = ST_TILE_PICTURE; 
		x = 0.40; 
		y = 0; 
		w = 0.15; 
		h = 0.2; 
		font = "EtelkaNarrowMediumPro"; 
		size = 0.035;
		colorBackground[] = {0,0.4,0.8,0.2};
		colorText[] = {1,1,1,1}; 
		text = "\A3\Air_F_EPC\Plane_CAS_01\Data\UI\Map_Plane_CAS_01_CA.paa"; 
		sizeEx = 0;
	}; 	

	class fighter : RscButton
	{
		idc = -1; 
		x = 0.55; 
		y = 0; 
		w = 0.15; 
		h = 0.2; 
		text = "FIGHTER";
		action = "playertype ='fighter'; ";
		colorBackground[] = {0,0,0,0};
	};

	class fighter2 { 
		idc = -1; 
		type = CT_STATIC;
		style = ST_TILE_PICTURE; 
		x = 0.55; 
		y = 0; 
		w = 0.15; 
		h = 0.2; 
		font = "EtelkaNarrowMediumPro"; 
		size = 0.035;
		colorBackground[] = {0,0.4,0.8,0.2};
		colorText[] = {1,1,1,1}; 
		text = "\A3\Air_F_Gamma\Plane_Fighter_03\Data\UI\Map_Plane_Fighter_03_CA.paa"; 
		sizeEx = 0;
	}; 

	class chopper : RscButton
	{
		idc = -1; 
		x = 0.70; 
		y = 0; 
		w = 0.15; 
		h = 0.2; 
		text = "CHOPPER";
		action = "playertype ='chopper'; ";
		colorBackground[] = {0,0,0,0};
	};

	class chopper2 { 
		idc = -1; 
		type = CT_STATIC;
		style = ST_TILE_PICTURE; 
		x = 0.70; 
		y = 0; 
		w = 0.15; 
		h = 0.2; 
		font = "EtelkaNarrowMediumPro"; 
		size = 0.035;
		colorBackground[] = {0,0.4,0.8,0.2};
		colorText[] = {1,1,1,1}; 
		text = "\A3\air_f_beta\Heli_Transport_01\Data\UI\Map_Heli_Transport_01_base_CA.paa"; 
		sizeEx = 0;
	}; 

	class achopper : RscButton
	{
		idc = -1; 
		x = 0.85; 
		y = 0; 
		w = 0.15; 
		h = 0.2; 
		text = "ACHOPPER";
		action = "playertype ='achopper'; ";
		colorBackground[] = {0,0,0,0};
	};

	class achopper2 { 
		idc = -1; 
		type = CT_STATIC;
		style = ST_TILE_PICTURE; 
		x = 0.85; 
		y = 0; 
		w = 0.15; 
		h = 0.2; 
		font = "EtelkaNarrowMediumPro"; 
		size = 0.035;
		colorBackground[] = {0,0.4,0.8,0.2};
		colorText[] = {1,1,1,1}; 
		text = "\A3\Air_F_Beta\Heli_Attack_01\Data\UI\Map_Heli_Attack_01_CA.paa"; 
		sizeEx = 0;
	}; 		

	class previous : RscButton
	{
		idc = -1; 
		x = -0.005; 
		y = safezoneY + safezoneh - 0.03 - 0.05;
		w = 0.2; 
		h = 0.05; 
		text = "<< PREVIOUS";
		action = "wcaction = 'prev';";
		colorBackground[] = {0,0,0,0.8};
		font = "EtelkaNarrowMediumPro"; 
		sizeex= 0.03; 		
	};

	class playername
	{
		idc = 4004; 
		type = CT_STRUCTURED_TEXT; 
		style = ST_LEFT;  		
		x = 0.2; 
		y = safezoneY + safezoneh - 0.03 - 0.05;
		w = 0.35; 
		h = 0.05; 
		text = "<t align='center' color='#FF9933'>MAP</t>";
		action = "";
		colorBackground[] = {0,0,0,0.8};
		font = "EtelkaNarrowMediumPro"; 
		size = 0.038; 
	};	

	class next : RscButton
	{
		idc = -1; 
		x = 0.555; 
		y = safezoneY + safezoneh - 0.03 - 0.05; 
		w = 0.2; 
		h = 0.05; 
		text = "NEXT >>";
		action = "wcaction = 'next';";
		colorBackground[] = {0,0,0,0.8};
		font = "EtelkaNarrowMediumPro"; 
		sizeex= 0.03; 
	};

	class rollmessage : RscButton
	{
		idc = 4005; 
		x = 0.80; 
		y = safezoneY + safezoneh - 0.03 - 0.17;
		w = 0.2; 
		h = 0.05; 
		text = "ROLLMESSAGE ON";
		action = "wcaction = 'rollmessage';";
		colorBackground[] = {0,0,0,0.8};
	};				

	class equipment : RscButton
	{
		idc = -1; 
		x = 0.80; 
		y = safezoneY + safezoneh - 0.03 - 0.11;
		w = 0.2; 
		h = 0.05; 
		text = "EQUIPMENT";
		action = "wcaction = 'equipment';";
		colorBackground[] = {0,0,0,0.8};
	};

	class deploy : RscButton
	{
		idc = -1; 
		x = 0.80; 
		y = safezoneY + safezoneh - 0.03 - 0.05;
		w = 0.2; 
		h = 0.05; 
		text = "DEPLOY";
		action = "closeDialog 0; wcaction = 'deploy';";
		colorBackground[] = {0,0,0,0.8};
	};

	class map : RscMapControl
	{
		idc = 4006;
		type = 101;
		style = 48;
		sizeEx = 0.026;
		moveOnEdges = 1;
		x = safezoneX + 0.02;
		y = safezoneY + safezoneh - 0.03 - 0.55;
		w = 0.55 * 3/4;
		h = 0.55;
		font = "PuristaMedium";
		shadow = "false";
	};	
};