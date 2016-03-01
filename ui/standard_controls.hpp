	class RscButton
	{
		access = 0;
		type = 1;
		style = ST_CENTER;
		text = "";
		colorText[] = {1,1,1,1}; 
		colorDisabled[] = {0.4,0.4,0.4,1};
		colorBackground[] = {0,0.4,0.8,0};
		colorBackgroundDisabled[] = {0.95,0.95,0.95,1};
		colorBackgroundActive[] = {0,0.4,0.8,0.4};
		colorFocused[] = {1,0.537,0,1};
		colorShadow[] = {0,0,0,0};
		colorBorder[] = {0,0,0,0};
		soundEnter[] = {"\ca\ui\data\sound\onover",0.09,1};
		soundPush[] = {"\ca\ui\data\sound\new1",0,0};
		soundClick[] = {"\ca\ui\data\sound\onclick",0.07,1};
		soundEscape[] = {"\ca\ui\data\sound\onescape",0.09,1};
		x = 0;
		y = 0;
		w = 0.095589;
		h = 0.039216;
		shadow = 2;
		sizeEx = 0.03;
		size = 0.03;
		offsetX = 0.003;
		offsetY = 0.003;
		offsetPressedX = 0.002;
		offsetPressedY = 0.002;
		borderSize = 0;
		font = "EtelkaNarrowMediumPro"; 
	};

	class StdButton {
	  	idc = -1;
		type = CT_BUTTON;
		style = ST_CENTER;
		default = false;
		font = FontM;
		sizeEx = 0.018 * safezoneH;
		colorText[] = { 0, 0, 0, 1 };
		colorFocused[] = { 1, 1, 1, 1 };
		colorDisabled[] = { 0.2, 0.2, 0.2, 0.7 };
		colorBackground[] = { 0.8, 0.8, 0.8, 0.8 };
		colorBackgroundDisabled[] = { 0.5, 0.5, 0.5, 0.5 };
		colorBackgroundActive[] = { 1, 1, 1, 1 };
		offsetX = 0.003;
		offsetY = 0.003;
		offsetPressedX = 0.002;
		offsetPressedY = 0.002;
		colorShadow[] = { 0, 0, 0, 0.5 };
		colorBorder[] = { 0, 0, 0, 1 };
		borderSize = 0;
		soundEnter[] = { "", 0, 1 };  // no sound
		soundPush[] = {"\a3\Ui_f\data\Sound\CfgIngameUI\hintExpand", 0.891251, 1};
		soundClick[] = { "", 0, 1 };  // no sound
		soundEscape[] = { "", 0, 1 };  // no sound
		x = 0.4 * safezoneW + safezoneX;
		w = 0.2 * safezoneW; h = 0.03 * safezoneH;
		text = "";
		action = "";
		shadow = 1;
	  };	

	class StdText {
		idc = -1;
		type =  CT_STATIC;
		style = ST_LEFT;
		colorText[] = COLOR_WHITE;
		colorBackground[] = COLOR_NOALPHA;
		font = FontM;
		sizeEx = 0.02 * safezoneH;
		shadow = 2;
		text = "";
	};

	class StdHeader : StdText {
	  	style = ST_CENTER;
	  	sizeEx = 0.03 * safezoneH;
		colorBackground[] = COLOR_LIGHTGRAY;
	};	

	class camo {
		idc = -1;
		type = CT_STATIC;
		style = ST_PICTURE;
		colorText[] = {0.5, 0.4, 0.25, 0.6};
		colorBackground[] = {0, 0, 0, 1};
		font = FontM;
		sizeEx = 0.023;
		moving = false;
		text = "pics\camo03.jpg";
	};

	class StdListBox {
		idc = -1;
		type = CT_LISTBOX;
		style = 0 + 0x10;
		font = FontM;
		sizeEx = 0.018 * safezoneH;
	    	rowHeight = 0.018 * safezoneH * 1.25;
		color[] = COLOR_LIGHTGRAY;
		colorText[] = COLOR_WHITE;
		colorScrollbar[] = COLOR_BRIGHTGREEN;
		colorSelect[] = COLOR_BRIGHTGREEN;
		colorSelect2[] = COLOR_BRIGHTGREEN;
		colorSelectBackground[] = COLOR_LIGHTGRAY;
		colorSelectBackground2[] = COLOR_LIGHTGRAY;
		colorActive[] = COLOR_BRIGHTGREEN;
		colorDisabled[] = COLOR_GREEN;
		columns[] = {0.1, 0.9};
		period = 0.3;
		colorBackground[] = COLOR_GREEN;
		maxHistoryDelay = 1.0;
		autoScrollSpeed = -1;
		autoScrollDelay = 5;
		autoScrollRewind = 0;
		soundSelect[] = {"\a3\Ui_f\data\Sound\CfgIngameUI\hintExpand", 0.09, 1};

		class ListScrollBar {
			color[] = {1, 1, 1, 0.6};
			colorActive[] = {1, 1, 1, 1};
			colorDisabled[] = {1, 1, 1, 0.3};
			thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
			arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
			arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
			border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
		};
	};

	class StdListBox2 {
		idc = -1;
		type = CT_LISTNBOX ;
		style = 0 + 0x10;
		font = FontM;
		sizeEx = 0.018 * safezoneH;
	    	rowHeight = 0.018 * safezoneH * 1.25;
		color[] = COLOR_LIGHTGRAY;
		colorText[] = COLOR_WHITE;
		colorScrollbar[] = COLOR_BRIGHTGREEN;
		colorSelect[] = COLOR_BRIGHTGREEN;
		colorSelect2[] = COLOR_BRIGHTGREEN;
		colorSelectBackground[] = COLOR_LIGHTGRAY;
		colorSelectBackground2[] = COLOR_LIGHTGRAY;
		colorActive[] = COLOR_BRIGHTGREEN;
		colorDisabled[] = COLOR_GREEN;
		columns[] = {0.1, 0.9};
		period = 0.3;
		colorBackground[] = COLOR_GREEN;
		maxHistoryDelay = 1.0;
		autoScrollSpeed = -1;
		autoScrollDelay = 5;
		autoScrollRewind = 0;
		drawSideArrows = 0;
                	idcLeft = -1;
                 	idcRight = -1;
		soundSelect[] = {"\a3\Ui_f\data\Sound\CfgIngameUI\hintExpand", 0.09, 1};

		class ListScrollBar {
			color[] = {1, 1, 1, 0.6};
			colorActive[] = {1, 1, 1, 1};
			colorDisabled[] = {1, 1, 1, 0.3};
			thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
			arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
			arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
			border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
		};
	};

	class StdCombo {
		idc = -1;
		type = 4;
		style = 1;
		x = 0;
		y = 0;
		w = 0.3;
		h = 0.035;
		colorSelect[] = COLOR_BRIGHTGREEN;
		colorText[] = COLOR_WHITE;
		colorBackground[] = COLOR_GREEN_NOALPHA;
		colorSelectBackground[] = COLOR_LIGHTGRAY;
		colorScrollbar[] = COLOR_BRIGHTGREEN;
		arrowEmpty ="\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
		arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
		wholeHeight = 0.45;
		color[] = COLOR_LIGHTGRAY;
		colorActive[] = COLOR_BRIGHTGREEN;
		colorDisabled[] = COLOR_GREEN;
		font = FontM;
		sizeEx = 0.031;
		soundSelect[] = {"\a3\Ui_f\data\Sound\CfgIngameUI\hintExpand", 0.09, 1};
		soundExpand[] = {"\a3\Ui_f\data\Sound\CfgIngameUI\hintExpand", 0.09, 1};
		soundCollapse[] = {"\a3\Ui_f\data\Sound\CfgIngameUI\hintExpand", 0.09, 1};
		maxHistoryDelay = 1.0;

		class ComboScrollBar {
			color[] = {1, 1, 1, 0.6};
			colorActive[] = {1, 1, 1, 1};
			colorDisabled[] = {1, 1, 1, 0.3};
			thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
			arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
			arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
			border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
		};
	};	

	class RscMapControl
	{
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
		ptsPerSquareSea = 5;
		ptsPerSquareTxt = 3;
		ptsPerSquareCLn = 10;
		ptsPerSquareExp = 10;
		ptsPerSquareCost = 10;
		ptsPerSquareFor = 9;
		ptsPerSquareForEdge = 9;
		ptsPerSquareRoad = 6;
		ptsPerSquareObj = 9;
		showCountourInterval = 0;
		scaleMin = 0.03;
		scaleMax = 0.4;
		scaleDefault = 0.2;
		maxSatelliteAlpha = 1;
		alphaFadeStartScale = 0.35;
		alphaFadeEndScale = 1;
		colorBackground[] = {0,0.4,0.8,0.4};
		colorText[] = {0.0,0.0,0.0,1.0};
		colorSea[] = {0.467,0.631,0.851,0.5};
		colorForest[] = {0.624,0.78,0.388,0.5};
		colorForestBorder[] = {0.0,0.0,0.0,0.0};
		colorRocks[] = {0.0,0.0,0.0,0.3};
		colorRocksBorder[] = {0.0,0.0,0.0,0.0};
		colorLevels[] = {0.286,0.177,0.094,0.5};
		colorMainCountlines[] = {0.572,0.354,0.188,0.5};
		colorCountlines[] = {0.572,0.354,0.188,0.25};
		colorMainCountlinesWater[] = {0.491,0.577,0.702,0.6};
		colorCountlinesWater[] = {0.491,0.577,0.702,0.3};
		colorPowerLines[] = {0.1,0.1,0.1,1.0};
		colorRailWay[] = {0.8,0.2,0.0,1.0};
		colorNames[] = {0.1,0.1,0.1,0.9};
		colorInactive[] = {1.0,1.0,1.0,0.5};
		colorOutside[] = {0.0,0.0,0.0,1.0};
		colorTracks[] = {0.84,0.76,0.65,0.15};
		colorTracksFill[] = {0.84,0.76,0.65,1.0};
		colorRoads[] = {0.7,0.7,0.7,1.0};
		colorRoadsFill[] = {1.0,1.0,1.0,1.0};
		colorMainRoads[] = {0.9,0.5,0.3,1.0};
		colorMainRoadsFill[] = {1.0,0.6,0.4,1.0};
		colorGrid[] = {0.1,0.1,0.1,0.6};
		colorGridMap[] = {0.1,0.1,0.1,0.6};
		fontLabel = "PuristaMedium";
		sizeExLabel = 0;
		fontGrid = "TahomaB";
		sizeExGrid = 0.02;
		fontUnits = "TahomaB";
		sizeExUnits = 0.1;
		fontNames = "PuristaMedium";
		sizeExNames = 0.1;
		fontInfo = "PuristaMedium";
		sizeExInfo = 0.1;
		fontLevel = "TahomaB";
		sizeExLevel = 0.02;
		text = "#(argb,8,8,3)color(1,1,1,1)";
		class Legend
		{
			x = "SafeZoneX +      (   ((safezoneW / safezoneH) min 1.2) / 40)";
			y = "SafeZoneY + safezoneH - 4.5 *      (   (   ((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			w = "10 *      (   ((safezoneW / safezoneH) min 1.2) / 40)";
			h = "3.5 *      (   (   ((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			font = "PuristaMedium";
			sizeEx = "(   (   (   ((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
			colorBackground[] = {1,1,1,0.5};
			color[] = {0,0,0,1};
		};
		class Task
		{
			icon = "\A3\ui_f\data\map\mapcontrol\taskIcon_CA.paa";
			iconCreated = "\A3\ui_f\data\map\mapcontrol\taskIconCreated_CA.paa";
			iconCanceled = "\A3\ui_f\data\map\mapcontrol\taskIconCanceled_CA.paa";
			iconDone = "\A3\ui_f\data\map\mapcontrol\taskIconDone_CA.paa";
			iconFailed = "\A3\ui_f\data\map\mapcontrol\taskIconFailed_CA.paa";
			color[] = {0,0.9,0,1};
			colorCreated[] = {1,1,1,1};
			colorCanceled[] = {0.7,0.7,0.7,1};
			colorDone[] = {0.7,1,0.3,1};
			colorFailed[] = {1,0.3,0.2,1};
			size = 27;
			importance = 1;
			coefMin = 1;
			coefMax = 1;
		};
		class Waypoint
		{
			icon = "\A3\ui_f\data\map\mapcontrol\waypoint_ca.paa";
			size = 20;
			color[] = {0,0.9,0,1};
			importance = "1.2 * 16 * 0.05";
			coefMin = 0.9;
			coefMax = 4;
		};
		class WaypointCompleted
		{
			icon = "\A3\ui_f\data\map\mapcontrol\waypointCompleted_ca.paa";
			size = 20;
			color[] = {0,0.9,0,1};
			importance = "1.2 * 16 * 0.05";
			coefMin = 0.9;
			coefMax = 4;
		};
		class ActiveMarker
		{
			icon = "\A3\ui_f\data\map\mapcontrol\waypointCompleted_ca.paa";
			size = 20;
			color[] = {0,0.9,0,1};
			importance = "1.2 * 16 * 0.05";
			coefMin = 0.9;
			coefMax = 4;
		};
		class CustomMark
		{
			icon = "\A3\ui_f\data\map\mapcontrol\custommark_ca.paa";
			size = 24;
			importance = 1;
			coefMin = 1;
			coefMax = 1;
			color[] = {0,0,0,1};
		};
		class Command
		{
			icon = "\A3\ui_f\data\map\mapcontrol\waypoint_ca.paa";
			size = 18;
			importance = 1;
			coefMin = 1;
			coefMax = 1;
			color[] = {1,1,1,1};
		};
		class Bush
		{
			icon = "\A3\ui_f\data\map\mapcontrol\bush_ca.paa";
			color[] = {0.45,0.64,0.33,0.4};
			size = "14/2";
			importance = "0.2 * 14 * 0.05 * 0.05";
			coefMin = 0.25;
			coefMax = 4;
		};
		class Rock
		{
			icon = "\A3\ui_f\data\map\mapcontrol\rock_ca.paa";
			color[] = {0.1,0.1,0.1,0.8};
			size = 12;
			importance = "0.5 * 12 * 0.05";
			coefMin = 0.25;
			coefMax = 4;
		};
		class SmallTree
		{
			icon = "\A3\ui_f\data\map\mapcontrol\bush_ca.paa";
			color[] = {0.45,0.64,0.33,0.4};
			size = 12;
			importance = "0.6 * 12 * 0.05";
			coefMin = 0.25;
			coefMax = 4;
		};
		class Tree
		{
			icon = "\A3\ui_f\data\map\mapcontrol\bush_ca.paa";
			color[] = {0.45,0.64,0.33,0.4};
			size = 12;
			importance = "0.9 * 16 * 0.05";
			coefMin = 0.25;
			coefMax = 4;
		};
		class busstop
		{
			icon = "\A3\ui_f\data\map\mapcontrol\busstop_CA.paa";
			size = 24;
			importance = 1;
			coefMin = 0.85;
			coefMax = 1.0;
			color[] = {1,1,1,1};
		};
		class fuelstation
		{
			icon = "\A3\ui_f\data\map\mapcontrol\fuelstation_CA.paa";
			size = 24;
			importance = 1;
			coefMin = 0.85;
			coefMax = 1.0;
			color[] = {1,1,1,1};
		};
		class hospital
		{
			icon = "\A3\ui_f\data\map\mapcontrol\hospital_CA.paa";
			size = 24;
			importance = 1;
			coefMin = 0.85;
			coefMax = 1.0;
			color[] = {1,1,1,1};
		};
		class church
		{
			icon = "\A3\ui_f\data\map\mapcontrol\church_CA.paa";
			size = 24;
			importance = 1;
			coefMin = 0.85;
			coefMax = 1.0;
			color[] = {1,1,1,1};
		};
		class lighthouse
		{
			icon = "\A3\ui_f\data\map\mapcontrol\lighthouse_CA.paa";
			size = 24;
			importance = 1;
			coefMin = 0.85;
			coefMax = 1.0;
			color[] = {1,1,1,1};
		};
		class power
		{
			icon = "\A3\ui_f\data\map\mapcontrol\power_CA.paa";
			size = 24;
			importance = 1;
			coefMin = 0.85;
			coefMax = 1.0;
			color[] = {1,1,1,1};
		};
		class powersolar
		{
			icon = "\A3\ui_f\data\map\mapcontrol\powersolar_CA.paa";
			size = 24;
			importance = 1;
			coefMin = 0.85;
			coefMax = 1.0;
			color[] = {1,1,1,1};
		};
		class powerwave
		{
			icon = "\A3\ui_f\data\map\mapcontrol\powerwave_CA.paa";
			size = 24;
			importance = 1;
			coefMin = 0.85;
			coefMax = 1.0;
			color[] = {1,1,1,1};
		};
		class powerwind
		{
			icon = "\A3\ui_f\data\map\mapcontrol\powerwind_CA.paa";
			size = 24;
			importance = 1;
			coefMin = 0.85;
			coefMax = 1.0;
			color[] = {1,1,1,1};
		};
		class quay
		{
			icon = "\A3\ui_f\data\map\mapcontrol\quay_CA.paa";
			size = 24;
			importance = 1;
			coefMin = 0.85;
			coefMax = 1.0;
			color[] = {1,1,1,1};
		};
		class shipwreck
		{
			icon = "\A3\ui_f\data\map\mapcontrol\shipwreck_CA.paa";
			size = 24;
			importance = 1;
			coefMin = 0.85;
			coefMax = 1.0;
			color[] = {1,1,1,1};
		};
		class transmitter
		{
			icon = "\A3\ui_f\data\map\mapcontrol\transmitter_CA.paa";
			size = 24;
			importance = 1;
			coefMin = 0.85;
			coefMax = 1.0;
			color[] = {1,1,1,1};
		};
		class watertower
		{
			icon = "\A3\ui_f\data\map\mapcontrol\watertower_CA.paa";
			size = 24;
			importance = 1;
			coefMin = 0.85;
			coefMax = 1.0;
			color[] = {1,1,1,1};
		};
		class Cross
		{
			icon = "\A3\ui_f\data\map\mapcontrol\Cross_CA.paa";
			size = 24;
			importance = 1;
			coefMin = 0.85;
			coefMax = 1.0;
			color[] = {0,0,0,1};
		};
		class Chapel
		{
			icon = "\A3\ui_f\data\map\mapcontrol\Chapel_CA.paa";
			size = 24;
			importance = 1;
			coefMin = 0.85;
			coefMax = 1.0;
			color[] = {0,0,0,1};
		};
		class Bunker
		{
			icon = "\A3\ui_f\data\map\mapcontrol\bunker_ca.paa";
			size = 14;
			importance = "1.5 * 14 * 0.05";
			coefMin = 0.25;
			coefMax = 4;
			color[] = {0,0,0,1};
		};
		class Fortress
		{
			icon = "\A3\ui_f\data\map\mapcontrol\bunker_ca.paa";
			size = 16;
			importance = "2 * 16 * 0.05";
			coefMin = 0.25;
			coefMax = 4;
			color[] = {0,0,0,1};
		};
		class Fountain
		{
			icon = "\A3\ui_f\data\map\mapcontrol\fountain_ca.paa";
			size = 11;
			importance = "1 * 12 * 0.05";
			coefMin = 0.25;
			coefMax = 4;
			color[] = {0,0,0,1};
		};
		class Ruin
		{
			icon = "\A3\ui_f\data\map\mapcontrol\ruin_ca.paa";
			size = 16;
			importance = "1.2 * 16 * 0.05";
			coefMin = 1;
			coefMax = 4;
			color[] = {0,0,0,1};
		};
		class Stack
		{
			icon = "\A3\ui_f\data\map\mapcontrol\stack_ca.paa";
			size = 20;
			importance = "2 * 16 * 0.05";
			coefMin = 0.9;
			coefMax = 4;
			color[] = {0,0,0,1};
		};
		class Tourism
		{
			icon = "\A3\ui_f\data\map\mapcontrol\tourism_ca.paa";
			size = 16;
			importance = "1 * 16 * 0.05";
			coefMin = 0.7;
			coefMax = 4;
			color[] = {0,0,0,1};
		};
		class ViewTower
		{
			icon = "\A3\ui_f\data\map\mapcontrol\viewtower_ca.paa";
			size = 16;
			importance = "2.5 * 16 * 0.05";
			coefMin = 0.5;
			coefMax = 4;
			color[] = {0,0,0,1};
		};
	};	