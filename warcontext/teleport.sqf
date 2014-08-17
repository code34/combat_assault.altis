	teleported = true;
	hintSilent "Click on the map where you'd like to Insert.";
	onMapSingleClick "player setPos [(_pos select 0), (_pos select 1), 0]; teleported = false;";

	waitUntil{!teleported};
	onMapSingleClick "";
