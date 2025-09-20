import flixel.text.FlxText;
import flixel.text.FlxTextAlign;
import flixel.text.FlxTextFormat;
import flixel.text.FlxTextFormatMarkerPair;
import flixel.text.FlxTextBorderStyle;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
var theVis:Int = 0;
var leaving:Bool = true;
var textGroup:Array<FunkinText> = [];
function create()
{
	var bg:FlxBackdrop = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0xFFBBBBBB, 0xFF000000));
	bg.scrollFactor.set(0.5, 0.5);
	bg.antialiasing = false;
	bg.velocity.set(0, 40);
	bg.alpha = 0.15;
	add(bg);

	var boring:Array<String> = [
		"*DISCLAIMER*",
		"This Mod contains |flashing lights|",
		"and some |unsettling themes|.",
		"",
		"Play this at your own risk.",
		"You've been warned!",
		"",
		"Press /ACCEPT/ to continue."
	];

	for(i => txt in boring)
	{
		var poo:FunkinText = new FunkinText(0, i * 80, FlxG.width, "", 64);
		poo.alpha = 0;
		poo.setFormat(Paths.font("Times New Roman Italic.ttf"), 64, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.NONE, FlxColor.BLACK);
		poo.antialiasing = Options.antialiasing;
		poo.applyMarkup(txt, [
			new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFFF0000), "*"),
			new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFFFD900), "|"),
			new FlxTextFormatMarkerPair(new FlxTextFormat(0xFF00FF00), "/")
		]);
		FlxTween.tween(poo, {alpha: 1}, 2, {startDelay: i + 1* 0.5});
		FlxTween.tween(poo, {y: 25 + i * 80}, 0.8, {startDelay: i + 1 * 0.5}, {ease: FlxEase.elasticInOut});
		poo.ID = i;
		textGroup.push(poo);
		add(poo);
	
	}

	FlxG.camera.fade(FlxColor.BLACK, 1, true, () -> leaving = false);
}

function update()
{
	for(i in 0...textGroup.length - 1)
	{
		if(textGroup[7].alpha == 1) theVis = 1;
	}

	if(FlxG.save.data.seenWarning)
	{
		leaving = true;
		FlxG.switchState(new TitleState());
	}
	if(leaving) return;
	if(controls.ACCEPT && theVis == 1) iReadTheTermsOfServiceAndAgreeToAllMyDataBeingStolenForIllegalPurposes();
}

function iReadTheTermsOfServiceAndAgreeToAllMyDataBeingStolenForIllegalPurposes()
{
	leaving = true;
	CoolUtil.playMenuSFX(1, 0.7);
	FlxG.save.data.seenWarning = true;
	FlxG.camera.fade(FlxColor.BLACK, 1, false, () -> FlxG.switchState(new TitleState()));
}