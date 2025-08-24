import funkin.backend.system.framerate.Framerate;
import funkin.backend.utils.WindowUtils;
import lime.graphics.Image;
import funkin.backend.utils.WindowUtils;
import funkin.backend.system.Flags;
// to fix going back to playstate from the options
public static var lastState:FlxState = null;

// saved curSelected values
public static var curSelectedMain:Int = 0;
public static var curSelectedStory:Int = 0;
public static var curSelectedFreeplay:Int = 0;

// functions
function postStateSwitch() //post is more consistent than pre
{
	WindowUtils.setWindow(Flags.TITLE, Flags.MOD_ICON);

	//set commit id to mod name
	Framerate.codenameBuildField.text = 'Codename Engine '+ Application.current.meta.get('version') +' \nFunkdela Reloaded';
		
		//only fuck with memory if ShowFPS is on, no point otherwise
		if(FlxG.save.data.showFPS) Framerate.codenameBuildField.visible = FlxG.save.data.fpsWatermark;
	// bgColor
	FlxG.camera.bgColor = 0xFF000000;
}
function preStateSwitch() {
	WindowUtils.setWindow(Flags.TITLE, 'iconOG');
	Framerate.offset.y = 0;
	Framerate.offset.x = 0;
}
function destroy()
{
	WindowUtils.setWindow(Flags.TITLE, 'iconOG');
	FlxG.camera.bgColor = 0xFF000000;
	WindowUtils.resetAffixes();
	WindowUtils.resetTitle();

    window.setIcon(Image.fromBytes(Assets.getBytes(null)));
	Framerate.offset.y = 0;
	Framerate.offset.x = 0;
	Framerate.codenameBuildField.visible = true;
	Framerate.fpsCounter.visible = true;
	Framerate.memoryCounter.visible = true;

}

FlxG.save.data.DevMode ??= false;
FlxG.save.data.DevModeTracing ??= false;
FlxG.save.data.fpsWatermark ??= true;
FlxG.save.data.showFPS ??= true;
FlxG.save.data.songsBeaten ??= [];
FlxG.save.data.beatenGrace ??= false; // why not use an array? lmao
FlxG.save.data.beatenDistraught ??= false;
FlxG.save.data.beatenScaryNight ??= false;
FlxG.save.data.beatenThink ??= false;
FlxG.save.data.beatenGift ??= false;
FlxG.save.data.beatenThonk ??= false;
FlxG.save.data.beatenAll ??= false;

