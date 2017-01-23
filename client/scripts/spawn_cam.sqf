	private [ "_camera", "_pos0", "_pos1", "_pos2", "_pos3", "_pos4"];

	_pos0 = [ 300, -500, 300];
	_pos1 = [ 250, -500, 250];
	_pos2 = [ 0, -450, 225];
	_pos3 = [ 0, -100, 20];
	_pos4 = [0,0.4,1.75];

	_camera = "camera" camCreate (position player);
	_camera cameraEffect ["internal","front"];
	_camera camSetTarget player;
	_camera camSetRelPos _pos0;
	_camera camcommit 0;

	_camera camSetRelPos _pos1;
	_camera camcommit 0.5;

	waitUntil { camCommitted _camera };

	_camera camSetRelPos _pos2;
	_camera camcommit 0.25;

	waitUntil { camCommitted _camera };

	_camera camSetRelPos _pos3;
	_camera camcommit 1;

	waitUntil { camCommitted _camera };

	_camera camSetRelPos _pos4;
	_camera camcommit 0.5;

	waitUntil { camCommitted _camera };

	_camera cameraEffect ["Terminate","back"];
	camDestroy _camera;
	camUseNVG false;