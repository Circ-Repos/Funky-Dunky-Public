import funkin.backend.scripting.events.StateEvent;
import openfl.text.TextFormat;
import flixel.text.FlxTextBorderStyle;
import flixel.effects.FlxFlicker;

var tV:FlxSprite;
var tvwhite:FlxSprite;

function onCountdown(event) event.cancel();

function postCreate(){
	remove(dad, true);

	tvwhite = new FlxSprite();
    tvwhite.loadGraphic(Paths.image('stages/distraught/ScreenBG'));
	tvwhite.camera = camGame;
	tvwhite.scale.set(0.5, 0.5);
	tvwhite.screenCenter();	
	insert(0, tvwhite);

	tV = new FlxSprite();
	tV.loadGraphic(Paths.image('stages/distraught/TV'));
	tV.camera = camGame;
	tV.scale.set(0.5, 0.5);
	tV.screenCenter();
	insert(3, tV);
	dad.alpha = 0;
	camGame.y = 720;
	hideArrows = false;
	insert(2, dad);
	dad.camera = camGame;
	dad.screenCenter();
	iconP1.setIcon('LYNN_ICONS');
	healthBar.createFilledBar(0xFF241A39, 0xFFF6D9FF);
	healthBar.percent = 49; //forces a update
	healthBar.percent = 50;
}
function update(elapsed:Float) {
	if(dad.alpha == 0) dad.alpha = 0.001;
	if(boyfriend.alpha = 0) boyfriend.alpha = 0.001;
}
function arrowOpacity(opac:Float, time:Float){
	for (i in playerStrums.members) {
		FlxTween.tween(i, {alpha: opac},time, {ease: FlxEase.sineInOut});
	}
}
function camHUDTween(opac:Float, time:Float){
	FlxTween.tween(camHUD, {alpha: opac},time, {ease: FlxEase.sineInOut});
}
function onCameraMove(e) {
	e.cancel();
	e.position.set(650, 400);
}
function onSongStart(){
	FlxTween.tween(camGame, {zoom: 0.5}, 6.35, {ease: FlxEase.sineInOut});
	FlxTween.tween(camGame, {y: 0}, 6.35, {ease: FlxEase.sineInOut});
	comboGroup.x -= 750;
}

function dadAlpha(alp:Float, tim:Float){
	FlxTween.tween(dad, {alpha: alp}, tim, {ease: FlxEase.sineInOut});
}