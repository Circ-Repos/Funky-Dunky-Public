import flixel.addons.display.FlxBackdrop; // i'll be so fr, idk how imports work in CNE, lmao
import flixel.addons.display.FlxGridOverlay;

var grpMenuItems:Array<FlxText> = [];
var menuItems:Array<String> = ['resume', 'restart song', 'change controls', 'change options', 'exit to menu'];
var camPause:FlxCamera;

var allowInputs:Bool = false;

var bg:FlxBackdrop;
var alternate:FlxSprite;
var overlay:FlxSprite;
var arrow:FlxSprite;
var pauseText:FlxText;

function create(event)
{
	event.cancel();

	camPause = new FlxCamera();
	camPause.bgColor = 0x00000000;
	FlxG.cameras.add(camPause, false);
	camPause.alpha = 0;
	cameras = [camPause];

	bg = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0xFFBBBBBB, 0xFF000000));
	bg.cameras = [camPause];
	bg.antialiasing = false;
	bg.velocity.set(0, 40);
	bg.alpha = 0.1;
	add(bg);

	alternate = new FlxSprite(784, 214).loadGraphic(Paths.image('game/pause/alternate'));
	alternate.antialiasing = Options.antialiasing;
	alternate.cameras = [camPause];
	add(alternate);

	overlay = new FlxSprite().loadGraphic(Paths.image('game/pause/overlay'));
	overlay.antialiasing = false;
	overlay.cameras = [camPause];
	overlay.screenCenter();
	add(overlay);

	pauseText = new FlxText(80, 86, 0, 'PAUSED', 80);
	pauseText.setFormat(Paths.font("vcr.ttf"), 80);
	pauseText.antialiasing = false;
	pauseText.cameras = [camPause];
	add(pauseText);

	for(num => option in menuItems)
	{
		var text:FlxText = new FlxText(80, 182 + (96 * num), 0, option.toUpperCase(), 48);
		text.setFormat(Paths.font("vcr.ttf"), 48);
		text.antialiasing = false;
		text.cameras = [camPause];
		add(text);
		grpMenuItems.push(text);
	}

	arrow = new FlxSprite(200, 182).loadGraphic(Paths.image('game/pause/arrow'));
	arrow.cameras = [camPause];
	arrow.antialiasing = false;
	arrow.scale.set(4, 4);
	arrow.updateHitbox();
	add(arrow);

	changeSelection(0);

	FlxTween.tween(camPause, {alpha: 1}, 0.2, {
		ease: FlxEase.sineInOut,
		onComplete: function(_) {
			allowInputs = true;
		}
	});
}

function update(elapsed)
{
	if(!allowInputs) return;

	if(controls.DOWN_P) changeSelection(1);
	if(controls.UP_P) changeSelection(-1);
	if(controls.ACCEPT) confirmSelection(true);
	if(controls.BACK)
	{
		curSelected = 0;
		CoolUtil.playMenuSFX(2, 0.7);
		confirmSelection(false);
	}
}

function changeSelection(change:Int)
{
	if(change != 0) CoolUtil.playMenuSFX(0, 0.7);
	curSelected = FlxMath.wrap(curSelected + change, 0, menuItems.length - 1);

	for(num => item in grpMenuItems)
	{
		FlxTween.cancelTweensOf(item);
		if(num == curSelected)
		{
			FlxTween.tween(item, {x: 120}, 0.1, {ease: FlxEase.sineInOut});
			arrow.setPosition(item.width + 120, item.y + 2);
		}
		else FlxTween.tween(item, {x: 80}, 0.1, {ease: FlxEase.sineInOut});
	}
}

function confirmSelection(playSound:Bool)
{
	allowInputs = false;
	if(playSound) CoolUtil.playMenuSFX(1, 0.7);

	switch(menuItems[curSelected])
	{
		case 'change controls':
			allowInputs = true;
			selectOption();
		default:
			for(num => item in grpMenuItems) FlxTween.cancelTweensOf(item);
			new FlxTimer().start(0.4, function(_) {
				FlxTween.tween(camPause, {alpha: 0}, 0.2, {
					ease: FlxEase.sineInOut,
					onComplete: (_) -> selectOption()
				});
			});
	}
}

function destroy()
{
	if(FlxG.cameras.list.contains(camPause))
		FlxG.cameras.remove(camPause);
}