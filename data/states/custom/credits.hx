import flixel.FlxObject;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import flixel.text.FlxTextAlign;
import flixel.text.FlxTextBorderStyle;
import flixel.tweens.FlxTweenType;
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
	special.scrollFactor.set(0, 1);
	special.scale.set(0.5, 0.5);
	special.updateHitbox();
	special.screenCenter();
	add(special);
	special.y = special.y + FlxG.height;

	for(num => credit in teamData)
	{
		var path:String = Paths.image('menus/creds/peeps/' + credit[1]);
		var portrait:FlxSprite = new FlxSprite();
		if(!Assets.exists(path)) portrait.frames = Paths.getSparrowAtlas('menus/creds/missing');
		else portrait.frames = Paths.getSparrowAtlas('menus/creds/peeps/' + credit[1]);
		portrait.animation.addByPrefix("normal", "normal", 12, true);
		portrait.animation.addByPrefix("alternate", "alternate", 12, true);
		portrait.antialiasing = false; //Options.antialiasing; //unsure if it should be on or off with these portraits
		portrait.updateHitbox();
		portrait.screenCenter();
		portrait.x += (FlxG.width / 2) * num;
		portrait.y -= 85;
		portrait.ID = num;
		if(num != curSelected)
		{
			portrait.alpha = 0.6;
			portrait.animation.play("alternate", true);
		}
		else
		{
			portrait.scale.set(1.4, 1.4);
			portrait.animation.play("normal", true);
		}
		grpMenuItems.add(portrait);
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
			arrow.y += 10;
			arrow.screenCenter(FlxAxes.X);
			if(i == 3)
			{
				arrow.flipY = true;
				arrow.y = FlxG.height - arrow.height - 10;
			}
		}
		else
		{
			arrow.x += 10;
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

	// there's probably a way to optimize this better... but i'm lazy rn :]
	for(i in 0...2)
	{
		FlxTween.cancelTweensOf(grpArrows.members[i]);
		grpArrows.members[i].x = i == 0 ? 10 : FlxG.width - grpArrows.members[i].width - 10;
	}

	if(curSelected != 0)
	{
		FlxTween.tween(grpArrows.members[0], {x: grpArrows.members[0].x - 20}, 1, {
			type: FlxTweenType.PINGPONG,
			ease: FlxEase.quadInOut
		});
	}

	if(curSelected != teamData.length - 1)
	{
		FlxTween.tween(grpArrows.members[1], {x: grpArrows.members[1].x + 20}, 1, {
			type: FlxTweenType.PINGPONG,
			ease: FlxEase.quadInOut
		});
	}

	txtName.text = teamData[curSelected][0].toUpperCase();
	txtRole.text = teamData[curSelected][2].toUpperCase();
	txtDesc.text = '"' + teamData[curSelected][3] + '"';

	if(lastSelected == curSelected) return;

	allowInputs = false;
	if(playSound) CoolUtil.playMenuSFX(0, 0.7);

	grpMenuItems.forEach(function(spr:FlxSprite)
	{
		FlxTween.cancelTweensOf(spr);
		if(spr.ID == curSelected)
		{
			FlxTween.tween(spr, {x: spr.x - ((FlxG.width / 2) * change), "scale.x": 1.4, "scale.y": 1.4, alpha: 1}, 0.2, {
				ease: FlxEase.expoOut,
				onComplete: (_) -> allowInputs = true
			});
			spr.animation.play("normal", true);
		}
		else
		{
			FlxTween.tween(spr, {x: spr.x - ((FlxG.width / 2) * change), "scale.x": 1, "scale.y": 1, alpha: 0.6}, 0.2, {
				ease: FlxEase.expoOut,
				onComplete: (_) -> allowInputs = true
			});
			spr.animation.play("alternate", true);
		}
	});
}

function changeRow(change:Int, playSound:Bool)
{
	var lastRow:Int = curRow;
	curRow = FlxMath.bound(curRow + change, 0, 1);

	if(curRow == 1)
	{
		for(i in 0...2)
		{
			grpArrows.members[i].alpha = 0.5;
			FlxTween.cancelTweensOf(grpArrows.members[i]);
			grpArrows.members[i].x = i == 0 ? 10 : FlxG.width - grpArrows.members[i].width - 10;
		}
	}
	else changeSelection(0, false);

	grpArrows.members[2].alpha = curRow == 0 ? 0.5 : 1;
	grpArrows.members[3].alpha = curRow == 0 ? 1 : 0.5;

	for(i in 2...4)
	{
		FlxTween.cancelTweensOf(grpArrows.members[i]);
		grpArrows.members[i].y = i == 2 ? 10 : FlxG.height - grpArrows.members[i].height - 10;
	}

	if(curRow != 0)
	{
		FlxTween.tween(grpArrows.members[2], {y: grpArrows.members[2].y - 20}, 1, {
			type: FlxTweenType.PINGPONG,
			ease: FlxEase.quadInOut
		});
	}

	if(curRow != 1)
	{
		FlxTween.tween(grpArrows.members[3], {y: grpArrows.members[3].y + 20}, 1, {
			type: FlxTweenType.PINGPONG,
			ease: FlxEase.quadInOut
		});
	}

	if(lastRow == curRow) return;

	allowInputs = false;
	if(playSound) CoolUtil.playMenuSFX(0, 0.7);

	camFollow.y += (FlxG.height * change);
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