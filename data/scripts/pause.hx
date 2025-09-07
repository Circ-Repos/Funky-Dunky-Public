import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import flixel.text.FlxTextAlign;
import openfl.filters.BlurFilter;
import funkin.backend.system.framerate.Framerate;
import StringTools;

var grpMenuItems:FlxTypedGroup<FlxText>;
var menuItems:Array<String> = ['resume', 'restart song', 'change controls', 'change options', 'exit to menu'];
var camPause:FlxCamera;
var sigmaBlur:BlurFilter;

var allowInputs:Bool = false;

var bg:FlxSprite;
var bgOverlay:FlxBackdrop;
var songArt:FlxSprite;
var arrow:FlxSprite;
var pauseText:FlxText;
var songText:FlxText;
var deathsText:FlxText;
var overlay:FlxSprite;

var songName:String = PlayState.SONG.meta.name.toLowerCase();

function create(event)
{
	event.cancel();

	FlxTween.tween(Framerate.offset, {x: 17, y: 16}, 0.3, {ease: FlxEase.quadInOut});

	switch(songName) // useful for song variations that don't edit too much ig?
	{
		case 'think-(og)': songName = 'think';
	}

	sigmaBlur = new BlurFilter(0, 0);
	sigmaBlur.quality = 2;

	// using FlxG.cameras.list lags the game for some reason
	var cams:Array<FlxCamera> = [FlxG.camera, game.camHUD];

	switch(songName)
	{
		case 'think':
			cams.push(camThink);
			cams.push(camThinkB);
	}

	for(cam in cams)
	{
		if(cam != null) cam.setFilters([sigmaBlur]);
	}

	FlxTween.tween(sigmaBlur, {blurX: 6, blurY: 6}, 0.4, {ease: FlxEase.quartInOut});

	camPause = new FlxCamera();
	camPause.bgColor = 0x00000000;
	FlxG.cameras.add(camPause, false);
	camPause.alpha = 0;
	cameras = [camPause];

	var dbg:FlxSprite = new FlxSprite().makeSolid(FlxG.width + 100, FlxG.height + 100, FlxColor.BLACK);
	dbg.antialiasing = false;
	dbg.alpha = 0;
	dbg.scrollFactor.set();
	dbg.updateHitbox();
	dbg.screenCenter();
	add(dbg);

	FlxTween.tween(dbg, {alpha: 0.4}, 0.4, {ease: FlxEase.quartInOut});

	bg = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
	bg.antialiasing = false;
	bg.alpha = 0.2;
	bg.scrollFactor.set(0, 0);
	bg.scale.set(FlxG.width + 10, FlxG.height + 10);
	bg.updateHitbox();
	bg.screenCenter();
	add(bg);

	bgOverlay = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0xFFBBBBBB, 0xFF000000));
	bgOverlay.cameras = [camPause];
	bgOverlay.antialiasing = false;
	bgOverlay.velocity.set(0, 40);
	bgOverlay.alpha = 0;
	add(bgOverlay);

	FlxTween.tween(bgOverlay, {alpha: 0.1}, 0.4, {ease: FlxEase.quartInOut});

	songArt = new FlxSprite(0, 0).loadGraphic(Paths.image('game/pause/' + songName));
	songArt.antialiasing = Options.antialiasing;
	songArt.cameras = [camPause];
	songArt.scale.set(0.3, 0.3);
	songArt.updateHitbox();
	add(songArt);
	// this is the transformation point, right???
	// the idea is to set that to the bottom right and then place the art on a specific spot,
	// so we don't have to manually adjust the pos on every image
	songArt.origin.set(songArt.width * 0.3, songArt.height * 0.3); // ok cne. i see how it is.
	// the corner of the overlay is on x: 1216 | y: 658
	songArt.setPosition(1216 - 13, 658 - 13); // offset, because it's still not perfectly in the corner

	lineLeft = new FlxSprite(songArt.x - songArt.width + 13, songArt.y - songArt.height + 14).makeGraphic(4, songArt.height, FlxColor.WHITE);
	lineLeft.antialiasing = false;
	lineLeft.cameras = [camPause];
	add(lineLeft);

	lineTop = new FlxSprite(songArt.x - songArt.width + 14, songArt.y - songArt.height + 14).makeGraphic(songArt.width, 4, FlxColor.WHITE);
	lineTop.antialiasing = false;
	lineTop.cameras = [camPause];
	add(lineTop);

	lineRight = new FlxSprite(songArt.x + 13, songArt.y - songArt.height + 14).makeGraphic(4, songArt.height, FlxColor.WHITE);
	lineRight.antialiasing = false;
	lineRight.cameras = [camPause];
	add(lineRight);

	switch(songName) // for manual adjustments
	{
		case 'scary-night':
			songArt.x -= 5;
		case 'gift':
			songArt.setPosition(songArt.x + 44, songArt.y + 43);
			lineLeft.scale.y = 0.87;
			lineLeft.setPosition(lineLeft.x + 88, lineLeft.y + 23);
			lineRight.scale.y = 0.87;
			lineRight.y += 23;
			lineTop.scale.x = 0.78;
			lineTop.setPosition(lineTop.x + 46, lineTop.y + 46);
	}

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
	//changed the switch cause it might try to check again after doing it once, idk
	switch(PlayState.instance.cpuStrums.characters[0].curCharacter.toLowerCase()) // is there a better way to do this???
	{ //i dont think theres a better way to do it
		case 'ceaser-gift' | 'ceaser' | 'og-cesar' | 'ceaser-alt-gift': charName = 'cesar';
		case 'gabriel-false' | 'gabriel-true': charName = 'gabriel';
		case 'alternate-gift': charName = 'alternate';
		case 'intruder-dream' | 'six': charName = 'intruder';
		case 'lil-mark-dream': charName = 'lil mark';
		case 'og-mark': charName = 'mark';
		default: charName = StringTools.replace(PlayState.instance.cpuStrums.characters[0].curCharacter.toLowerCase(), '-', ' ');
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
	if(pauseMusic != null && pauseMusic.volume < 0.7)
	{
		pauseMusic.volume += 0.05 * elapsed;
		//trace('curr volume: ' + pauseMusic.volume);
	}

	if(!allowInputs) return;

	if(controls.DOWN_P) changeSelection(1);
	if(controls.UP_P) changeSelection(-1);
	if(controls.ACCEPT) confirmSelection(true);
	if(controls.BACK)
	{
		curSelected = 0;
		CoolUtil.playMenuSFX(2, 0.4);
		confirmSelection(false);
	}
}

