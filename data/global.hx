// libraries
import funkin.backend.utils.WindowUtils;
import lime.graphics.Image;
import openfl.system.Capabilities;
import funkin.backend.system.framerate.Framerate;
import funkin.backend.system.framerate.CodenameBuildField;
import funkin.backend.system.Main;

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

static var redirectStates:Map<FlxState, String> = [
	//BetaWarningState => 'custom/warning',
	TitleState => 'custom/title',
	MainMenuState => 'custom/main',
	//StoryMenuState => 'custom/story',
	//FreeplayState => 'custom/freeplay',
	OptionsMenu => 'custom/options/Options',
	CreditsMain => 'custom/credits'
];

function preStateSwitch()
{
	// redirectStates
	for(i in redirectStates.keys())
	{
		if(Std.isOfType(FlxG.game._requestedState, i)) 
			FlxG.game._requestedState = new ModState(redirectStates.get(i));
	}
}

// functions
function postStateSwitch() //post is more consistent than pre
{
	//set commit id to mod name
	Framerate.codenameBuildField.text = 'Codename Engine '+ Main.releaseCycle +' \nFunkdela Reloaded';
	// title
	window.title = windowTitle;
	// bgColor
	FlxG.camera.bgColor = 0xFF000000;

	// im not really sure where else to place this...
	//maybe in PlayState you fucking donkey -Circ
	PauseSubState.script = 'data/scripts/pause';
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
