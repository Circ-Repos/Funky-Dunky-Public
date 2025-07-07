import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import haxe.xml.Access;
import Xml;

var grpMenuItems:FlxTypedGroup<FlxSprite>;
var menuItems:Array<Array<String>> = [];
var grpArrows:FlxTypedGroup<FlxSprite>;

var curSelected:Int = 0;
var curRow:Int = 0;

var allowInputs:Bool = true;

var camFollow:FlxObject;
var bg:FlxSprite;
var bgOverlay:FlxBackdrop;
var boxDesc:FlxSprite;
var special:FlxSprite;

function create()
{
	var xml:Access = new Access(Xml.parse(Paths.assetsTree.getSpecificAsset(Paths.xml('config/credits'), "TEXT")));

	camFollow = new FlxObject(0, 0, 1, 1);
	//camFollow.screenCenter();
	add(camFollow);

	bg = new FlxSprite().loadGraphic(Paths.image('menus/creds/bg'));
	bg.antialiasing = Options.antialiasing;
	bg.scrollFactor.set(0, 0);
	bg.screenCenter();
	add(bg);

	bgOverlay = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0xFFBBBBBB, 0xFF000000));
	bgOverlay.scrollFactor.set(0.5, 0.5);
	bgOverlay.antialiasing = false;
	bgOverlay.velocity.set(0, 40);
	bgOverlay.alpha = 0.1;
	add(bgOverlay);

	boxDesc = new FlxSprite(0, 400).loadGraphic(Paths.image('menus/creds/box-desc'));
	boxDesc.antialiasing = Options.antialiasing;
	boxDesc.screenCenter(FlxAxes.X);
	add(boxDesc);

	grpMenuItems = new FlxTypedGroup();
	add(grpMenuItems);

	var num:Int = 0;
	for(node in xml.elements)
	{
		if(node.name != "credit") continue;

		var portrait:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/creds/' + node.att.icon));
		portrait.antialiasing = Options.antialiasing;
		portrait.screenCenter();
		portrait.ID = num;
		grpMenuItems.add(portrait);
		menuItems.push([node.att.name, node.att.desc, node.att.quote, node.att.url]);
		num = num + 1;
	}

	grpArrows = new FlxTypedGroup();
	add(grpArrows);

	for(i in 0...4)
	{
		var graphic = null;
		if(i == 0 || i == 1) graphic = Paths.image('menus/creds/arrow-hor');
		else graphic = Paths.image('menus/creds/arrow-ver');

		var arrow:FlxSprite = new FlxSprite().loadGraphic(graphic);
		arrow.antialiasing = Options.antialiasing;
		if(i == 0 || i == 1) arrow.screenCenter(FlxAxes.X);
		else arrow.screenCenter(FlxAxes.Y);
		if(i == 0) arrow.flipX = true;
		if(i == 3) arrow.flipY = true;
		arrow.ID = i;
		grpArrows.add(arrow);
	}

	special = new FlxSprite().loadGraphic(Paths.image('menus/creds/special-thanks'));
	special.antialiasing = Options.antialiasing;
	special.screenCenter();
	add(special);
	special.y = special.y + FlxG.height;

	FlxG.camera.follow(camFollow, null, 0.06);

	changeRow(0, false);
	changeSelection(0, false);
}

function update(elapsed)
{
	if(!allowInputs) return;

	grpArrows.forEach(function(spr:FlxSprite)
	{
		if(FlxG.mouse.overlaps(spr))
		{
			var change:Int = 0;
			if(spr.ID == 1 || spr.ID == 3) change = 1;
			else change = -1;

			if(FlxG.mouse.justPressed)
			{
				if(spr.ID == 2 || spr.ID == 3) changeRow(change, true);
				else changeSelection(change, true);
			}
		}
	});

	if(curRow != 1)
	{
		if(controls.LEFT_P) changeSelection(-1, true);
		if(controls.RIGHT_P) changeSelection(1, true);
		if(controls.ACCEPT) confirmSelection();
	}

	if(controls.UP_P || FlxG.mouse.wheel > 0) changeRow(-1, true);
	if(controls.DOWN_P || FlxG.mouse.wheel < 0) changeRow(1, true);

	if(controls.BACK)
	{
		allowInputs = false;
		CoolUtil.playMenuSFX(2, 0.7);
		new FlxTimer().start(0.6, (_) -> FlxG.switchState(new MainMenuState()));
	}
}

function changeSelection(change:Int, playSound:Bool)
{
	var lastSelected:Int = curSelected;
	curSelected = FlxMath.bound(curSelected + change, 0, menuItems.length - 1);
	if(lastSelected == curSelected) return;

	if(playSound) CoolUtil.playMenuSFX(0, 0.7);
	if(curSelected == 0) grpArrows.members[0].alpha = 0.5;
	if(curSelected == menuItems.length - 1) grpArrows.members[1].alpha = 0.5;

	grpMenuItems.forEach(function(spr:FlxSprite)
	{
		FlxTween.cancelTweensOf(spr);
		FlxTween.tween(spr, {x: spr.x - (FlxG.width * change)}, 0.2, {ease: FlxEase.expoOut});
	});
}

function changeRow(change:Int, playSound:Bool)
{
	var lastRow:Int = curRow;
	curRow = FlxMath.bound(curRow + change, 0, 1);
	if(lastRow == curRow) return;

	if(playSound) CoolUtil.playMenuSFX(0, 0.7);
	grpArrows.members[curRow + 2].alpha = 0.5;
	camFollow.y = camFollow.y + (FlxG.height * change);
}

function confirmSelection()
{
	allowInputs = false;
	CoolUtil.playMenuSFX(1, 0.7);
	CoolUtil.openURL(menuItems[curSelected][3]);
	new FlxTimer().start(0.2, (_) -> allowInputs = true);
}

function destroy()
{
	FlxG.mouse.visible = false;
}