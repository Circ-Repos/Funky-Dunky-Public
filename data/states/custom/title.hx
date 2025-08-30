import flixel.tweens.FlxEase;
import flixel.tweens.FlxTweenType;

function create()
{
	clouds = new FlxSprite().loadGraphic(Paths.image("menus/theFUCKINGtitle/sky"));
	clouds.screenCenter();
	clouds.scale.set(0.55, 0.55);
	clouds.antialiasing = Options.antialiasing;
	add(clouds);

	clouds2 = new FlxSprite().loadGraphic(Paths.image("menus/theFUCKINGtitle/sky"));
	clouds2.screenCenter();
	clouds2.alpha = 0.4;
	clouds2.scale.set(0.55, 0.55);
	clouds2.color = 0x000000;
	clouds2.antialiasing = Options.antialiasing;
	add(clouds2);

	trees = new FlxSprite().loadGraphic(Paths.image("menus/theFUCKINGtitle/Trees"));
	trees.screenCenter();
	trees.scale.set(0.55, 0.55);
	trees.antialiasing = Options.antialiasing;
	add(trees);

	funkleDunkle = new FlxSprite(0, -450).loadGraphic(Paths.image("menus/theFUCKINGtitle/fcr"));
	funkleDunkle.screenCenter(FlxAxes.X);
	funkleDunkle.scale.set(0.65, 0.65);
	funkleDunkle.antialiasing = Options.antialiasing;
	add(funkleDunkle);

	pressTheButtonOk = new FlxSprite(0, -425).loadGraphic(Paths.image("menus/theFUCKINGtitle/press_enter"));
	pressTheButtonOk.screenCenter(FlxAxes.X);
	pressTheButtonOk.scale.set(0.65, 0.65);
	pressTheButtonOk.antialiasing = Options.antialiasing;
	add(pressTheButtonOk);

	theMysteriousDot = new FlxSprite(-630, -475).loadGraphic(Paths.image("menus/theFUCKINGtitle/dot"));
	theMysteriousDot.scale.set(0.65, 0.65);
	theMysteriousDot.antialiasing = Options.antialiasing;
	add(theMysteriousDot);

	for(e in [pressTheButtonOk, theMysteriousDot])
	{
		FlxTween.tween(e, {alpha: 0}, 2, {ease: FlxEase.sineInOut, type: FlxTweenType.PINGPONG});
	}

	FlxG.camera.fade(FlxColor.BLACK, 1, true);
	if(FlxG.sound.music != null) FlxG.sound.music.stop();
	CoolUtil.playMusic(Paths.music("titlescreen-ambience"), false, 0, true);
	FlxG.sound.music.fadeIn(1, 0, 1);
}

var accepted:Bool = false;
function update()
{
	if(controls.ACCEPT && !accepted)
	{
		accepted = true;
		for(e in [pressTheButtonOk, theMysteriousDot, funkleDunkle])
		{
			FlxG.sound.music.fadeOut(1, 0, function(_) {
				FlxG.sound.music.stop();
			});
			FlxTween.cancelTweensOf(e);
			e.alpha = 1;
			FlxTween.tween(e, {alpha: 0}, 1.4, {ease: FlxEase.sineInOut});
			FlxTween.tween(e.scale, {x: 0.001, y: 0.001}, 1.4, {ease: FlxEase.sineInOut});
			for(a in [clouds])
			{
				FlxTween.tween(a, {alpha: 0}, 1.4, {
					ease: FlxEase.sineInOut,
					onComplete: (_) -> FlxG.switchState(new MainMenuState())
				});
				FlxTween.tween(FlxG.camera, {zoom: 2.4}, 1.4, {ease: FlxEase.sineInOut});
			}
		}
	}
}