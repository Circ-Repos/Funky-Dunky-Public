import flixel.FlxCameraFollowStyle;
//funni revisetdr code
// Cam Values
var dadX:Float = 300;
var dadY:Float = 603.5;
var dadZoom:Float = 0.8;

var bfX:Float = 800;
var bfY:Float = 442.5;
var bfZoom:Float = 0.6;

var gfX:Float = -80;
var gfY:Float = 22;
var gfZoom:Float = 0.4;

var camOther = new FlxCamera();


function postCreate(){
	defaultCamZoom = dadZoom;
	camZooming = false;
	FlxG.cameras.add(camOther, false);
    camOther.bgColor = 0;
    camOther.alpha = 1;
}
function lookLeft(){
    //FlxTween.tween(FlxG.camera.scroll, {x: 500},0.7, {ease: FlxEase.sineInOut});
	FlxTween.tween(camFollow, {x: dadX,y: dadY},3.3, {ease: FlxEase.sineInOut});
	FlxTween.tween(camGame, {zoom: 0.8},3.3, {ease: FlxEase.sineInOut});

}
function create(){
	PlayState.instance.introLength = 0.1;
	var vig = new FlxSprite();
    vig.loadGraphic(Paths.image('vig'));
	vig.cameras = [camOther];
    add(vig);
	remove(vig, true);
	insert(0, vig);

}
function onSongStart(){
	startZoom();
}
function startZoom(){
	boyfriend.debugMode = true;
	dad.debugMode = true;
    camZooming = false; //usually off, but just incase i guess
    camGame.zoom = 1.25;
    camHUD.alpha = 0;
    camGame.alpha = 0;
	FlxTween.tween(camGame, {zoom: 0.8},6.7, {ease: FlxEase.sineInOut});
	FlxTween.tween(camGame, {alpha: 1},2.35, {ease: FlxEase.linear});
	camFollow.setPosition(bfX + 450,bfY);
}
function showHud(time:Float){
	FlxTween.tween(camHUD, {alpha: 1},time, {ease: FlxEase.linear});

}
function onCountdown(event) event.cancel();
function idleEnable() boyfriend.debugMode = dad.debugMode = false;
function onCameraMove(e) {
	if(camZooming){
	switch (curCameraTarget){
		case 0:
			defaultCamZoom = dadZoom;
			e.position.set(dadX, dadY);
			//FlxTween.tween(boyfriend, {alpha: 0.3},0.9, {ease: FlxEase.linear});
			//FlxTween.tween(stairs, {alpha: 0.3},0.9, {ease: FlxEase.linear});

		case 1: 
			defaultCamZoom = bfZoom;
			e.position.set(bfX, bfY);
			//FlxTween.tween(boyfriend, {alpha: 1},0.4, {ease: FlxEase.linear});
			//FlxTween.tween(stairs, {alpha: 1},0.4, {ease: FlxEase.linear});
		case 2: 
			defaultCamZoom = gfZoom;
			e.position.set(gfX, gfY);
		}
	}
	if(!camZooming) e.cancel();
}
function postUpdate(elapsed:Float) {
	FlxG.camera.follow(camFollow, FlxCameraFollowStyle.LOCKON, 0.06);
}