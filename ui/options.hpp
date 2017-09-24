class options { 
	idd = -1; 
	movingEnable = true; 
	enableSimulation = false; 
	controlsBackground[] = { }; 
	objects[] = { }; 
	onLoad = "uiNamespace setVariable ['wcspawndialog', _this select 0];";
	controls[] = { background, labelgroup, playerlist, playerlist2, addbutton, removebutton, labelplayer, labelfriend, closebutton };

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
		text = "Options";
	};

	class labelplayer : StdHeader{
		idc=-1;
		x = 0.01;
		w = 0.48;
		y = 0.2;
		h = 0.09;
		sizeEx = 0.05;
		text = "Players";
	};	

	class labelfriend : StdHeader{
		idc=-1;
		x = 0.50;
		w = 0.48;
		y = 0.2;
		h = 0.09;
		sizeEx = 0.05;
		text = "Friends";
	};

	class closebutton : StdButton {
		idc = -1; 
		x = 0.8;
		w = 0.15;
		y = 0.90;
		h = 0.05;
		text = "Close";
		action = "closedialog 0;";
	};	
};	