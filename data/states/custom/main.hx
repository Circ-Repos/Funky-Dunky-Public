import flixel.addons.display.FlxBackdrop;

import funkin.options.OptionsMenu;
import funkin.menus.ModSwitchMenu;
import funkin.menus.credits.CreditsMain;

var grpMenuItems:Array<FlxSprite> = [];
var menuItems:Array<String> = ['story mode', 'freeplay', 'options', 'credits'];
var curSelected:Int = 0;

var allowInputs:Bool = true;

var bg:FlxSprite;
var textRight:FlxBackdrop;
var textLeft:FlxBackdrop;
var box:FlxSprite;

function create()
{
	if(FlxG.sound.music != null) FlxG.sound.music.stop();
	CoolUtil.playMenuSong(false);

	FlxG.mouse.useSystemCursor = true;
	FlxG.mouse.visible = true;

	bg = new FlxSprite().loadGraphic(Paths.image('menus/main/bg'));
	bg.antialiasing = Options.antialiasing;
	bg.screenCenter();
	add(bg);

	var textGraph = Paths.image('menus/main/text');
	textRight = new FlxBackdrop(textGraph, FlxAxes.XY, 10, 99);
	textRight.antialiasing = Options.antialiasing;
	textRight.velocity.set(40, 0);
	textRight.y = -34;
	add(textRight);

	textLeft = new FlxBackdrop(textGraph, FlxAxes.XY, 10, 99);
	textLeft.antialiasing = Options.antialiasing;
	textLeft.velocity.set(-40, 0);
	textLeft.y = 65;
	add(textLeft);

	box = new FlxSprite().loadGraphic(Paths.image('menus/main/box'));
	box.antialiasing = Options.antialiasing;
	box.screenCenter();
	add(box);

	for(num => option in menuItems)
	{
		var item:FlxSprite = new FlxSprite(0, 220 + (120 * num));
		item.frames = Paths.getSparrowAtlas('menus/main/' + option);
		item.animation.addByPrefix('idle', option + ' idle', 0, false);
		item.animation.addByPrefix('selected', option + ' selected', 0, false);
		item.animation.play('idle', true);
		item.updateHitbox();
		item.antialiasing = Options.antialiasing;
		item.screenCenter(FlxAxes.X);
		add(item);
		grpMenuItems.push(item);
	}

	changeSelection(0, false);
}

function update(elapsed)
{
	if(!allowInputs) return;

	for(num => item in grpMenuItems)
	{
		if(!FlxG.mouse.overlaps(item)) continue;

		if(curSelected != num)
		{
			curSelected = num;
			changeSelection(0, true);
		}
		if(FlxG.mouse.justPressed) confirmSelection(true);
	}

	if(controls.SWITCHMOD)
	{
		persistentDraw = true;
		persistentUpdate = false;
		openSubState(new ModSwitchMenu());
	}

	if(controls.DOWN_P || FlxG.mouse.wheel < 0) changeSelection(1, true);
	if(controls.UP_P || FlxG.mouse.wheel > 0) changeSelection(-1, true);
	if(controls.ACCEPT) confirmSelection(true);
	if(controls.BACK)
	{
		allowInputs = false;
		CoolUtil.playMenuSFX(2, 0.7);
		new FlxTimer().start(0.6, (_) -> FlxG.switchState(new TitleState()));
	}
}

function changeSelection(change:Int, playSound:Bool)
{
	if(playSound) CoolUtil.playMenuSFX(0, 0.7);
	curSelected = FlxMath.wrap(curSelected + change, 0, menuItems.length - 1);

	for(num => item in grpMenuItems)
	{
		item.animation.play('idle', true);
		if(num == curSelected) item.animation.play('selected', true);
	}
}

function confirmSelection(playSound:Bool)
{
	allowInputs = false;
	if(playSound) CoolUtil.playMenuSFX(1, 0.7);

	new FlxTimer().start(1, (_) -> switch(menuItems[curSelected])
	{
		case 'story mode': FlxG.switchState(new StoryMenuState());
		case 'freeplay': FlxG.switchState(new FreeplayState());
		case 'options': FlxG.switchState(new OptionsMenu());
		case 'credits': FlxG.switchState(new CreditsMain());
	});
}

function destroy()
{
	FlxG.mouse.visible = false;
}