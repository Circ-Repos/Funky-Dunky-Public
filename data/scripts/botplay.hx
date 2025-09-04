import flixel.text.FlxTextAlign;
import flixel.text.FlxTextBorderStyle;
import flixel.util.FlxColor;

static var curBotplay:Bool = false;
public var botplayTxt:FlxText;
var sillyBotplay:Bool = false;

var botplaySine:Float = 0;
var botplayAlpha:Float = 0;

var xSpeed:Float = 150;
var ySpeed:Float = 100;

function postCreate()
{
	sillyBotplay = FlxG.save.data.DevMode;

	botplayTxt = new FlxText(0, 0, null, 'BOTPLAY', 32);
	botplayTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	botplayTxt.visible = false;
	botplayTxt.borderSize = 1.25;
	botplayTxt.camera = camOther;
	add(botplayTxt);
}

function update(elapsed:Float)
{
    var hitX:Bool = false;
    var hitY:Bool = false;

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
		if(sillyBotplay)
		{
			// Move botplayTxt
			botplayTxt.x += xSpeed * elapsed;
			botplayTxt.y += ySpeed * elapsed;

			// Bounce off left/right edges
			if(botplayTxt.x <= 0)
			{
				botplayTxt.x = 0;
				xSpeed *= -1;
				hitX = true;
			}
			else if(botplayTxt.x + botplayTxt.width >= FlxG.width)
			{
				botplayTxt.x = FlxG.width - botplayTxt.width;
				xSpeed *= -1;
				hitX = true;
			}

			// Bounce off top/bottom edges
			if(botplayTxt.y <= 0)
			{
				botplayTxt.y = 0;
				ySpeed *= -1;
				hitY = true;
			}
			else if(botplayTxt.y + botplayTxt.height >= FlxG.height)
			{
				botplayTxt.y = FlxG.height - botplayTxt.height;
				ySpeed *= -1;
				hitY = true;
			}

			if(hitX || hitY) botplayTxt.color = FlxColor.fromRGB(FlxG.random.int(50, 255), FlxG.random.int(50, 255), FlxG.random.int(50, 255));
		}

		// Update Botplay Alpha
		botplaySine += 180 * elapsed;
		botplayAlpha = 1 - Math.sin((Math.PI * botplaySine) / 180);
		botplayTxt.alpha = botplayAlpha;
	}
	else
	{
		botplayAlpha = 0;
		botplayTxt.alpha = 0;
	}
	if(!sillyBotplay)
	{
		botplayTxt.screenCenter(FlxAxes.X);
		botplayTxt.y = healthBar.y - 90;
	}
}