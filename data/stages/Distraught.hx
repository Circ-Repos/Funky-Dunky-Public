import funkin.backend.scripting.events.StateEvent;
import openfl.text.TextFormat;
import flixel.text.FlxTextBorderStyle;
import flixel.effects.FlxFlicker;

var tV:FlxSprite;
var tvwhite:FlxSprite;

function onCountdown(event) event.cancel();

function postCreate(){
    camTV = new FlxCamera();
    camTV.visible = true;
    camTV.alpha = 1;
	camTV.bgColor = 0;
    FlxG.cameras.remove(camHUD, false);

    FlxG.cameras.remove(camTV, false);
    FlxG.cameras.add(camTV, false);
	FlxG.cameras.add(camHUD, false);
	camTV.zoom = 0.001;
	remove(boyfriend, true);
	remove(gf, true);
	remove(dad, true);

	tvwhite = new FlxSprite();
    tvwhite.loadGraphic(Paths.image('stages/distraught/ScreenBG'));
	tvwhite.camera = camTV;
	tvwhite.scale.set(0.5, 0.5);
	tvwhite.screenCenter();	
	insert(0, tvwhite);

	tV = new FlxSprite();
	tV.loadGraphic(Paths.image('stages/distraught/TV'));
	tV.camera = camTV;
	tV.scale.set(0.5, 0.5);
	tV.screenCenter();
	insert(3, tV);
	dad.alpha = 0;
	camTV.y = 720;

	hideArrows = false;
	insert(2, dad);
	dad.camera = camTV;
	dad.screenCenter();
	iconP1.setIcon('LYNN_ICONS');
	healthBar.createFilledBar(0xFF241A39, 0xFFF6D9FF);
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
}
function onSongStart(){
	FlxTween.tween(camTV, {zoom: 0.5}, 6.35, {ease: FlxEase.sineInOut});
	FlxTween.tween(camTV, {y: 0}, 6.35, {ease: FlxEase.sineInOut});
	comboGroup.x -= 450;
	comboGroup.camera = camTV;
}

function dadAlpha(alp:Float, tim:Float){
	FlxTween.tween(dad, {alpha: alp}, tim, {ease: FlxEase.sineInOut});
}
