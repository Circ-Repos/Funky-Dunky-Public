import flixel.text.FlxText;
import flixel.text.FlxTextAlign;
import flixel.text.FlxTextFormat;
import flixel.text.FlxTextFormatMarkerPair;
import flixel.text.FlxTextBorderStyle;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;

var leaving:Bool = true;

function create()
{
	if(FlxG.save.data.seenWarning)
	{
		FlxG.switchState(new TitleState());
		return;
	}

	var bg:FlxBackdrop = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0xFFBBBBBB, 0xFF000000));
	bg.scrollFactor.set(0.5, 0.5);
	bg.antialiasing = false;
	bg.velocity.set(0, 40);
	bg.alpha = 0.15;
	add(bg);

	var boring:Array<String> = [
		"*WARNING*",
		"This Mod contains |flashing lights|",
		"and some |unsettling themes|.",
		"",
		"Play this at your own risk,",
		"you've been warned!",
		"",
		"Press /ACCEPT/ to continue."
	];

	for(i => txt in boring)
	{
		var poo:FunkinText = new FunkinText(0, 25 + (i + 100), FlxG.width, "", 64);
		poo.setFormat(Paths.font("Times New Roman Italic.ttf"), 64, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.NONE, FlxColor.BLACK);
		poo.antialiasing = Options.antialiasing;
		poo.applyMarkup(txt, [
			new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFFF0000), "*"),
			new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFFFD900), "|"),
			new FlxTextFormatMarkerPair(new FlxTextFormat(0xFF00FF00), "/")
		]);
		add(poo);
	}

	FlxG.camera.fade(FlxColor.BLACK, 1, true, () -> leaving = false);
}

function update()
{
	if(leaving) return;
	if(controls.ACCEPT) iReadTheTermsOfServiceAndAgreeToAllMyDataBeingStolenForIllegalPurposes();
}

function iReadTheTermsOfServiceAndAgreeToAllMyDataBeingStolenForIllegalPurposes()
{
	leaving = true;
	CoolUtil.playMenuSFX(1, 0.7);
	FlxG.save.data.seenWarning = true;
	FlxG.camera.fade(FlxColor.BLACK, 1, false, () -> FlxG.switchState(new TitleState()));
}