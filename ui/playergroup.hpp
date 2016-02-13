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

	class labelgroup : StdText{
		idc = -1;
		x = 0.01;
		w = 0.8;
		y = 0.02;
		h = 0.16;
		sizeEx = 0.12;
		text = "Buddy List";
	};

	class playerlist : StdListBox {
		idc = -1;
		x = 0.01;
		w = 0.3;
		y = 0.2;
		h = 0.78;
		shadow = 2;
		onLBSelChanged="";
	};

	class ejectbutton : StdButton {
		idc = -1; 
		x = 0.5;
		w = 0.15;
		y = 0.90;
		h = 0.05;
		text = "Eject";
		action = "wcaction = 'equipment';";
	};		

	class closebutton : StdButton {
		idc = -1; 
		x = 0.7;
		w = 0.15;
		y = 0.90;
		h = 0.05;
		text = "Close";
		action = "closeDialog 0;";
	};			

};	