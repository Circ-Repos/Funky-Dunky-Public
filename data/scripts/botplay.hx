import flixel.text.FlxTextAlign;
import flixel.text.FlxTextBorderStyle;

static var curBotplay:Bool = false;
public var botplayTxt:FlxText;

var botplaySine:Float = 0;
var botplayAlpha:Float = 0;

function postCreate()
{
	botplayTxt = new FlxText(0, 0, null, 'BOTPLAY', 32);
	botplayTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	botplayTxt.visible = false;
	botplayTxt.borderSize = 1.25;
	botplayTxt.camera = camHUD;
	add(botplayTxt);
}

function update(elapsed:Float)
{
	if(startingSong || !canPause || paused || health <= 0) return;

	for(strumLine in strumLines)
	{
		if(!strumLine.opponentSide)
		{
			strumLine.cpu = FlxG.keys.pressed.FIVE || curBotplay;
			botplayTxt.visible = curBotplay;
		}
	}

	if(curBotplay)
	{
		botplaySine += 180 * elapsed;
		botplayAlpha = 1 - Math.sin((Math.PI * botplaySine) / 180);
		botplayTxt.alpha = botplayAlpha;
	}
	else
	{
		botplayAlpha = 0;
		botplayTxt.alpha = 0;
	}
	botplayTxt.screenCenter();
	botplayTxt.y = healthBar.y - 90;
}