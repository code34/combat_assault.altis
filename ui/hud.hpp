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

			class health { 
				idc = 1001; 
				type = CT_STRUCTURED_TEXT; 
				style = ST_VCENTER; 
				shadow = 1;
				x = safeZoneX + safeZoneW - 0.3 * 3 / 4; 
				y = safeZoneY + safeZoneH - 0.24 * 4/3;
				w = 0.08 * 3 / 4;
				h = 0.03 * 4/3;
				font = "EtelkaNarrowMediumPro"; 
				size = 0.038;
				colorBackground[] = {1,0,0,1}; 
				colorText[] = {0.5,1,1,1}; 
				text = ""; 
			}; 

			class stamina { 
				idc = 1002; 
				type = CT_STRUCTURED_TEXT; 
				style = ST_VCENTER; 
				shadow = 1;
				x = safeZoneX + safeZoneW - 0.2 * 3 / 4; 
				y = safeZoneY + safeZoneH - 0.24 * 4/3;
				w = 0.08 * 3 / 4;
				h = 0.03 * 4/3;
				font = "EtelkaNarrowMediumPro"; 
				size = 0.038; 
				colorBackground[] = {0,1,0, 1}; 
				colorText[] = {0.5,1,1,1}; 
				text = ""; 
			}; 	

			class infohud { 
				idc = 1004; 
				type = CT_STRUCTURED_TEXT; 
				style = ST_LEFT; 
				shadow = 1;
				x = safeZoneX + safeZoneW - 0.59 * 3 / 4; 
				y = safeZoneY + safeZoneH - 0.20 * 4/3;
				w = 0.58 * 3 / 4;
				h = 0.19 * 4/3;
				font = "EtelkaNarrowMediumPro"; 
				size = 0.035;
				//colorBackground[] = {0,0.4,0.8,0.4};
				colorBackground[] = {0,0,0,0.4};
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

			class scoreboard { 
				idc = 1007; 
				type = CT_STRUCTURED_TEXT; 
				style = ST_LEFT;  
				x = 0; 
				y = 0.1;
				w = 1;
				h = 0.8;
				font = "EtelkaNarrowMediumPro"; 
				size = 0.03;
				colorBackground[] = {0,0.4,0.8,0};
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
				h = 0.77;
				font = "EtelkaNarrowMediumPro"; 
				size = 0.03;
				colorBackground[] = {0,0.4,0.8,0};
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
				h = 0.77;
				font = "EtelkaNarrowMediumPro"; 
				size = 0.03;
				colorBackground[] = {0,0.4,0.8,0};
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
				h = 0.77;
				font = "EtelkaNarrowMediumPro"; 
				size = 0.03;
				colorBackground[] = {0,0.4,0.8,0};
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
				h = 0.77;
				font = "EtelkaNarrowMediumPro"; 
				size = 0.03;
				colorBackground[] = {0,0.4,0.8,0};
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
				h = 0.77;
				font = "EtelkaNarrowMediumPro"; 
				size = 0.03;
				colorBackground[] = {0,0.4,0.8,0};
				colorText[] = {0.5,1,1,1}; 
				text = "Matchs"; 
			};

			class scoreboard_subtitle6 { 
				idc = 1014; 
				type = CT_STRUCTURED_TEXT; 
				style = ST_LEFT; 
				x = 0.8; 
				y = 0.1;
				w = 0.2;
				h = 0.77;
				font = "EtelkaNarrowMediumPro"; 
				size = 0.03;
				colorBackground[] = {0,0.4,0.8,0};
				colorText[] = {0.5,1,1,1}; 
				text = "Score"; 
			};

			class scoreboard_subtitle7 { 
				idc = 1016; 
				type = CT_STRUCTURED_TEXT; 
				style = ST_CENTER; 
				x = 0; 
				y = 0;
				w = 1;
				h = 0.095;
				font = "EtelkaNarrowMediumPro"; 
				size = 0.1;
				colorBackground[] = {0,0.4,0.8,0};
				colorText[] = {0.5,1,1,1}; 
				text = ""; 
			};						


			class sector { 
				idc = 1017; 
				type = CT_STRUCTURED_TEXT; 
				style = ST_LEFT; 
				x = safeZoneX ; 
				y = safeZoneY ;
				w = 0.60;
				h = 0.10;
				font = "EtelkaNarrowMediumPro"; 
				size = 0.10;
				valign = "middle";
				colorBackground[] = {0.0,0,0.0,0.5};
				colorText[] = {1,1,1,1}; 
				text = ""; 
			}; 

			class killM { 
				idc = 1018; 
				type = CT_STRUCTURED_TEXT; 
				style = ST_CENTER; 
				x = 0.36; 
				y = safeZoneY ;
				w = 0.14;
				h = 0.10;
				font = "EtelkaNarrowMediumPro"; 
				size = 0.10;
				colorBackground[] = {0,0.4,0.8,0.6};
				colorText[] = {0.5,1,1,1}; 
				text = ""; 
			}; 

			class deathM { 
				idc = 1019; 
				type = CT_STRUCTURED_TEXT; 
				style = ST_CENTER; 
				x = 0.5; 
				y = safeZoneY ;
				w = 0.14;
				h = 0.10;
				font = "EtelkaNarrowMediumPro"; 
				size = 0.10;
				colorBackground[] = {1,0,0,0.6}; 
				colorText[] = {0.5,1,1,1}; 
				text = ""; 
			}; 												
		};
	}; 	
};