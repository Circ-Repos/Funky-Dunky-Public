import funkin.backend.system.framerate.Framerate;

// to fix going back to playstate from the options
public static var lastState:FlxState = null;

// saved curSelected values
public static var curSelectedMain:Int = 0;
public static var curSelectedStory:Int = 0;
public static var curSelectedFreeplay:Int = 0;

// functions
function postStateSwitch() //post is more consistent than pre
{
	//set commit id to mod name
	Framerate.codenameBuildField.text = 'Codename Engine '+ Application.current.meta.get('version') +' \nFunkdela Reloaded';
	// bgColor
	FlxG.camera.bgColor = 0xFF000000;
}

function destroy()
{
	FlxG.camera.bgColor = 0xFF000000;
}

FlxG.save.data.DevMode ??= false;
FlxG.save.data.DevModeTracing ??= false;
FlxG.save.data.songsBeaten ??= [];
FlxG.save.data.beatenGrace ??= false; // why not use an array? lmao
FlxG.save.data.beatenDistraught ??= false;
FlxG.save.data.beatenScaryNight ??= false;
FlxG.save.data.beatenThink ??= false;
FlxG.save.data.beatenGift ??= false;
FlxG.save.data.beatenThonk ??= false;
FlxG.save.data.beatenAll ??= false;
