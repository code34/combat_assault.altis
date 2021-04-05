class spawndialog { 
	idd = -1; 
	movingEnable = true; 
	enableSimulation = false; 
	controlsBackground[] = { }; 
	objects[] = { }; 
	controls[] = { column, map, title, labelplayer, player, deploy, exit, mapbutton, rollmessage, equipment, friendsmanagement, unittags}; 
	onLoad = "uiNamespace setVariable ['wcspawndialog', _this select 0];";

	class column : camo {
		idc=2004;
		x = (0.15 * safezoneW + safezoneX) - ( 2 * BORDERSIZE);
		y = (0.12 * safezoneH + safezoneY) - (3 * BORDERSIZE);
		w = (0.15 * safezoneW) + (4 * BORDERSIZE);
		h = (0.80 * safezoneH) + (6 * BORDERSIZE);
	};

	class map : RscMapControl {
		idc= 2003;
		x = (0.15 * safezoneW + safezoneX) - ( 2 * BORDERSIZE) + (0.15 * safezoneW) + (4 * BORDERSIZE);
		y = (0.12 * safezoneH + safezoneY) - (3 * BORDERSIZE);
		w = (0.6 * safezoneW);
		h = (0.80 * safezoneH) + (6 * BORDERSIZE);
		onMouseButtonClick = "_this call WC_fnc_newdeployment";
	};	
	
	class title : StdHeader{
		idc=-1;
		x = 0.15 * safezoneW + safezoneX - (BORDERSIZE);
		y = 0.11 * safezoneH + safezoneY;
		w = 0.15 * safezoneW + ( 2 * BORDERSIZE);
		h = 0.05 * safezoneH - (BORDERSIZE);
		text = $STR_REDEPLOY_TITLE;
	};

	class labelplayer : StdText{
		idc=-1;
		x = (0.15 * safezoneW + safezoneX);
		w = (0.15 * safezoneW);
		h = (0.03 * safezoneH);
		y = 0.23 * safezoneH + safezoneY;
		sizeEx = 0.018 * safezoneH;
		text = $STR_DEPLOY_SELECTLOCATION;
	};

	class player : StdListBox {
		idc = 2002;
		x = 0.15 * safezoneW + safezoneX;
		w = 0.15 * safezoneW;
		y = 0.26 * safezoneH + safezoneY;
		h = (0.15 * safezoneH) - (1.5 * BORDERSIZE);
		shadow = 2;
		onLBSelChanged="";
	};

	class friendsmanagement : StdButton {
		idc = 2007; 
		x = (0.15 * safezoneW + safezoneX);
		w = (0.15 * safezoneW);
		y = (0.45 * safezoneH + safezoneY);
		h = (0.025 * safezoneH);
		text = $STR_FRIENDSMARKERSON_BUTTON;
		action = "wcaction = 'friendsmanagement';";
	};

	class equipment : StdButton {
		idc = -1; 
		x = (0.15 * safezoneW + safezoneX);
		w = (0.15 * safezoneW);
		y = (0.48 * safezoneH + safezoneY);
		h = (0.025 * safezoneH);
		text = "Arsenal";
		action = "wcaction = 'equipment';";
	};	

	class rollmessage : StdButton {
		idc = 2005;
		x = (0.15 * safezoneW + safezoneX);
		w = (0.15 * safezoneW);
		y = (0.51 * safezoneH + safezoneY);
		h = (0.025 * safezoneH);
		text = $STR_ROLLMESSAGEON_BUTTON;
		action = "wcaction = 'rollmessage';";
	};	

	class mapbutton : StdButton{
		idc=2006;
		x = (0.15 * safezoneW + safezoneX);
		w = (0.15 * safezoneW);
		y = (0.54 * safezoneH + safezoneY);
		h = (0.025 * safezoneH);
		sizeEx = 0.018 * safezoneH;
		text = $STR_HIDEMAP_BUTTON;
		action = "fullmap = fullmap + 1;";
	};	

	class unittags : StdButton{
		idc=2009;
		x = (0.15 * safezoneW + safezoneX);
		w = (0.15 * safezoneW);
		y = (0.57 * safezoneH + safezoneY);
		h = (0.025 * safezoneH);
		sizeEx = 0.018 * safezoneH;
		text = $STR_UNITTAGOFF_BUTTON;
		action = "wcaction = 'unittags';";
	};	

	class deploy : StdButton{
		idc=2008;
		x = (0.15 * safezoneW + safezoneX);
		y = (0.82 * safezoneH + safezoneY);
		w = (0.15 * safezoneW);
		h = (0.05 * safezoneH);
		sizeEx = 0.05 * safezoneH;
		text = $STR_DEPLOY_BUTTON;
		action = "wcaction = 'deploy';";
	};

	class exit : StdButton{
		idc=-1;
		x = (0.15 * safezoneW + safezoneX);
		y = (0.88 * safezoneH + safezoneY);
		w = (0.15 * safezoneW);
		h = (0.05 * safezoneH);
		sizeEx = 0.05 * safezoneH;
		text = $STR_EXIT_BUTTON;
		action = "closeDialog 0; wcaction = 'exit';";
	};	
};