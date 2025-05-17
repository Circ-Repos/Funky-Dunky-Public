// libraries
import funkin.backend.utils.WindowUtils;
import lime.graphics.Image;
import openfl.system.Capabilities;
import funkin.backend.system.framerate.Framerate;
import funkin.backend.system.framerate.CodenameBuildField;
import funkin.backend.system.Main;
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
function postStateSwitch(){ //post is more consistent than pre
	//set commit id to mod name
	Framerate.codenameBuildField.text = 'Codename Engine '+ Main.releaseCycle +' \nFunkdela Reloaded';
	// title
	window.title = windowTitle;
	// bgColor
	FlxG.camera.bgColor = 0xFF000000;

	//icon window
	//window.setIcon(Image.fromBytes(Assets.getBytes(Paths.image('iconGame'))));
}
function new(){

	shader2 = new CustomShader("lowquality_0_reduce");
	shader3 = new CustomShader("lowquality_1_sharpen");
	shader4 = new CustomShader("lowquality_3_main");
	shader5 = new CustomShader("lowquality_4_amplification");
	
    FlxG.game.addShader(shader2);
	FlxG.game.addShader(shader3);
	FlxG.game.addShader(shader4);
	FlxG.game.addShader(shader5);
}
function destroy(){
	FlxG.camera.bgColor = 0xFF000000;
	FlxG.game.removeShader(shader2);
	FlxG.game.removeShader(shader3);
	FlxG.game.removeShader(shader4);
	FlxG.game.removeShader(shader5);
}

FlxG.save.data.DevMode ??= false;
FlxG.save.data.DevModeTracing ??= false;
