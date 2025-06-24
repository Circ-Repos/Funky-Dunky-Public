import funkin.editors.charter.Charter;
import funkin.game.PlayState;
import flixel.text.FlxTextAlign;
import flixel.text.FlxTextBorderStyle;
import flixel.math.FlxBasePoint;
import funkin.backend.system.framerate.SystemInfo;

static var curBotplay:Bool = false;
public var botplayTxt:FlxText;

var theSysBool:Bool = false;
var systemInfoText:FlxText;

//free cam movement
var camFreeMoving:Bool = false;
var camCoords:FlxText;

//camera dedicated for any debug info
var camOther:FlxCamera;
var instructions:FlxText;

function postCreate()
{
	camOther = new FlxCamera();
	camOther.bgColor = 0x00000000;
	FlxG.cameras.add(camOther, false);

	botplayTxt = new FlxText(0, 0, null, 'BOTPLAY', 32);
	botplayTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	botplayTxt.visible = false;
	botplayTxt.borderSize = 1.25;
	botplayTxt.camera = camHUD;
	add(botplayTxt);

	var instructTxt:String = "Buttons to Press\n\n  4: Enable Botplay\n  5: Charting Menu\n  I: Debug Info\n  |: Enable/Disable camGame Camera Movement\n  Arrow Keys: Move camGame Camera\n(Will be adding more as time goes on)";
	instructions = new FlxText(20, 80, FlxG.width, instructTxt, 32);
	instructions.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, "left", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	instructions.borderSize = 1.25;
	instructions.camera = camOther;
	add(instructions);
	new FlxTimer().start(5, () -> FlxTween.tween(instructions, {alpha: 0}, 3));
	//trace(SystemInfo.__formattedSysText);

	systemInfoText = new FlxText(0, 0, FlxG.width, '' + SystemInfo.__formattedSysText, 32);
	systemInfoText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, "right", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	systemInfoText.borderSize = 1.25;
	systemInfoText.camera = camOther;
	systemInfoText.alpha = 0;
	add(systemInfoText);

	camCoords = new FlxText(0, systemInfoText.y + 60, FlxG.width, 'camFollow.X: ' + camFollow.x + "\ncamFollow.y: " + camFollow.y, 32);
	camCoords.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, "right", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	camCoords.borderSize = 1.25;
	camCoords.camera = camOther;
	camCoords.alpha = 0;
	add(camCoords);
}

function onCameraMove(event)
{
	//trace(event.position);
	if(camFreeMoving) event.cancel();
}

function onNoteHit(event)
{
	if(player.cpu && event.character.curCharacter == boyfriend.curCharacter)
		health += 0.02;
}

function update(elapsed:Float)
{
	if(startingSong || !canPause || paused || health <= 0) return;

	// Botplay
	if(FlxG.keys.justPressed.FOUR) curBotplay = !curBotplay;
	updateBotplay(elapsed);

	// Charter
	if(FlxG.keys.justPressed.FIVE) FlxG.switchState(new Charter(PlayState.SONG.meta.name, PlayState.difficulty, true));

	// Camera Controls
	if(FlxG.keys.justPressed.BACKSLASH)
	{
		camFreeMoving = !camFreeMoving;
		camZooming = !camFreeMoving;
	}
	if(camFreeMoving)
	{
		camZooming = false;
		if(FlxG.keys.justPressed.LEFT) camFollow.setPosition(camFollow.x - 10, camFollow.y);
		if(FlxG.keys.justPressed.DOWN) camFollow.setPosition(camFollow.x, camFollow.y + 10);
		if(FlxG.keys.justPressed.UP) camFollow.setPosition(camFollow.x, camFollow.y - 10);
		if(FlxG.keys.justPressed.RIGHT) camFollow.setPosition(camFollow.x + 10, camFollow.y);
	}
	camCoords.text = 'camFollow.x: ' + camFollow.x + "\ncamFollow.y: " + camFollow.y + "\ncamZoom: " + FlxMath.roundDecimal(FlxG.camera.zoom, 2);

	// Information
	if(FlxG.keys.justPressed.I) popupInfo();
}

function popupInfo()
{
	FlxTween.cancelTweensOf(systemInfoText);
	FlxTween.cancelTweensOf(camCoords);
	if(!theSysBool)
	{
		FlxTween.tween(systemInfoText, {alpha: 1}, 0.4);
		FlxTween.tween(camCoords, {alpha: 1}, 0.4);
	}
	else
	{
		FlxTween.tween(systemInfoText, {alpha: 0}, 0.4);
		FlxTween.tween(camCoords, {alpha: 0}, 0.4);
	}
	theSysBool = !theSysBool;
}

var leAlpha:Float = 0;
public var botplaySine:Float = 0;
function updateBotplay(elapsed:Float)
{
	for(strumLine in strumLines)
	{
		if(!strumLine.opponentSide)
		{
			strumLine.cpu = FlxG.keys.pressed.FIVE || curBotplay;
			botplayTxt.visible = curBotplay;
		}
	}

	// stole from cne source lmao
	var scale = new FlxBasePoint();
	var r:Float = 0;
	if(r > 0)
	{
		scale.x /= r;
		scale.y /= r;
		botplayTxt.scale.set(scale.x * 1.43, scale.y * 1.43);
	}
	scale.put();

	if(curBotplay)
	{
		botplaySine += 180 * elapsed;
		leAlpha = 1 - Math.sin((Math.PI * botplaySine) / 180);
		botplayTxt.alpha = leAlpha;
	}
	else
	{
		leAlpha = 0;
		botplayTxt.alpha = 0;
	}
	botplayTxt.screenCenter();
	botplayTxt.y = healthBar.y - 90;
}