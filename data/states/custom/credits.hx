import flixel.FlxObject;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import flixel.text.FlxTextAlign;
import flixel.text.FlxTextBorderStyle;
//import haxe.xml.Access;
//import Xml;

var grpMenuItems:FlxTypedGroup<FlxSprite>;
// TO-DO: add everyone to the credits
// Name[0] - Role[1] - Quote[2] - URL[3] - Portrait[4]
var menuItems:Array<Array<String>> = [ // (Portrait at the end in case we get XML working so we can remove it)
	["Mortal", "Lead Director", "You should probably subscribe to me on Youtube.", "https://youtu.be/", "mortal"],
	["Mortal 2", "Another One", "There's 2 of them!?!?!?! AAAAAAAHHH-", "https://youtu.be/", "mortal"],
	["Mortal 3", "Whuh Oh!", "Duplication...", "https://youtu.be/", "mortal"]
];
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
    txtDesc = new FlxText(0, boxDesc.y + 120, boxDesc.width - 10, "", 30);
    txtDesc.setFormat(Paths.font('Times New Roman Italic.ttf'), 30, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	txtDesc.bold = true;
	txtDesc.borderSize = 0;
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
	for (credit in menuItems) {
		var portrait:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/creds/' + credit[4]));
		portrait.antialiasing = Options.antialiasing;
		portrait.scale.set(0.7, 0.7);
		portrait.updateHitbox();
		portrait.screenCenter();
		portrait.x = portrait.x + FlxG.width * num;
		portrait.y = portrait.y - 85;
		portrait.ID = num;
		grpMenuItems.add(portrait);
		num = num + 1;
	}

//	var num:Int = 0;
//	var xml:Access = new Access(Xml.parse(Paths.xml('config/credits')));
//	var xmlString = Paths.xml('config/credits');
//	if (xmlString == null) {
//		trace("ERROR: Could not load config/credits.xml!");
//	} else {
//		var rawXml = Xml.parse(xmlString);
//		var root = rawXml.firstElement(); // This is <menu>
//		if (root == null) {
//			trace("ERROR: Root node is null!");
//		} else {
//			for (credit in root.elementsNamed("credit")) {
//        		var node = new Access(credit);
//				var portrait:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/creds/' + node.att.icon));
//				portrait.antialiasing = Options.antialiasing;
//				portrait.screenCenter();
//				portrait.ID = num;
//				grpMenuItems.add(portrait);
//				menuItems.push([node.att.name, node.att.desc, node.att.quote, node.att.url]);
//				num = num + 1;
//			}
//		}
//	}
//	trace("Loaded XML: " + xmlString);

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
	curSelected = FlxMath.bound(curSelected + change, 0, menuItems.length - 1);

	grpArrows.members[0].alpha = curSelected == 0 ? 0.5 : 1;
	grpArrows.members[1].alpha = curSelected == menuItems.length - 1 ? 0.5 : 1;

	txtName.text = menuItems[curSelected][0].toUpperCase();
	txtRole.text = menuItems[curSelected][1].toUpperCase();
	txtDesc.text = '"' + menuItems[curSelected][2] + '"';

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
	allowInputs = false;
	CoolUtil.playMenuSFX(1, 0.7);
	CoolUtil.openURL(menuItems[curSelected][3]);
	new FlxTimer().start(0.2, (_) -> allowInputs = true);
}

function destroy()
{
	FlxG.mouse.visible = false;
}