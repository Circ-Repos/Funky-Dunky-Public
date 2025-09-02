import flixel.FlxObject;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import flixel.text.FlxTextAlign;
import flixel.text.FlxTextBorderStyle;
import haxe.xml.Access;
import haxe.xml.Parser;
import Xml;
import StringTools;

var access:Xml;
var grpMenuItems:FlxTypedGroup<FlxSprite>;

// Name[0] - Portrait[1] - Role[2] - Quote[3] - URL[4]
var teamData:Array<Array<String>> = [];

var grpArrows:FlxTypedGroup<FlxSprite>;

var curSelected:Int = 0;
var curRow:Int = 0;

var allowInputs:Bool = true;

var camFollow:FlxObject;
var bg:FlxSprite;
var bgOverlay:FlxBackdrop;
var boxDesc:FlxSprite;
var special:FlxSprite;
// would've made another FlxTypedGroup, but this might be easier to deal with
var txtName:FlxText;
var txtRole:FlxText;
var txtDesc:FlxText;

function create()
{
    access = Xml.parse(Assets.getText(Paths.xml('config/credits'))).firstElement();

    if(access != null) parseCreditsXML();

	// FlxG.mouse.visible = true;
	if(FlxG.sound.music == null) CoolUtil.playMenuSong(false);

	camFollow = new FlxObject(0, 0, 1, 1);
	camFollow.screenCenter();
	add(camFollow);

	bg = new FlxSprite().loadGraphic(Paths.image('menus/creds/bg'));
	bg.antialiasing = Options.antialiasing;
	bg.scrollFactor.set(0, 0);
	bg.scale.set(1.15, 1.15);
	bg.updateHitbox();
	bg.screenCenter();
	add(bg);

	FlxG.camera.zoom = 0.9;

	bgOverlay = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0xFFBBBBBB, 0xFF000000));
	bgOverlay.scrollFactor.set(0.5, 0.5);
	bgOverlay.antialiasing = false;
	bgOverlay.velocity.set(0, 40);
	bgOverlay.alpha = 0.1;
	add(bgOverlay);

	grpMenuItems = new FlxTypedGroup();
	add(grpMenuItems);

	boxDesc = new FlxSprite(0, 485).loadGraphic(Paths.image('menus/creds/box-desc'));
	boxDesc.antialiasing = Options.antialiasing;
	boxDesc.screenCenter(FlxAxes.X);
	add(boxDesc);

	// TO-DO: get the correct font? or modify this one? idk...
	txtName = new FlxText(0, boxDesc.y, boxDesc.width - 10, "", 56);
	txtName.setFormat(Paths.font('Times New Roman Italic.ttf'), 56, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	txtName.bold = true;
	txtName.borderSize = 0;
	txtName.underline = true;
	txtName.letterSpacing = 0.8;
	txtName.updateHitbox();
	txtName.screenCenter(FlxAxes.X);
	txtName.antialiasing = Options.antialiasing;
	add(txtName);

	txtRole = new FlxText(0, boxDesc.y + 60, boxDesc.width - 10, "", 36);
	txtRole.setFormat(Paths.font('Times New Roman Italic.ttf'), 36, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	txtRole.bold = true;
	txtRole.borderSize = 0;
	txtRole.letterSpacing = 0.8;
	txtRole.updateHitbox();
	txtRole.screenCenter(FlxAxes.X);
	txtRole.antialiasing = Options.antialiasing;
	add(txtRole);

	// TO-DO: scale text down depending on length
	txtDesc = new FlxText(0, boxDesc.y + 90, boxDesc.width - 7, "", 30);
	txtDesc.setFormat(Paths.font('Times New Roman Italic.ttf'), 30, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	txtDesc.bold = true;
	txtDesc.borderSize = 0;
	txtDesc.borderColor = FlxColor.TRANSPARENT;
	txtDesc.letterSpacing = 0.6;
	txtDesc.updateHitbox();
	txtDesc.screenCenter(FlxAxes.X);
	txtDesc.antialiasing = Options.antialiasing;
	add(txtDesc);

	special = new FlxSprite().loadGraphic(Paths.image('menus/creds/special-thanks'));
	special.antialiasing = Options.antialiasing;
	special.scale.set(0.5, 0.5);
	special.updateHitbox();
	special.screenCenter();
	add(special);
	special.y = special.y + FlxG.height;

	var num:Int = 0;
	for(credit in teamData)
	{
		var portrait:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/creds/' + credit[1]));
		portrait.antialiasing = Options.antialiasing;
		portrait.scale.set(0.7, 0.7);
		portrait.updateHitbox();
		portrait.screenCenter();
		portrait.x = portrait.x + FlxG.width * num;
		portrait.y = portrait.y - 85;
		portrait.ID = num;
		portrait.antialiasing = Options.antialiasing;
		grpMenuItems.add(portrait);
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
		arrow.scrollFactor.set(0, 0);
		if(i == 2 || i == 3)
		{
			arrow.y = arrow.y + 10;
			arrow.screenCenter(FlxAxes.X);
			if(i == 3)
			{
				arrow.flipY = true;
				arrow.y = FlxG.height - arrow.height - 10;
			}
		}
		else
		{
			arrow.x = arrow.x + 10;
			arrow.screenCenter(FlxAxes.Y);
			if(i == 1)
			{
				arrow.flipX = true;
				arrow.x = FlxG.width - arrow.width - 10;
			}
		}
		arrow.ID = i;
		grpArrows.add(arrow);
	}

	FlxG.camera.follow(camFollow, null, 0.1);

	changeRow(0, false);
	changeSelection(0, false);
}

function parseCreditsXML()
{
    for(node in access.elements())
	{
        var name = node.get("name");
        var icon = node.get("icon");
        var role = node.get("desc");
		var quote = node.get("quote");
        var url = node.get("url");
		teamData.push([name, icon, role, quote, url]);
    }
}

function update(elapsed)
{
	if(!allowInputs) return;

//	grpArrows.forEach(function(spr:FlxSprite)
//	{
//		if(FlxG.mouse.overlaps(spr))
//		{
//			var change:Int = 0;
//			if(spr.ID == 1 || spr.ID == 3) change = 1;
//			else change = -1;
//
//			if(FlxG.mouse.justPressed)
//			{
//				if(spr.ID == 2 || spr.ID == 3) changeRow(change, true);
//				else changeSelection(change, true);
//			}
//		}
//	});

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
	curSelected = FlxMath.bound(curSelected + change, 0, teamData.length - 1);

	grpArrows.members[0].alpha = curSelected == 0 ? 0.5 : 1;
	grpArrows.members[1].alpha = curSelected == teamData.length - 1 ? 0.5 : 1;

	txtName.text = teamData[curSelected][0].toUpperCase();
	txtRole.text = teamData[curSelected][2].toUpperCase();
	txtDesc.text = '"' + teamData[curSelected][3] + '"';

	if(lastSelected == curSelected) return;

	allowInputs = false;
	if(playSound) CoolUtil.playMenuSFX(0, 0.7);

	grpMenuItems.forEach(function(spr:FlxSprite)
	{
		FlxTween.cancelTweensOf(spr);
		FlxTween.tween(spr, {x: spr.x - (FlxG.width * change)}, 0.2, {
			ease: FlxEase.expoOut,
			onComplete: (_) -> allowInputs = true
		});
	});
}

function changeRow(change:Int, playSound:Bool)
{
	var lastRow:Int = curRow;
	curRow = FlxMath.bound(curRow + change, 0, 1);

	if(curRow == 1) for(i in 0...2) grpArrows.members[i].alpha = 0.5;
	else changeSelection(0, false);

	grpArrows.members[2].alpha = curRow == 0 ? 0.5 : 1;
	grpArrows.members[3].alpha = curRow == 0 ? 1 : 0.5;

	if(lastRow == curRow) return;

	allowInputs = false;
	if(playSound) CoolUtil.playMenuSFX(0, 0.7);

	camFollow.y = camFollow.y + (FlxG.height * change);
	new FlxTimer().start(0.4, (_) -> allowInputs = true);
}

function confirmSelection()
{
	if(teamData[curSelected][4] == null || teamData[curSelected][4].length < 1) return;
	if(!StringTools.startsWith(teamData[curSelected][4], "https://")) return; // stinky

	allowInputs = false;
	CoolUtil.playMenuSFX(1, 0.7);
	CoolUtil.openURL(teamData[curSelected][4]);
	new FlxTimer().start(0.2, (_) -> allowInputs = true);
}