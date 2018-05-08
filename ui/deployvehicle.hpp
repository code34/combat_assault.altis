class deployvehicle { 
	idd = -1; 
	movingEnable = true; 
	enableSimulation = false; 
	controlsBackground[] = { }; 
	objects[] = { }; 
	onLoad = "uiNamespace setVariable ['wcspawndialog', _this select 0];";
	controls[] = { background, labelgroup, playerlist, description, ejectbutton, closebutton };

	class background : camo {
		idc = -1; 
		x = 0; 
		y = 0;
		w = 1;
		h = 1;
	}; 

	class labelgroup : StdHeader{
		idc = -1;
		x = 0.01;
		w = 0.98;
		y = 0.02;
		h = 0.16;
		sizeEx = 0.05;
		text = $STR_VEHICLESSERVICING_TITLE;
	};

	class playerlist : StdListBox {
		idc = 1255;
		x = 0.01;
		w = 0.50;
		y = 0.2;
		h = 0.68;
		shadow = 2;
		onLBSelChanged="";
	};

	class description : StdText{
		idc = 1256;
		style = ST_MULTI;
		lineSpacing = 1;
		x = 0.51;
		w = 0.40;
		y = 0.2;
		h = 0.68;
		sizeEx = 0.018 * safezoneH;
		text = "";
	};	

	class ejectbutton : StdButton {
		idc = -1; 
		x = 0.60;
		w = 0.15;
		y = 0.90;
		h = 0.05;
		text = $STR_CANCEL_BUTTON;
		action = "wcaction='cancel';closeDialog 0;";
	};		

	class closebutton : StdButton {
		idc = -1; 
		x = 0.8;
		w = 0.15;
		y = 0.90;
		h = 0.05;
		text = $STR_SEND_BUTTON;
		action = "wcaction = 'deploy';";
	};
};	