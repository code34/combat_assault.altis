class Params
{ 
	class wcpopsquaredistance
	{
		title = "POP SQUARE DISTANCE";
		values[] = {3, 5, 10};
		texts[] = {"NEAR", "MEDIUM", "FAR"};
		default = 3;
	};
	class wcaccurencylevel
	{
		title = "AI ACCURENCY LEVEL";
		values[] = {1, 2, 3, 4};
		texts[] = {"NOVICE", "RECRUIT", "VETERAN", "CHEATED"};
		default = 2;
	};
	class wcnumberofzone
	{
		title = "NUMBER OF ZONES AT BEGINING";
		values[] = {1,2,3,4,5,6,7,8};
		texts[] = {"1 - very easy game", "2", "3", "4 - normal game","5","6","7","8 - very difficult game"};
		default = 4;
	};
	class wcnumberofticket
	{
		title = "NUMBER OF TICKETS";
		values[] = {200,500,1000,5000};
		texts[] = {"200 - very short game", "500 - normal game","1000 - long game", "5000 - very long game"};
		default = 500;
	};
	class wcfatigue
	{
		title = "FATIGUE";
		values[] = {1, 2};
		texts[] = {"ON", "OFF"};
		default = 2;
	};
	class wcredeployement
	{
		title = "REDEPLOYEMENT SYSTEM";
		values[] = {1, 2};
		texts[] = {"ON", "OFF"};
		default = 1;
	};
	class wcpopchopperprobparam
	{
		title = "KAJMAN POP PROBALITIES";
		values[] = {1,2,3};
		texts[] = {"OFTEN ", "SOMETIMES", "NEVER"};
		default = 2;
	};
	class wcpopconvoyprobparam
	{
		title = "POP AN ENEMY CONVOY EACH";
		values[] = {1,2,3};
		texts[] = {"30 Minutes ", "1 Hour", "NEVER"};
		default = 1;
	};
	class wcambiant
	{
		title = "AMBIANT LIFES AND SOUNDS";
		values[] = {1, 2};
		texts[] = {"ON", "OFF"};
		default = 2;
	};
};