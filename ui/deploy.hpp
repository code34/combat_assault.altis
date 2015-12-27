class spawndialog { 
	idd = -1; 
	movingEnable = true; 
	enableSimulation = false; 
	controlsBackground[] = { }; 
	objects[] = { }; 
	controls[] = { column, map, title, labelrole, role, labelplayer, player, deploy, mapbutton, playername, previous, next, rollmessage, equipment}; 
	onLoad = "uiNamespace setVariable ['wcspawndialog', _this select 0];";

	class column : camo {
		idc=-1;
		x = (0.15 * safezoneW + safezoneX) - ( 2 * BORDERSIZE);
		y = (0.12 * safezoneH + safezoneY) - (3 * BORDERSIZE);
		w = (0.15 * safezoneW) + (4 * BORDERSIZE);
		h = (0.75 * safezoneH) + (6 * BORDERSIZE);
	};

	class map : RscMapControl {
		idc=-1;
		x = (0.15 * safezoneW + safezoneX);
		y = (0.57 * safezoneH + safezoneY);
		w = (0.15 * safezoneW);
		h = (0.25 * safezoneH) - ( 1.5 * BORDERSIZE);
	};	
	
	class title : StdHeader{
		idc=-1;
		x = 0.15 * safezoneW + safezoneX - (BORDERSIZE);
		y = 0.11 * safezoneH + safezoneY;
		w = 0.15 * safezoneW + ( 2 * BORDERSIZE);
		h = 0.05 * safezoneH - (BORDERSIZE);
		text = $STR_REDEPLOY_TITLE;
	};

	class labelrole : StdText{
		idc=-1;
		x = (0.15 * safezoneW + safezoneX);
		w = (0.15 * safezoneW);
		h = (0.03 * safezoneH);
		y = 0.16 * safezoneH + safezoneY;
		sizeEx = 0.018 * safezoneH;
		text = $STR_DEPLOY_SELECTROLE;
	};
	class role : StdCombo{
		idc = 2001;
		x = (0.15 * safezoneW + safezoneX);
		w = 0.15 * safezoneW;
		y = 0.19 * safezoneH + safezoneY;
		h = 0.03 * safezoneH;
		sizeEx = 0.018 * safezoneH;
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
		h = (0.31 * safezoneH) - (1.5 * BORDERSIZE);
		shadow = 2;
		onLBSelChanged="";
	};

	class deploy : StdButton{
		idc=-1;
		x = (0.15 * safezoneW + safezoneX);
		y = (0.82 * safezoneH + safezoneY);
		w = (0.15 * safezoneW);
		h = (0.05 * safezoneH);
		sizeEx = 0.05 * safezoneH;
		text = $STR_DEPLOY_BUTTON;
		action = "closeDialog 0; wcaction = 'deploy';";
	};

	class mapbutton : StdButton{
		idc=-1;
		x = (0.285 * safezoneW + safezoneX);
		y = (0.56 * safezoneH + safezoneY);
		w = (0.015 * safezoneW);
		h = (0.025 * safezoneH);
		sizeEx = 0.018 * safezoneH;
		text = "Extend";
		action = "fullmap = fullmap + 1;";
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
};