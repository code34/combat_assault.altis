if(!isNil "newdeploymentmark") then {deleteMarkerLocal newdeploymentmark;};

private _position = (_this select 0) ctrlMapScreenToWorld [_this select 2, _this select 3];
_position = ["getSectorCenterPos", _position] call client_grid;

newdeploymentmark = createMarkerlocal ["newdeploymentmark", _position];
newdeploymentmark setmarkershapelocal "RECTANGLE";
newdeploymentmark setmarkerbrushlocal "Solid";
newdeploymentmark setmarkercolorlocal "ColorWhite";
newdeploymentmark setmarkersizelocal [50,50];