// libraries
import funkin.backend.utils.WindowUtils;
import lime.graphics.Image;
import openfl.system.Capabilities;
import funkin.backend.system.framerate.Framerate;
import funkin.backend.system.framerate.CodenameBuildField;
import funkin.backend.system.Main;
import funkin.backend.MusicBeatTransition;
import funkin.menus.BetaWarningState;
import funkin.menus.TitleState;
import funkin.menus.MainMenuState;
import funkin.menus.StoryMenuState;
import funkin.menus.FreeplayState;
import funkin.options.OptionsMenu;
import funkin.menus.credits.CreditsMain;

// DEFAULT WINDOW POSITIONS
static var winX:Int = FlxG.stage.application.window.display.bounds.width / 6;
static var winY:Int = FlxG.stage.application.window.display.bounds.height / 6;

// MONITOR RESOLUTION
static var fsX:Int = Capabilities.screenResolutionX;
static var fsY:Int = Capabilities.screenResolutionY;

// WINDOW SIZE CHANGE VAR
static var resizex:Int = Capabilities.screenResolutionX / 1.5;
static var resizey:Int = Capabilities.screenResolutionY / 1.5;

static var windowTitle:String = "Funkdela' Reloaded";

//shader
var itime:Float = 0;
var vhsShader:CustomShader;
var shader1:CustomShader;
var shader2:CustomShader;
var shader3:CustomShader;
var shader4:CustomShader;
var shader5:CustomShader;


// functions
function postStateSwitch() //post is more consistent than pre
{
	//set commit id to mod name
	Framerate.codenameBuildField.text = 'Codename Engine '+ Application.current.meta.get('version') +' \nFunkdela Reloaded';
	// title
	window.title = windowTitle;
	// bgColor
	FlxG.camera.bgColor = 0xFF000000;

	// im not really sure where else to place this...
	// GameOverSubstate.script = 'data/scripts/death';

	//icon window
	//window.setIcon(Image.fromBytes(Assets.getBytes(Paths.image('iconGame'))));
}

function destroy()
{
	FlxG.camera.bgColor = 0xFF000000;
}

FlxG.save.data.DevMode ??= false;
FlxG.save.data.DevModeTracing ??= false;
FlxG.save.data.beatenGrace ??= false;
FlxG.save.data.beatenDistraught ??= false;
FlxG.save.data.beatenScaryNight ??= false;
FlxG.save.data.beatenThink ??= false;
FlxG.save.data.beatenGift ??= false;
FlxG.save.data.beatenThonk ??= false;
FlxG.save.data.beatenAll ??= false;

