import flixel.text.FlxTextBorderStyle;
import flixel.text.FlxText;
import flixel.text.FlxTextAlign;

var lyrics:FlxText;

public var subtitleCam = new HudCamera();

function postCreate() {

	FlxG.cameras.add(subtitleCam = new HudCamera(), false);
    subtitleCam.bgColor = 0;

	lyrics = new FlxText(0, 600, 0, "");
	lyrics.alignment = FlxTextAlign.CENTER;
	lyrics.setFormat(Paths.font("VCR.ttf"), 36, FlxColor.WHITE, FlxTextAlign.center);
	if(PlayState.SONG.meta.name.toLowerCase() == 'thonk') lyrics.font = Paths.font('Comic Sans MS.ttf');
	lyrics.setBorderStyle(FlxTextBorderStyle.NONE);
	lyrics.antialiasing = false;
	lyrics.scrollFactor.set(0, 0);
	lyrics.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2, 4);
	lyrics.cameras = [subtitleCam];
	add(lyrics);
    lyrics.screenCenter(FlxAxes.X);
}

function onEvent(event)
{
	if(event.event.name != "Lyrics") return;

	var value1 = event.event.params[0];
    var value2 = event.event.params[1];
	if(value2 != 'mid' && lyrics.y != 600){
		lyrics.x = 0;
		lyrics.y = 600;
		lyrics.setFormat(Paths.font("VCR.ttf"), 36, FlxColor.WHITE, FlxTextAlign.center);
	}
    if (event.event.name == 'Lyrics' && value1 != '')
    {
		lyrics.alpha = 1;
		lyrics.text = value1;
    }
	switch(value2){
		default:
			lyrics.screenCenter(FlxAxes.X);
		case 'mid':
			lyrics.screenCenter();
			lyrics.setFormat(Paths.font("VCR.ttf"), 72, FlxColor.WHITE, FlxTextAlign.center);

	}
	if(value1 == '') FlxTween.tween(lyrics, {alpha: 0},0.8, {ease: FlxEase.linear});
}
