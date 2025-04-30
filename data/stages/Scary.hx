import flixel.FlxCameraFollowStyle;
//funni revisetdr code
// Cam Values
var dadX:Float = 600;
var dadY:Float = 603.5;
var dadZoom:Float = 0.8;

var bfX:Float = 800;
var bfY:Float = 442.5;
var bfZoom:Float = 0.6;

var gfX:Float = -80;
var gfY:Float = 22;
var gfZoom:Float = 0.4;
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
			FlxTween.tween(boyfriend, {alpha: 0.3},0.9);
			FlxTween.tween(stairs, {alpha: 0.3},0.9);

		case 1: 
			defaultCamZoom = bfZoom;
			e.position.set(bfX, bfY);
			FlxTween.tween(boyfriend, {alpha: 1},0.4);
			FlxTween.tween(stairs, {alpha: 1},0.4);
		case 2: 
			defaultCamZoom = gfZoom;
			e.position.set(gfX, gfY);
		}
}
function postUpdate(elapsed:Float) {
	FlxG.camera.follow(camFollow, FlxCameraFollowStyle.LOCKON, 0.06);
}