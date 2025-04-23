import flixel.FlxCameraFollowStyle;
//funni revisetdr code
// Cam Values
var dadX:Float = 192;
var dadY:Float = 273.5;
var dadZoom:Float = 1;

var bfX:Float = 602;
var bfY:Float = 442.5;
var bfZoom:Float = 0.8;

var gfX:Float = -80;
var gfY:Float = 22;
var gfZoom:Float = 0.5;
function postCreate(){
	defaultCamZoom = dadZoom;
}
function create(){
	PlayState.instance.introLength = 0;
}
function onCountdown(event) event.cancel();

function onCameraMove(e) {
	switch (curCameraTarget){
		case 0:
			defaultCamZoom = dadZoom;
			e.position.set(dadX, dadY);
		case 1: 
			defaultCamZoom = bfZoom;
			e.position.set(bfX, bfY);
		case 2: 
			defaultCamZoom = gfZoom;
			e.position.set(gfX, gfY);
		}
}
function postUpdate(elapsed:Float) {
	FlxG.camera.follow(camFollow, FlxCameraFollowStyle.LOCKON, 0.06);
}