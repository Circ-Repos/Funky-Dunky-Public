import flixel.addons.display.FlxBackdrop; // i'll be so fr, idk how imports work in CNE, lmao
import flixel.addons.display.FlxGridOverlay;
import flixel.text.FlxTextAlign;
import StringTools; // <- The reason I don't like CNE

var grpMenuItems:FlxTypedGroup<FlxText>;
var menuItems:Array<String> = ['resume', 'restart song', 'change controls', 'change options', 'botplay', 'exit to menu'];
var camPause:FlxCamera;

var allowInputs:Bool = false;

var bg:FlxBackdrop;
var songArt:FlxSprite;
var arrow:FlxSprite;
var pauseText:FlxText;
var songText:FlxText;
var deathsText:FlxText;
var overlay:FlxSprite;

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

	/*songArt = new FlxSprite(0, 0).loadGraphic(Paths.image('game/pause/alternate'));
	songArt.antialiasing = Options.antialiasing;
	songArt.cameras = [camPause];
	songArt.updateHitbox();
	add(songArt);
	songArt.offset.set(songArt.width, songArt.height);
	songArt.setPosition(500, 500);*/

	pauseText = new FlxText(80, 86, 0, 'PAUSED', 80);
	pauseText.setFormat(Paths.font("vcr.ttf"), 80);
	pauseText.antialiasing = false;
	pauseText.cameras = [camPause];
	add(pauseText);

	grpMenuItems = new FlxTypedGroup();
	add(grpMenuItems);

	for(num => option in menuItems)
	{
		var text:FlxText = new FlxText(80, 182 + (80 * num), 0, option.toUpperCase(), 48);
		text.setFormat(Paths.font("vcr.ttf"), 48);
		text.antialiasing = false;
		text.cameras = [camPause];
		text.ID = num;
		grpMenuItems.add(text);
		updateBotplayText(num);
	}

	arrow = new FlxSprite(200, 182).loadGraphic(Paths.image('game/pause/arrow'));
	arrow.cameras = [camPause];
	arrow.antialiasing = false;
	arrow.scale.set(4, 4);
	arrow.updateHitbox();
	add(arrow);

	var charName:String = PlayState.instance.cpuStrums.characters[0].curCharacter.toLowerCase();
	switch(charName) // is there a better way to do this???
	{
		case 'ceaser-gift' | 'ceaser' | 'og-cesar': charName = 'cesar';
		case 'gabriel-false' | 'gabriel-true': charName = 'gabriel';
		case 'alternate-gift': charName = 'alternate';
		case 'intruder-dream': charName = 'intruder';
		case 'lil-mark-dream': charName = 'lil mark';
		case 'og-mark': charName = 'mark';
		default: charName = StringTools.replace(charName, '-', ' ');
	}
	songText = new FlxText(0, 80, FlxG.width - 90, PlayState.SONG.meta.displayName.toUpperCase() + ' - ' + charName.toUpperCase(), 40);
	songText.setFormat(Paths.font("vcr.ttf"), 40, FlxColor.WHITE, FlxTextAlign.RIGHT);
	songText.antialiasing = false;
	songText.cameras = [camPause];
	add(songText);

	deathsText = new FlxText(0, 125, FlxG.width - 90, 'EYES OPENED: ' + PlayState.deathCounter + ' TIMES', 40);
	deathsText.setFormat(Paths.font("vcr.ttf"), 40, FlxColor.WHITE, FlxTextAlign.RIGHT);
	deathsText.antialiasing = false;
	deathsText.cameras = [camPause];
	add(deathsText);

	overlay = new FlxSprite().loadGraphic(Paths.image('game/pause/overlay'));
	overlay.antialiasing = false;
	overlay.cameras = [camPause];
	overlay.screenCenter();
	add(overlay);

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

	grpMenuItems.forEach(function(txt:FlxText)
	{
		FlxTween.cancelTweensOf(txt);
		if(txt.ID == curSelected)
		{
			FlxTween.tween(txt, {x: 120}, 0.1, {ease: FlxEase.sineInOut});
			arrow.setPosition(txt.width + 120, txt.y + 2);
		}
		else FlxTween.tween(txt, {x: 80}, 0.1, {ease: FlxEase.sineInOut});
		updateBotplayText(txt.ID);
	});
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
		case 'botplay':
			allowInputs = true;
			curBotplay = !curBotplay;
			updateBotplayText(curSelected);
			changeSelection(0);
		default:
			if(menuItems[curSelected] == 'exit to menu') curSelected -= 1;
			grpMenuItems.forEach(function(txt:FlxText) {
				FlxTween.cancelTweensOf(txt);
			});
			new FlxTimer().start(0.4, function(_) {
				FlxTween.tween(camPause, {alpha: 0}, 0.2, {
					ease: FlxEase.sineInOut,
					onComplete: (_) -> selectOption()
				});
			});
	}
}

function updateBotplayText(num)
{
	if(menuItems[num] == 'botplay')
	{
		var botCondition:String = 'FALSE';
		if(curBotplay) botCondition = 'TRUE';
		grpMenuItems.members[num].text = 'BOTPLAY: ' + botCondition;
	}
}

function destroy()
{
	if(FlxG.cameras.list.contains(camPause))
		FlxG.cameras.remove(camPause);
}