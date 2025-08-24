import openfl.text.TextFormat;
import flixel.text.FlxTextBorderStyle;

function onCountdown(event) event.cancel();

function onSongEnd() FlxG.save.data.beatenThonk = true;


function postCreate(){
	boyfriend.y -= 700;
	boyfriend.x += 50;
	dad.y -= 650;
	dad.x -= 1000;
	if(gf != null) gf.alpha = 0;
	for (i in playerStrums.members) {
		i.alpha = 1;
	}
	white = new FlxSprite(0,0);
	white.makeGraphic(1920, 1080, FlxColor.WHITE);
	white.screenCenter();
	white.scrollFactor.set();
	white.scale.set(99,99);
	add(white);
	remove(white, true);
	insert(0, white);
}

function arrowOpacity(opac:Float, time:Float){
	for (i in playerStrums.members) {
		FlxTween.tween(i, {alpha: opac},time, {ease: FlxEase.sineInOut});
	}
}
function onCameraMove(e){
	e.cancel();
}