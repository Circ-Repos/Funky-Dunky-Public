import flixel.addons.display.FlxBackdrop;

import funkin.editors.EditorPicker;
import funkin.options.OptionsMenu;
import funkin.menus.ModSwitchMenu;
import funkin.menus.credits.CreditsMain;

var grpMenuItems:FlxTypedGroup<FlxSprite>;
var menuItems:Array<String> = ['story mode', 'freeplay', 'options', 'credits'];

var allowInputs:Bool = true;

var usingMouse:Bool = false;
var mouseNotMovedTime:Float = 0;

var bg:FlxSprite;
var textRight:FlxBackdrop;
var textLeft:FlxBackdrop;
var box:FlxSprite;

function create()
{
	if(FlxG.sound.music == null) CoolUtil.playMenuSong(false);

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

	grpMenuItems = new FlxTypedGroup();
	add(grpMenuItems);

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
		item.ID = num;
		grpMenuItems.add(item);
	}

	changeSelection(0, false);
}

function update(elapsed)
{
	if(!allowInputs) return;

	if(FlxG.keys.justPressed.D) FlxG.save.data.DevMode = !FlxG.save.data.DevMode;

	if(usingMouse)
	{
		grpMenuItems.forEach(function(spr:FlxSprite)
		{
			if(FlxG.mouse.overlaps(spr))
			{
				if(curSelectedMain != spr.ID)
				{
					curSelectedMain = spr.ID;
					changeSelection(0, true);
				}
				if(FlxG.mouse.justPressed) confirmSelection(true);
			}
		});

		mouseNotMovedTime += elapsed;
		if(mouseNotMovedTime > 1.6)
		{
			usingMouse = false;
			FlxG.mouse.visible = false;
		}

		if(usedMouse()) mouseNotMovedTime = 0;
	}
	else if(usedMouse()) usingMouse = true;

	if(controls.SWITCHMOD)
	{
		persistentDraw = true;
		persistentUpdate = false;
		openSubState(new ModSwitchMenu());
	}
	if(FlxG.save.data.DevMode && FlxG.keys.justPressed.SEVEN)
	{
		persistentDraw = true;
		persistentUpdate = false;
		openSubState(new EditorPicker());
	}

	if(controls.DOWN_P || FlxG.mouse.wheel < 0) changeSelection(1, true);
	if(controls.UP_P || FlxG.mouse.wheel > 0) changeSelection(-1, true);

	if(controls.ACCEPT) confirmSelection(true);
	if(controls.BACK)
	{
		allowInputs = false;
		FlxG.sound.music.fadeOut(0.6, 0, function(_) {
			FlxG.sound.music.stop();
		});
		CoolUtil.playMenuSFX(2, 0.7);
		new FlxTimer().start(0.6, (_) -> FlxG.switchState(new TitleState()));
	}
}

function changeSelection(change:Int, playSound:Bool)
{
	if(playSound) CoolUtil.playMenuSFX(0, 0.7);
	curSelectedMain = FlxMath.wrap(curSelectedMain + change, 0, menuItems.length - 1);

	grpMenuItems.forEach(function(spr:FlxSprite)
	{
		spr.animation.play('idle', true);
		if(spr.ID == curSelectedMain) spr.animation.play('selected', true);
	});
}

function confirmSelection(playSound:Bool)
{
	allowInputs = false;
	if(playSound) CoolUtil.playMenuSFX(1, 0.7);

	lastState = MainMenuState;
	new FlxTimer().start(1, (_) -> switch(menuItems[curSelectedMain])
	{
		case 'story mode': FlxG.switchState(new StoryMenuState());
		case 'freeplay': FlxG.switchState(new FreeplayState());
		case 'options': FlxG.switchState(new OptionsMenu());
		case 'credits': FlxG.switchState(new CreditsMain());
	});
}

function usedMouse():Bool
{
	if((FlxG.mouse.deltaScreenX != 0 && FlxG.mouse.deltaScreenY != 0) || FlxG.mouse.justPressed)
	{
		FlxG.mouse.visible = true;
		mouseNotMovedTime = 0;
		return true;
	}
	return false;
}