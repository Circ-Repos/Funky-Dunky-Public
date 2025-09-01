import funkin.backend.utils.WindowUtils;
import funkin.backend.system.Flags;
import funkin.backend.system.framerate.Framerate;
import lime.graphics.Image;

// to fix going back to playstate from the options
public static var lastState:FlxState = null;

// saved curSelected values
public static var curSelectedMain:Int = 0;
public static var curSelectedStory:Int = 0;
public static var curSelectedFreeplay:Int = 0;

// functions
function preStateSwitch()
{
	FlxG.mouse.useSystemCursor = true;
	FlxG.mouse.visible = false;
	// we need some check so it doesn't flicker back to the OG icon when still in the mod
	WindowUtils.setWindow(Flags.TITLE, 'window/iconOG');
	Framerate.offset.x = 0;
	Framerate.offset.y = 0;
}

function postStateSwitch() //post is more consistent than pre
{
	WindowUtils.setWindow(Flags.TITLE, Flags.MOD_ICON);

	//only fuck with memory if ShowFPS is on, no point otherwise
	if(FlxG.save.data.showFPS)
	{
		Framerate.codenameBuildField.text = 'Codename Engine v' + Application.current.meta.get('version') + '\nFunkdela Reloaded v' + Flags.VERSION;
		Framerate.codenameBuildField.visible = FlxG.save.data.fpsWatermark;
	}

	// bgColor
	FlxG.camera.bgColor = 0xFF000000;
}

function destroy()
{
	FlxG.camera.bgColor = 0xFF000000;

	WindowUtils.setWindow(Flags.TITLE, 'window/iconOG');
	WindowUtils.resetAffixes();
	WindowUtils.resetTitle();

    window.setIcon(Image.fromBytes(Assets.getBytes(null)));

	Framerate.offset.x = 0;
	Framerate.offset.y = 0;
	Framerate.codenameBuildField.visible = true;
	Framerate.fpsCounter.visible = true;
	Framerate.memoryCounter.visible = true;
}

// save shit
FlxG.save.data.seenWarning ??= false;
FlxG.save.data.DevMode ??= false;
FlxG.save.data.DevModeTracing ??= false;
FlxG.save.data.fpsWatermark ??= true;
FlxG.save.data.showFPS ??= true;
FlxG.save.data.songsBeaten ??= []; // push DISPLAY names of songs
FlxG.save.data.weeksBeaten ??= []; // not needed yet, but might be useful later
FlxG.save.data.beatenAll ??= false;
