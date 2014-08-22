	// -----------------------------------------------
	// Author: team  code34 nicolas_boiteux@yahoo.fr
	// Dynamic zone for EOS
	// -----------------------------------------------
	//if (!isServer) exitWith{};

	private [
		"_around",
		"_key",
		"_hashmap",
		"_index", 
		"_grid",
		"_basepos", 
		"_housezone",
		"_position",
		"_positions",
		"_sectors",
		"_knownzone"
	];

	_databasename = "HI";

	if(count _this > 0) then {
		_knownzone = _this select 0;
	} else {
		_knownzone = [];
	};

	_grid = ["new", [31000,31000,100,100]] call OO_GRID;
	_hashmap = ["new", []] call OO_HASHMAP;

	_housezone = [[137,63],[138,63],[137,64],[138,64],[207,65],[208,65],[209,65],[200,66],[206,66],[207,66],[208,66],[209,66],[200,67],[201,67],[206,67],[207,67],[208,67],[209,67],[206,68],[207,68],[208,68],[209,68],[206,69],[208,69],[209,69],[212,70],[212,71],[207,72],[208,72],[207,73],[208,73],[215,74],[216,74],[217,74],[218,74],[102,75],[103,75],[215,75],[216,75],[217,75],[218,75],[90,76],[215,76],[216,76],[217,76],[218,76],[215,77],[216,77],[217,77],[216,78],[217,78],[92,79],[91,80],[92,80],[92,81],[121,84],[96,86],[97,86],[204,86],[205,86],[96,87],[97,87],[178,87],[179,87],[202,87],[203,87],[204,87],[205,87],[206,87],[122,88],[123,88],[179,88],[181,88],[182,88],[201,88],[202,88],[203,88],[204,88],[205,88],[206,88],[106,89],[107,89],[123,89],[182,89],[201,89],[202,89],[204,89],[205,89],[206,89],[106,90],[107,90],[204,90],[205,90],[206,90],[109,91],[95,92],[96,92],[109,92],[115,93],[105,94],[114,94],[115,94],[118,94],[119,94],[105,95],[101,96],[102,96],[101,97],[102,97],[107,97],[26,98],[27,98],[46,98],[47,98],[106,98],[107,98],[201,98],[27,99],[46,99],[47,99],[48,99],[51,99],[164,99],[171,99],[46,100],[47,100],[48,100],[50,100],[82,100],[83,100],[164,100],[165,100],[171,100],[33,101],[34,101],[35,101],[36,101],[46,101],[47,101],[48,101],[100,101],[33,102],[34,102],[35,102],[36,102],[37,102],[38,102],[44,102],[46,102],[47,102],[48,102],[100,102],[109,102],[207,102],[208,102],[35,103],[36,103],[38,103],[41,103],[45,103],[46,103],[47,103],[48,103],[86,103],[87,103],[199,103],[200,103],[207,103],[46,104],[47,104],[86,104],[87,104],[90,104],[121,104],[167,104],[168,104],[199,104],[200,104],[212,104],[213,104],[45,105],[46,105],[49,105],[50,105],[60,105],[61,105],[90,105],[91,105],[168,105],[37,106],[38,106],[39,106],[45,106],[46,106],[60,106],[77,106],[176,106],[36,107],[37,107],[38,107],[39,107],[46,107],[47,107],[48,107],[49,107],[50,107],[51,107],[60,107],[61,107],[156,107],[35,108],[36,108],[37,108],[38,108],[47,108],[50,108],[51,108],[56,108],[57,108],[58,108],[59,108],[74,108],[81,108],[82,108],[92,108],[108,108],[219,108],[47,109],[48,109],[49,109],[50,109],[51,109],[52,109],[56,109],[57,109],[58,109],[64,109],[71,109],[72,109],[74,109],[75,109],[76,109],[81,109],[82,109],[84,109],[92,109],[107,109],[155,109],[156,109],[184,109],[185,109],[212,109],[213,109],[215,109],[216,109],[218,109],[219,109],[37,110],[38,110],[49,110],[50,110],[51,110],[52,110],[53,110],[57,110],[64,110],[67,110],[68,110],[69,110],[70,110],[71,110],[72,110],[73,110],[75,110],[76,110],[148,110],[149,110],[150,110],[151,110],[155,110],[156,110],[157,110],[212,110],[213,110],[216,110],[217,110],[218,110],[38,111],[39,111],[48,111],[49,111],[50,111],[51,111],[52,111],[68,111],[69,111],[71,111],[72,111],[148,111],[149,111],[150,111],[37,112],[38,112],[39,112],[48,112],[49,112],[50,112],[51,112],[52,112],[70,112],[71,112],[100,112],[101,112],[149,112],[150,112],[170,112],[183,112],[37,113],[38,113],[39,113],[40,113],[42,113],[48,113],[49,113],[50,113],[51,113],[71,113],[77,113],[78,113],[95,113],[100,113],[101,113],[102,113],[103,113],[157,113],[158,113],[170,113],[183,113],[184,113],[199,113],[36,114],[37,114],[38,114],[39,114],[40,114],[41,114],[42,114],[43,114],[48,114],[49,114],[50,114],[51,114],[52,114],[53,114],[71,114],[72,114],[77,114],[88,114],[94,114],[95,114],[100,114],[101,114],[102,114],[111,114],[112,114],[161,114],[162,114],[163,114],[168,114],[169,114],[198,114],[199,114],[200,114],[201,114],[202,114],[203,114],[35,115],[36,115],[37,115],[38,115],[39,115],[40,115],[41,115],[42,115],[43,115],[47,115],[48,115],[49,115],[51,115],[52,115],[53,115],[70,115],[71,115],[94,115],[95,115],[99,115],[100,115],[111,115],[198,115],[199,115],[200,115],[201,115],[202,115],[203,115],[204,115],[34,116],[35,116],[36,116],[37,116],[38,116],[39,116],[40,116],[41,116],[42,116],[47,116],[48,116],[87,116],[89,116],[90,116],[93,116],[94,116],[95,116],[100,116],[101,116],[164,116],[165,116],[199,116],[200,116],[201,116],[202,116],[203,116],[204,116],[34,117],[35,117],[36,117],[37,117],[38,117],[39,117],[40,117],[41,117],[42,117],[47,117],[89,117],[90,117],[91,117],[93,117],[94,117],[95,117],[96,117],[101,117],[164,117],[165,117],[167,117],[182,117],[199,117],[200,117],[201,117],[202,117],[203,117],[204,117],[34,118],[35,118],[36,118],[37,118],[38,118],[39,118],[40,118],[41,118],[42,118],[43,118],[76,118],[89,118],[90,118],[91,118],[92,118],[93,118],[94,118],[95,118],[117,118],[167,118],[168,118],[198,118],[199,118],[200,118],[201,118],[202,118],[203,118],[204,118],[36,119],[37,119],[38,119],[42,119],[43,119],[44,119],[75,119],[76,119],[88,119],[89,119],[90,119],[91,119],[92,119],[93,119],[94,119],[95,119],[116,119],[168,119],[173,119],[198,119],[199,119],[35,120],[36,120],[37,120],[41,120],[42,120],[43,120],[71,120],[72,120],[86,120],[87,120],[88,120],[89,120],[90,120],[91,120],[92,120],[93,120],[94,120],[105,120],[106,120],[107,120],[115,120],[116,120],[168,120],[173,120],[174,120],[30,121],[31,121],[36,121],[37,121],[38,121],[40,121],[41,121],[42,121],[43,121],[44,121],[71,121],[72,121],[75,121],[76,121],[87,121],[88,121],[89,121],[90,121],[91,121],[92,121],[93,121],[94,121],[105,121],[106,121],[107,121],[108,121],[109,121],[110,121],[111,121],[115,121],[116,121],[135,121],[169,121],[174,121],[177,121],[36,122],[37,122],[38,122],[39,122],[41,122],[42,122],[43,122],[73,122],[74,122],[75,122],[89,122],[92,122],[93,122],[94,122],[105,122],[106,122],[107,122],[108,122],[109,122],[110,122],[111,122],[167,122],[168,122],[169,122],[173,122],[174,122],[175,122],[180,122],[181,122],[34,123],[35,123],[36,123],[37,123],[38,123],[39,123],[40,123],[41,123],[42,123],[43,123],[44,123],[48,123],[56,123],[73,123],[74,123],[95,123],[104,123],[105,123],[106,123],[107,123],[108,123],[111,123],[166,123],[167,123],[168,123],[172,123],[173,123],[174,123],[175,123],[201,123],[32,124],[33,124],[34,124],[35,124],[36,124],[37,124],[38,124],[39,124],[40,124],[41,124],[42,124],[44,124],[47,124],[48,124],[49,124],[51,124],[56,124],[97,124],[98,124],[104,124],[105,124],[106,124],[107,124],[108,124],[165,124],[166,124],[167,124],[168,124],[169,124],[170,124],[172,124],[173,124],[176,124],[177,124],[180,124],[190,124],[29,125],[30,125],[31,125],[34,125],[35,125],[36,125],[37,125],[38,125],[39,125],[40,125],[41,125],[47,125],[92,125],[93,125],[96,125],[97,125],[98,125],[165,125],[166,125],[167,125],[168,125],[169,125],[170,125],[171,125],[172,125],[173,125],[176,125],[177,125],[179,125],[180,125],[208,125],[34,126],[35,126],[36,126],[37,126],[38,126],[39,126],[40,126],[92,126],[93,126],[100,126],[101,126],[110,126],[164,126],[165,126],[166,126],[167,126],[168,126],[169,126],[170,126],[171,126],[172,126],[176,126],[177,126],[179,126],[195,126],[208,126],[209,126],[34,127],[35,127],[36,127],[37,127],[38,127],[39,127],[40,127],[41,127],[101,127],[108,127],[109,127],[124,127],[164,127],[165,127],[166,127],[167,127],[168,127],[169,127],[170,127],[171,127],[172,127],[178,127],[179,127],[181,127],[184,127],[194,127],[195,127],[34,128],[35,128],[36,128],[37,128],[38,128],[39,128],[40,128],[41,128],[42,128],[74,128],[84,128],[95,128],[103,128],[164,128],[165,128],[166,128],[167,128],[168,128],[169,128],[170,128],[171,128],[172,128],[180,128],[181,128],[182,128],[194,128],[195,128],[31,129],[32,129],[34,129],[35,129],[36,129],[37,129],[38,129],[39,129],[40,129],[41,129],[94,129],[95,129],[103,129],[104,129],[142,129],[165,129],[166,129],[167,129],[168,129],[169,129],[170,129],[173,129],[174,129],[180,129],[181,129],[194,129],[195,129],[32,130],[33,130],[34,130],[35,130],[36,130],[37,130],[38,130],[39,130],[40,130],[41,130],[90,130],[103,130],[142,130],[143,130],[167,130],[168,130],[169,130],[170,130],[171,130],[173,130],[174,130],[175,130],[192,130],[32,131],[33,131],[34,131],[35,131],[36,131],[37,131],[38,131],[39,131],[40,131],[41,131],[43,131],[65,131],[89,131],[90,131],[103,131],[110,131],[111,131],[127,131],[128,131],[168,131],[169,131],[171,131],[172,131],[173,131],[174,131],[175,131],[191,131],[192,131],[193,131],[194,131],[195,131],[208,131],[34,132],[35,132],[36,132],[37,132],[38,132],[39,132],[40,132],[41,132],[42,132],[43,132],[104,132],[107,132],[108,132],[109,132],[110,132],[111,132],[112,132],[127,132],[129,132],[130,132],[171,132],[172,132],[173,132],[174,132],[175,132],[192,132],[193,132],[194,132],[195,132],[207,132],[208,132],[209,132],[35,133],[36,133],[37,133],[38,133],[39,133],[40,133],[41,133],[42,133],[107,133],[108,133],[109,133],[110,133],[111,133],[133,133],[170,133],[171,133],[172,133],[173,133],[192,133],[193,133],[194,133],[195,133],[196,133],[207,133],[208,133],[35,134],[36,134],[37,134],[38,134],[39,134],[40,134],[41,134],[42,134],[107,134],[108,134],[109,134],[110,134],[111,134],[112,134],[133,134],[170,134],[171,134],[172,134],[173,134],[193,134],[194,134],[195,134],[207,134],[35,135],[36,135],[37,135],[38,135],[39,135],[40,135],[41,135],[42,135],[43,135],[44,135],[47,135],[51,135],[52,135],[107,135],[108,135],[109,135],[110,135],[111,135],[112,135],[114,135],[115,135],[116,135],[117,135],[171,135],[172,135],[173,135],[174,135],[182,135],[183,135],[197,135],[221,135],[35,136],[36,136],[37,136],[38,136],[39,136],[40,136],[41,136],[42,136],[43,136],[44,136],[47,136],[51,136],[52,136],[92,136],[93,136],[108,136],[110,136],[111,136],[112,136],[115,136],[116,136],[117,136],[118,136],[173,136],[182,136],[192,136],[220,136],[221,136],[35,137],[36,137],[37,137],[38,137],[39,137],[40,137],[41,137],[42,137],[43,137],[44,137],[45,137],[46,137],[58,137],[92,137],[93,137],[116,137],[117,137],[118,137],[119,137],[227,137],[35,138],[36,138],[37,138],[38,138],[39,138],[40,138],[41,138],[42,138],[43,138],[44,138],[45,138],[46,138],[47,138],[58,138],[59,138],[116,138],[117,138],[118,138],[119,138],[35,139],[36,139],[37,139],[38,139],[39,139],[40,139],[41,139],[42,139],[43,139],[44,139],[45,139],[46,139],[47,139],[53,139],[54,139],[72,139],[73,139],[83,139],[116,139],[118,139],[119,139],[120,139],[174,139],[175,139],[213,139],[214,139],[34,140],[35,140],[36,140],[37,140],[38,140],[39,140],[40,140],[41,140],[42,140],[43,140],[44,140],[45,140],[46,140],[47,140],[53,140],[54,140],[72,140],[83,140],[113,140],[114,140],[118,140],[119,140],[122,140],[123,140],[124,140],[216,140],[217,140],[32,141],[33,141],[34,141],[35,141],[36,141],[39,141],[40,141],[43,141],[44,141],[45,141],[46,141],[47,141],[48,141],[52,141],[53,141],[112,141],[113,141],[114,141],[115,141],[117,141],[118,141],[121,141],[122,141],[123,141],[124,141],[125,141],[182,141],[183,141],[217,141],[32,142],[33,142],[34,142],[35,142],[36,142],[43,142],[44,142],[45,142],[46,142],[47,142],[48,142],[112,142],[113,142],[114,142],[115,142],[118,142],[121,142],[122,142],[123,142],[124,142],[125,142],[126,142],[127,142],[174,142],[175,142],[179,142],[180,142],[181,142],[193,142],[194,142],[33,143],[34,143],[35,143],[36,143],[37,143],[38,143],[47,143],[48,143],[49,143],[50,143],[51,143],[52,143],[112,143],[113,143],[114,143],[115,143],[119,143],[121,143],[122,143],[123,143],[124,143],[125,143],[126,143],[127,143],[128,143],[129,143],[130,143],[174,143],[175,143],[179,143],[180,143],[181,143],[193,143],[194,143],[35,144],[36,144],[37,144],[38,144],[46,144],[47,144],[48,144],[49,144],[50,144],[51,144],[52,144],[53,144],[54,144],[64,144],[65,144],[110,144],[111,144],[112,144],[113,144],[123,144],[124,144],[125,144],[126,144],[127,144],[129,144],[130,144],[174,144],[175,144],[35,145],[36,145],[37,145],[38,145],[39,145],[46,145],[47,145],[48,145],[49,145],[51,145],[52,145],[53,145],[54,145],[55,145],[65,145],[110,145],[111,145],[112,145],[122,145],[123,145],[124,145],[125,145],[174,145],[175,145],[187,145],[189,145],[190,145],[35,146],[38,146],[50,146],[51,146],[52,146],[53,146],[54,146],[55,146],[56,146],[57,146],[58,146],[64,146],[74,146],[75,146],[108,146],[110,146],[111,146],[112,146],[115,146],[116,146],[123,146],[124,146],[125,146],[126,146],[127,146],[180,146],[181,146],[50,147],[51,147],[52,147],[55,147],[56,147],[57,147],[58,147],[61,147],[62,147],[63,147],[107,147],[108,147],[113,147],[114,147],[125,147],[126,147],[127,147],[178,147],[180,147],[185,147],[43,148],[44,148],[45,148],[52,148],[53,148],[57,148],[58,148],[59,148],[60,148],[61,148],[62,148],[63,148],[82,148],[83,148],[102,148],[109,148],[110,148],[113,148],[126,148],[127,148],[128,148],[129,148],[130,148],[136,148],[137,148],[167,148],[168,148],[169,148],[170,148],[178,148],[179,148],[180,148],[181,148],[185,148],[186,148],[41,149],[42,149],[43,149],[44,149],[52,149],[53,149],[54,149],[55,149],[58,149],[60,149],[61,149],[62,149],[63,149],[64,149],[65,149],[73,149],[74,149],[81,149],[94,149],[95,149],[110,149],[127,149],[128,149],[129,149],[130,149],[131,149],[135,149],[136,149],[137,149],[167,149],[169,149],[177,149],[178,149],[179,149],[180,149],[181,149],[183,149],[185,149],[186,149],[41,150],[42,150],[43,150],[53,150],[54,150],[55,150],[56,150],[57,150],[60,150],[61,150],[62,150],[63,150],[94,150],[95,150],[100,150],[101,150],[111,150],[112,150],[127,150],[128,150],[129,150],[130,150],[131,150],[169,150],[177,150],[178,150],[179,150],[180,150],[181,150],[182,150],[183,150],[42,151],[56,151],[57,151],[60,151],[61,151],[62,151],[63,151],[64,151],[65,151],[67,151],[77,151],[78,151],[94,151],[95,151],[96,151],[100,151],[111,151],[122,151],[124,151],[127,151],[128,151],[129,151],[130,151],[168,151],[169,151],[178,151],[179,151],[180,151],[181,151],[182,151],[183,151],[56,152],[58,152],[59,152],[63,152],[64,152],[65,152],[67,152],[68,152],[77,152],[78,152],[95,152],[96,152],[122,152],[124,152],[128,152],[129,152],[130,152],[178,152],[179,152],[180,152],[181,152],[182,152],[183,152],[184,152],[214,152],[215,152],[221,152],[222,152],[39,153],[40,153],[45,153],[55,153],[56,153],[58,153],[59,153],[64,153],[65,153],[66,153],[67,153],[68,153],[73,153],[74,153],[95,153],[96,153],[125,153],[126,153],[170,153],[171,153],[178,153],[179,153],[180,153],[181,153],[182,153],[183,153],[184,153],[185,153],[188,153],[193,153],[194,153],[195,153],[212,153],[214,153],[219,153],[221,153],[222,153],[39,154],[40,154],[41,154],[45,154],[46,154],[55,154],[58,154],[65,154],[66,154],[67,154],[68,154],[73,154],[74,154],[89,154],[90,154],[123,154],[124,154],[125,154],[126,154],[167,154],[168,154],[171,154],[180,154],[181,154],[182,154],[183,154],[184,154],[188,154],[193,154],[194,154],[195,154],[212,154],[219,154],[220,154],[222,154],[223,154],[39,155],[40,155],[41,155],[42,155],[59,155],[63,155],[66,155],[67,155],[68,155],[69,155],[89,155],[90,155],[109,155],[110,155],[111,155],[121,155],[122,155],[123,155],[124,155],[125,155],[126,155],[168,155],[182,155],[183,155],[184,155],[194,155],[222,155],[223,155],[50,156],[51,156],[61,156],[62,156],[67,156],[68,156],[90,156],[91,156],[92,156],[110,156],[111,156],[121,156],[122,156],[123,156],[124,156],[125,156],[182,156],[183,156],[184,156],[205,156],[206,156],[219,156],[42,157],[43,157],[50,157],[51,157],[61,157],[62,157],[64,157],[67,157],[68,157],[89,157],[90,157],[91,157],[92,157],[93,157],[112,157],[120,157],[121,157],[122,157],[123,157],[124,157],[125,157],[131,157],[132,157],[144,157],[145,157],[206,157],[207,157],[208,157],[218,157],[219,157],[228,157],[229,157],[230,157],[42,158],[43,158],[44,158],[64,158],[65,158],[67,158],[68,158],[69,158],[82,158],[83,158],[89,158],[90,158],[91,158],[92,158],[93,158],[94,158],[95,158],[116,158],[117,158],[119,158],[120,158],[122,158],[123,158],[124,158],[125,158],[126,158],[131,158],[132,158],[152,158],[153,158],[154,158],[159,158],[160,158],[161,158],[163,158],[164,158],[207,158],[208,158],[214,158],[229,158],[230,158],[42,159],[43,159],[44,159],[52,159],[57,159],[58,159],[70,159],[71,159],[79,159],[80,159],[82,159],[83,159],[84,159],[91,159],[92,159],[93,159],[94,159],[95,159],[96,159],[102,159],[103,159],[116,159],[117,159],[123,159],[124,159],[125,159],[153,159],[154,159],[157,159],[160,159],[163,159],[165,159],[166,159],[167,159],[188,159],[189,159],[215,159],[43,160],[44,160],[47,160],[48,160],[49,160],[52,160],[53,160],[62,160],[67,160],[68,160],[69,160],[70,160],[71,160],[72,160],[73,160],[76,160],[77,160],[78,160],[79,160],[80,160],[92,160],[93,160],[94,160],[95,160],[96,160],[103,160],[155,160],[157,160],[165,160],[166,160],[167,160],[168,160],[188,160],[189,160],[209,160],[214,160],[215,160],[216,160],[217,160],[224,160],[225,160],[44,161],[46,161],[47,161],[48,161],[49,161],[50,161],[51,161],[60,161],[61,161],[62,161],[63,161],[72,161],[73,161],[74,161],[75,161],[76,161],[77,161],[78,161],[79,161],[95,161],[96,161],[101,161],[102,161],[103,161],[141,161],[154,161],[155,161],[159,161],[160,161],[161,161],[165,161],[166,161],[167,161],[168,161],[169,161],[170,161],[179,161],[211,161],[212,161],[213,161],[214,161],[215,161],[216,161],[221,161],[42,162],[43,162],[44,162],[46,162],[47,162],[48,162],[49,162],[50,162],[60,162],[61,162],[62,162],[63,162],[64,162],[66,162],[67,162],[69,162],[70,162],[71,162],[72,162],[73,162],[74,162],[75,162],[76,162],[77,162],[78,162],[79,162],[92,162],[93,162],[127,162],[141,162],[142,162],[144,162],[145,162],[152,162],[153,162],[154,162],[155,162],[158,162],[159,162],[160,162],[161,162],[165,162],[166,162],[167,162],[168,162],[169,162],[180,162],[181,162],[187,162],[188,162],[202,162],[203,162],[211,162],[212,162],[213,162],[214,162],[215,162],[221,162],[222,162],[42,163],[43,163],[44,163],[48,163],[49,163],[50,163],[55,163],[62,163],[67,163],[69,163],[70,163],[71,163],[72,163],[73,163],[74,163],[75,163],[76,163],[77,163],[91,163],[92,163],[93,163],[125,163],[126,163],[127,163],[130,163],[131,163],[141,163],[142,163],[144,163],[145,163],[153,163],[155,163],[158,163],[159,163],[166,163],[167,163],[180,163],[186,163],[187,163],[188,163],[192,163],[193,163],[202,163],[203,163],[204,163],[207,163],[208,163],[209,163],[210,163],[211,163],[212,163],[213,163],[214,163],[215,163],[216,163],[222,163],[223,163],[225,163],[226,163],[42,164],[43,164],[44,164],[48,164],[49,164],[50,164],[51,164],[68,164],[69,164],[70,164],[71,164],[72,164],[73,164],[125,164],[126,164],[127,164],[141,164],[144,164],[159,164],[160,164],[163,164],[167,164],[186,164],[187,164],[188,164],[189,164],[190,164],[191,164],[192,164],[193,164],[203,164],[204,164],[205,164],[206,164],[207,164],[208,164],[209,164],[210,164],[211,164],[212,164],[213,164],[214,164],[215,164],[216,164],[225,164],[226,164],[43,165],[44,165],[49,165],[50,165],[51,165],[52,165],[69,165],[70,165],[71,165],[72,165],[73,165],[101,165],[102,165],[128,165],[141,165],[142,165],[167,165],[168,165],[186,165],[187,165],[188,165],[189,165],[190,165],[191,165],[204,165],[205,165],[206,165],[207,165],[208,165],[211,165],[212,165],[213,165],[214,165],[215,165],[43,166],[44,166],[50,166],[51,166],[70,166],[71,166],[127,166],[128,166],[145,166],[186,166],[187,166],[188,166],[189,166],[190,166],[191,166],[207,166],[208,166],[211,166],[212,166],[42,167],[43,167],[50,167],[71,167],[92,167],[127,167],[128,167],[133,167],[144,167],[145,167],[146,167],[185,167],[186,167],[187,167],[188,167],[189,167],[190,167],[205,167],[206,167],[207,167],[208,167],[209,167],[210,167],[211,167],[42,168],[50,168],[70,168],[132,168],[133,168],[134,168],[141,168],[145,168],[146,168],[159,168],[160,168],[161,168],[183,168],[185,168],[186,168],[187,168],[188,168],[203,168],[204,168],[205,168],[206,168],[207,168],[208,168],[209,168],[210,168],[211,168],[212,168],[41,169],[42,169],[70,169],[121,169],[132,169],[133,169],[134,169],[149,169],[150,169],[159,169],[160,169],[161,169],[184,169],[185,169],[186,169],[187,169],[191,169],[192,169],[193,169],[206,169],[207,169],[208,169],[209,169],[210,169],[211,169],[212,169],[225,169],[226,169],[40,170],[41,170],[42,170],[48,170],[121,170],[122,170],[141,170],[142,170],[149,170],[158,170],[159,170],[160,170],[161,170],[163,170],[164,170],[165,170],[185,170],[187,170],[192,170],[193,170],[204,170],[205,170],[206,170],[207,170],[208,170],[209,170],[210,170],[211,170],[212,170],[213,170],[214,170],[223,170],[224,170],[225,170],[226,170],[39,171],[40,171],[41,171],[46,171],[47,171],[73,171],[74,171],[103,171],[104,171],[141,171],[142,171],[148,171],[149,171],[159,171],[160,171],[161,171],[162,171],[163,171],[164,171],[165,171],[166,171],[187,171],[188,171],[205,171],[207,171],[208,171],[209,171],[210,171],[211,171],[212,171],[213,171],[221,171],[223,171],[224,171],[228,171],[39,172],[40,172],[41,172],[47,172],[103,172],[104,172],[105,172],[107,172],[108,172],[141,172],[144,172],[145,172],[150,172],[151,172],[160,172],[161,172],[162,172],[163,172],[164,172],[165,172],[166,172],[167,172],[173,172],[174,172],[187,172],[188,172],[208,172],[209,172],[210,172],[211,172],[213,172],[214,172],[215,172],[228,172],[38,173],[39,173],[40,173],[41,173],[42,173],[104,173],[105,173],[139,173],[140,173],[141,173],[142,173],[143,173],[144,173],[145,173],[146,173],[147,173],[151,173],[152,173],[153,173],[155,173],[161,173],[162,173],[163,173],[164,173],[165,173],[166,173],[173,173],[180,173],[181,173],[191,173],[207,173],[208,173],[209,173],[210,173],[213,173],[214,173],[216,173],[227,173],[38,174],[39,174],[41,174],[104,174],[105,174],[140,174],[142,174],[143,174],[144,174],[145,174],[146,174],[147,174],[151,174],[152,174],[153,174],[154,174],[155,174],[156,174],[162,174],[165,174],[192,174],[212,174],[216,174],[37,175],[38,175],[39,175],[105,175],[141,175],[143,175],[144,175],[145,175],[146,175],[148,175],[149,175],[151,175],[152,175],[153,175],[165,175],[167,175],[168,175],[190,175],[191,175],[192,175],[205,175],[206,175],[209,175],[210,175],[36,176],[37,176],[38,176],[39,176],[40,176],[141,176],[143,176],[144,176],[145,176],[146,176],[148,176],[149,176],[151,176],[152,176],[153,176],[167,176],[190,176],[191,176],[192,176],[205,176],[206,176],[209,176],[210,176],[36,177],[37,177],[38,177],[39,177],[135,177],[143,177],[144,177],[145,177],[146,177],[209,177],[210,177],[34,178],[37,178],[38,178],[53,178],[54,178],[80,178],[81,178],[89,178],[90,178],[134,178],[135,178],[143,178],[144,178],[145,178],[146,178],[204,178],[208,178],[209,178],[34,179],[35,179],[36,179],[37,179],[84,179],[85,179],[103,179],[143,179],[144,179],[183,179],[209,179],[35,180],[36,180],[37,180],[82,180],[84,180],[85,180],[86,180],[103,180],[137,180],[146,180],[147,180],[176,180],[177,180],[178,180],[179,180],[180,180],[183,180],[188,180],[189,180],[225,180],[226,180],[83,181],[84,181],[85,181],[86,181],[87,181],[116,181],[117,181],[136,181],[137,181],[146,181],[158,181],[176,181],[178,181],[179,181],[180,181],[225,181],[226,181],[75,182],[83,182],[84,182],[85,182],[86,182],[87,182],[88,182],[116,182],[117,182],[141,182],[142,182],[158,182],[31,183],[32,183],[74,183],[75,183],[83,183],[84,183],[85,183],[86,183],[87,183],[116,183],[117,183],[139,183],[140,183],[141,183],[142,183],[211,183],[212,183],[221,183],[222,183],[29,184],[30,184],[75,184],[84,184],[85,184],[86,184],[117,184],[139,184],[140,184],[141,184],[142,184],[207,184],[208,184],[221,184],[222,184],[29,185],[30,185],[88,185],[89,185],[95,185],[96,185],[138,185],[139,185],[140,185],[141,185],[142,185],[213,185],[214,185],[97,186],[135,186],[136,186],[137,186],[138,186],[139,186],[140,186],[141,186],[142,186],[148,186],[149,186],[151,186],[152,186],[214,186],[65,187],[91,187],[96,187],[97,187],[135,187],[136,187],[138,187],[139,187],[140,187],[141,187],[142,187],[145,187],[148,187],[151,187],[159,187],[196,187],[197,187],[137,188],[138,188],[139,188],[140,188],[141,188],[142,188],[143,188],[144,188],[145,188],[146,188],[159,188],[196,188],[197,188],[229,188],[102,189],[103,189],[104,189],[105,189],[107,189],[110,189],[137,189],[138,189],[139,189],[140,189],[141,189],[142,189],[143,189],[144,189],[145,189],[175,189],[101,190],[102,190],[103,190],[104,190],[105,190],[108,190],[109,190],[110,190],[138,190],[143,190],[165,190],[166,190],[174,190],[175,190],[247,190],[33,191],[75,191],[76,191],[101,191],[102,191],[103,191],[104,191],[108,191],[109,191],[137,191],[138,191],[202,191],[203,191],[208,191],[209,191],[210,191],[247,191],[248,191],[33,192],[34,192],[102,192],[108,192],[109,192],[126,192],[127,192],[134,192],[202,192],[203,192],[208,192],[209,192],[210,192],[222,192],[97,193],[101,193],[102,193],[126,193],[127,193],[202,193],[203,193],[206,193],[209,193],[210,193],[221,193],[222,193],[223,193],[49,194],[56,194],[71,194],[97,194],[98,194],[126,194],[141,194],[142,194],[154,194],[155,194],[205,194],[207,194],[209,194],[210,194],[215,194],[55,195],[56,195],[66,195],[67,195],[114,195],[128,195],[129,195],[141,195],[201,195],[207,195],[214,195],[215,195],[67,196],[89,196],[90,196],[114,196],[127,196],[128,196],[129,196],[149,196],[161,196],[201,196],[202,196],[255,196],[101,197],[105,197],[106,197],[127,197],[128,197],[129,197],[143,197],[201,197],[202,197],[256,197],[93,198],[94,198],[101,198],[105,198],[130,198],[137,198],[138,198],[144,198],[145,198],[201,198],[210,198],[211,198],[231,198],[232,198],[233,198],[234,198],[34,199],[35,199],[64,199],[65,199],[93,199],[140,199],[141,199],[144,199],[223,199],[224,199],[225,199],[231,199],[232,199],[233,199],[234,199],[235,199],[35,200],[41,200],[58,200],[64,200],[65,200],[66,200],[94,200],[205,200],[206,200],[219,200],[223,200],[224,200],[225,200],[230,200],[231,200],[232,200],[38,201],[41,201],[42,201],[58,201],[65,201],[66,201],[93,201],[94,201],[95,201],[149,201],[205,201],[206,201],[219,201],[238,201],[239,201],[240,201],[257,201],[258,201],[92,202],[93,202],[94,202],[95,202],[149,202],[220,202],[238,202],[239,202],[253,202],[254,202],[257,202],[258,202],[93,203],[94,203],[95,203],[221,203],[223,203],[253,203],[254,203],[167,204],[220,204],[221,204],[223,204],[224,204],[264,204],[152,205],[159,205],[166,205],[264,205],[265,205],[43,206],[144,206],[145,206],[146,206],[147,206],[148,206],[152,206],[153,206],[159,206],[165,206],[264,206],[265,206],[144,207],[145,207],[146,207],[147,207],[148,207],[149,207],[150,207],[165,207],[249,207],[265,207],[266,207],[85,208],[145,208],[146,208],[218,208],[219,208],[248,208],[249,208],[250,208],[251,208],[266,208],[85,209],[86,209],[144,209],[145,209],[146,209],[216,209],[217,209],[218,209],[219,209],[220,209],[249,209],[250,209],[251,209],[256,209],[138,210],[216,210],[217,210],[218,210],[219,210],[220,210],[221,210],[228,210],[234,210],[235,210],[236,210],[245,210],[246,210],[255,210],[256,210],[257,210],[258,210],[138,211],[139,211],[141,211],[142,211],[228,211],[234,211],[235,211],[236,211],[244,211],[245,211],[253,211],[254,211],[255,211],[256,211],[257,211],[258,211],[267,211],[45,212],[79,212],[86,212],[87,212],[141,212],[142,212],[244,212],[245,212],[251,212],[252,212],[253,212],[254,212],[255,212],[256,212],[257,212],[258,212],[259,212],[265,212],[266,212],[267,212],[44,213],[45,213],[46,213],[47,213],[146,213],[251,213],[252,213],[253,213],[254,213],[255,213],[256,213],[257,213],[258,213],[259,213],[34,214],[37,214],[38,214],[44,214],[45,214],[46,214],[146,214],[253,214],[254,214],[255,214],[256,214],[257,214],[258,214],[270,214],[276,214],[37,215],[38,215],[235,215],[236,215],[253,215],[254,215],[256,215],[257,215],[258,215],[259,215],[262,215],[268,215],[270,215],[275,215],[276,215],[91,216],[92,216],[225,216],[226,216],[227,216],[253,216],[256,216],[257,216],[258,216],[259,216],[260,216],[261,216],[263,216],[266,216],[267,216],[226,217],[231,217],[232,217],[236,217],[252,217],[253,217],[257,217],[258,217],[266,217],[267,217],[167,218],[231,218],[232,218],[253,218],[31,219],[222,219],[31,220],[222,220],[223,220],[253,220],[92,221],[93,221],[142,221],[92,222],[96,222],[97,222],[277,222],[278,222],[267,225],[65,226],[110,226],[111,226],[252,226],[253,226],[267,226],[270,226],[65,227],[110,227],[118,227],[121,227],[269,227],[270,227],[258,228],[269,228],[270,228],[271,228],[272,228],[258,229],[270,229],[271,229],[248,230],[267,230],[268,230],[269,230],[270,230],[246,231],[248,231],[267,231],[268,231],[269,231],[270,231],[271,231],[246,232],[248,232],[249,232],[268,232],[269,232],[270,232],[271,232],[272,232],[273,232],[274,232],[275,232],[269,233],[270,233],[271,233],[272,233],[273,233],[275,233],[276,233],[268,234],[269,234],[271,234],[272,234],[273,234],[268,235],[269,235],[272,235],[268,236],[269,236],[270,236],[273,236],[236,237],[268,237],[270,237],[271,237],[268,238],[269,238],[262,239],[263,239],[262,240],[270,240],[271,240],[262,241],[269,241],[270,241],[271,241],[272,241],[261,242],[262,242],[268,242],[269,242],[270,242],[271,242],[272,242],[268,243],[269,243],[271,243],[264,244],[272,244],[273,244],[273,245],[274,245],[275,245],[267,246],[275,246],[276,246],[282,257],[283,257],[283,258]];
	

	if(count _knownzone > 0) then {
		{
			_positions = _positions + [_housezone select _x];
		}foreach _knownzone;
	} else {
		for "_x" from 0 to 30 step 1 do {
			_key = _housezone call BIS_fnc_selectRandom;
			_housezone = _housezone - [_key];

			_position = ["getPosFromSector", _key] call _grid;
			if(
				(getmarkerpos "respawn_west" distance _position > 1300)
			) then {
				_sector = ["new", [_key, _position, _grid]] call OO_SECTOR;
				"Draw" call _sector;
				["Put", [_key, _sector]] call _hashmap;

				_around = ["getSectorAllAround", [_key,3]] call _grid;
				{
					if(random 1 > 0.9) then {
						global_new_zone = global_new_zone + [_x];
					};
				}foreach _around;
			};
		};
	};

	_hashmap;