function changeSelection(change:Int)
{
	if(change != 0) CoolUtil.playMenuSFX(0, 0.4);
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
	if(playSound) CoolUtil.playMenuSFX(1, 0.4);

	lastState = PlayState;
	switch(menuItems[curSelected])
	{
		case 'change controls':
			allowInputs = true;
			selectOption();
		case 'restart song':
			FlxTween.tween(Framerate.offset, {x: 0, y: 0}, 0.3, {ease: FlxEase.quadInOut});
			grpMenuItems.forEach(function(txt:FlxText) {
				FlxTween.cancelTweensOf(txt);
			});
			new FlxTimer().start(0.4, function(_) {
				game.persistentUpdate = true;
				game.canPause = false;
				FlxTween.tween(sigmaBlur, {blurX: 0, blurY: 0}, 0.2, {
					ease: FlxEase.sineInOut,
				});
				FlxTween.tween(camPause, {alpha: 0}, 0.2, {
					ease: FlxEase.sineInOut,
					onComplete: function(){
						new FlxTimer().start(0.7, function(_) {
							selectOption();
						});
					}
				});

				FlxTween.num(game.health, 1, 0.7, {ease: FlxEase.expoIn}, function(val){
					game.health = val;
				});

				for(strum in game.strumLines.members){
					for(no in strum.notes){
						no.updateNotesPosY = false;
						FlxTween.tween(no, {y: no.y + 1280}, 0.7, {startDelay: 0.2, ease: FlxEase.expoIn});
					}
				}
			});
		default:
			FlxTween.tween(Framerate.offset, {x: 0, y: 0}, 0.3, {ease: FlxEase.quadInOut});
			grpMenuItems.forEach(function(txt:FlxText) {
				FlxTween.cancelTweensOf(txt);
			});
			new FlxTimer().start(0.4, function(_) {
				FlxTween.tween(sigmaBlur, {blurX: 0, blurY: 0}, 0.2, {
					ease: FlxEase.sineInOut,
				});
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
	if(camPause != null)
	{
		if(FlxG.cameras.list.contains(camPause))
			FlxG.cameras.remove(camPause);
		camPause.destroy();
	}

	sigmaBlur.blurX = 0;
	sigmaBlur.blurY = 0;
	Framerate.offset.y = 0;
	Framerate.offset.x = 0;
}