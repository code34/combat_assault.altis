class playergroup { 
	idd = -1; 
	movingEnable = true; 
	enableSimulation = false; 
	controlsBackground[] = { }; 
	objects[] = { }; 
	onLoad = "uiNamespace setVariable ['wcspawndialog', _this select 0];";
	controls[] = { background, labelgroup, playerlist, ejectbutton, closebutton };

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
		text = "Vehicle Deployment";
	};

	class playerlist : StdListBox {
		idc = 1255;
		x = 0.01;
		w = 0.98;
		y = 0.2;
		h = 0.68;
		shadow = 2;
		onLBSelChanged="";
	};

	class ejectbutton : StdButton {
		idc = -1; 
		x = 0.30;
		w = 0.15;
		y = 0.90;
		h = 0.05;
		text = "Cancel";
		action = "wcaction='cancel';closeDialog 0;";
	};		

	class closebutton : StdButton {
		idc = -1; 
		x = 0.6;
		w = 0.15;
		y = 0.90;
		h = 0.05;
		text = "Deploy";
		action = "wcaction = 'deploy';";
	};
};	