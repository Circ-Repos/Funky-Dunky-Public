//funni revisetdr code
// Cam Values
var dadZoom:Float = 1;
var bfZoom:Float = 0.8;
var gfZoom:Float = 0.5;


function onCameraMove(e) {
	switch (curCameraTarget){
		case 0: defaultCamZoom = dadZoom;
		case 1: defaultCamZoom = bfZoom;
		case 2: defaultCamZoom = gfZoom;
	}
}