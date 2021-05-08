class RscTitles { 
	class bottomhud { 
		idd = -1; 
		duration = 100000000; 
		onLoad = "uiNamespace setVariable ['wcdisplay', _this select 0];";
		fadein = 0;
		fadeout = 0;
		class controls {
			class killzone { 
				idc = 999; 
				type = CT_STRUCTURED_TEXT; 
				style = ST_CENTER; 
				x = 0; 
				y = 0;
				w = 1;
				h = 0.05;
				font = "EtelkaNarrowMediumPro"; 
				size = 0.05;
				colorBackground[] = {0,0,0,0}; 
				colorText[] = {0.3,1,1,0.7}; 
				text = ""; 
			}; 

			class combatcrew { 
				idc = 1000; 
				type = CT_STRUCTURED_TEXT; 
				style = ST_VCENTER; 
				x = safeZoneX + safeZoneW - 0.4 * 3 / 4; 
				y = safeZoneY + safeZoneH - 0.4 * 4/3;
				w = 0.38 * 3 / 4;
				h = 0.15 * 4/3;
				font = "EtelkaNarrowMediumPro"; 
				size = 0.04;
				colorBackground[] = {0,0,0,0.4}; 
				colorText[] = {0.3,1,1,0.7}; 
				text = ""; 
			}; 

			class infohud { 
				idc = 1004; 
				type = CT_STRUCTURED_TEXT; 
				style = ST_LEFT; 
				shadow = 1;

				x = safeZoneX + safeZoneW - 0.45;
				y = safeZoneY + safeZoneH - 0.25;
				w = 0.45;
				h = 0.25;

				font = "EtelkaNarrowMediumPro"; 
				size = 0.035;
				//colorBackground[] = {0,0.4,0.8,0.4};
				colorBackground[] = {0,0,0,0.4};
				colorText[] = {0.5,1,1,1}; 
				text = ""; 
			}; 

			class killM { 
				idc = 1018; 
				type = CT_STRUCTURED_TEXT; 
				style = ST_CENTER; 
				x = safeZoneX + safeZoneW - 0.45; 
				y = safeZoneY + safeZoneH - 0.29;
				w = 0.05;
				h = 0.04;
				font = "EtelkaNarrowMediumPro"; 
				size = 0.03;
				colorBackground[] = {0,0.4,0.8,0.6};
				colorText[] = {0.5,1,1,1}; 
				text = ""; 
			}; 

			class deathM { 
				idc = 1019; 
				type = CT_STRUCTURED_TEXT; 
				style = ST_CENTER; 
				x = safeZoneX + safeZoneW - 0.401; 
				y = safeZoneY + safeZoneH - 0.29;
				w = 0.05;
				h = 0.04;
				font = "EtelkaNarrowMediumPro"; 
				size = 0.03;
				colorBackground[] = {1,0,0,0.6}; 
				colorText[] = {0.5,1,1,1}; 
				text = ""; 
			};

			class rollmessage { 
				idc = 1005; 
				type = CT_STRUCTURED_TEXT; 
				style = ST_LEFT;  
				x = safezoneX + SafezoneW - 0.01 - 0.44; 
				y = 0.4;
				w = 0.44;
				h = 0.3;
				font = "EtelkaNarrowMediumPro"; 
				size = 0.03;
				colorBackground[] = {0,0,0,0};
				colorText[] = {0.5,1,1,1}; 
				text = ""; 
			}; 

			class scoreboard_title { 
				idc = 1016; 
				type = CT_STRUCTURED_TEXT; 
				style = ST_CENTER; 
				x = -0.004; 
				y = -0.001;
				w = 1.008;
				h = 1.01;
				font = "EtelkaNarrowMediumPro"; 
				size = 0.1;
				colorBackground[] = {0,0,0,0.5};
				colorText[] = {0.5,1,1,1}; 
				text = ""; 
			};

			class scoreboard_background { 
				idc = 1007; 
				type = CT_STRUCTURED_TEXT; 
				style = ST_LEFT;  
				x = 0; 
				y = 0.1;
				w = 1;
				h = 0.9;
				font = "EtelkaNarrowMediumPro"; 
				size = 0.03;
				colorBackground[] = {0.9,0.9,0.9,0.1};
				colorText[] = {0,0.4,0.8,0.2}; 
				text = ""; 
				sizeEx = 0;
			};

			class scoreboard_subtitle1 { 
				idc = 1009; 
				type = CT_STRUCTURED_TEXT; 
				style = ST_LEFT;   
				x = 0; 
				y = 0.1;
				w = 0.05;
				h = 0.9;
				font = "EtelkaNarrowMediumPro"; 
				size = 0.03;
				colorBackground[] = {0,0,0,0.2};
				colorText[] = {0.5,1,1,1}; 
				text = "Top"; 
			};

			class scoreboard_subtitle2 { 
				idc = 1010; 
				type = CT_STRUCTURED_TEXT; 
				style = ST_LEFT; 
				x = 0.05 ; 
				y = 0.1;
				w = 0.25;
				h = 0.9;
				font = "EtelkaNarrowMediumPro"; 
				size = 0.03;
				colorBackground[] = {0,0,0,0.2};
				colorText[] = {0.5,1,1,1}; 
				text = "Player Name"; 
			};

			class scoreboard_subtitle3 { 
				idc = 1011; 
				type = CT_STRUCTURED_TEXT; 
				style = ST_LEFT; 
				x = 0.3; 
				y = 0.1;
				w = 0.2;
				h = 0.9;
				font = "EtelkaNarrowMediumPro"; 
				size = 0.03;
				colorBackground[] = {0,0,0,0.2};
				colorText[] = {0.5,1,1,1}; 
				text = "Game Ranking"; 
			};

			class scoreboard_subtitle4 { 
				idc = 1012; 
				type = CT_STRUCTURED_TEXT; 
				style = ST_LEFT; 
				x = 0.5 ; 
				y = 0.1 ;
				w = 0.2 ;
				h = 0.9;
				font = "EtelkaNarrowMediumPro"; 
				size = 0.03;
				colorBackground[] = {0,0,0,0.2};
				colorText[] = {0.5,1,1,1}; 
				text = "Server Ranking"; 
			};

			class scoreboard_subtitle5 { 
				idc = 1013; 
				type = CT_STRUCTURED_TEXT; 
				style = ST_LEFT; 
				x = 0.7; 
				y = 0.1;
				w = 0.1;
				h = 0.9;
				font = "EtelkaNarrowMediumPro"; 
				size = 0.03;
				colorBackground[] = {0,0,0,0.2};
				colorText[] = {0.5,1,1,1}; 
				text = "Matchs"; 
			};

			class scoreboard_subtitle6 { 
				idc = 1014; 
				type = CT_STRUCTURED_TEXT; 
				style = ST_LEFT; 
				x = 0.801; 
				y = 0.1;
				w = 0.2;
				h = 0.9;
				font = "EtelkaNarrowMediumPro"; 
				size = 0.03;
				colorBackground[] = {0,0,0,0.2};
				colorText[] = {0.5,1,1,1}; 
				text = "Score"; 
			};
		};
	}; 	
};