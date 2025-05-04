import funkin.backend.scripting.events.StateEvent;
import openfl.text.TextFormat;
import flixel.text.FlxTextBorderStyle;
import flixel.effects.FlxFlicker;

var chatBox:FlxSprite;
var CBG:FlxSprite;
var MBG:FlxSprite;
var border:FlxSprite;
var blackOverlayForFlicker:FlxSprite;
var itime:Float = 0;
var vhsShader:CustomShader;

var cesarText:FlxText;
var markText:FlxText;
function create(){


    camThink = new FlxCamera();
    camThink.visible = true;
    camThink.alpha = 1;
	camThink.bgColor = 0;

	camThinkB = new FlxCamera();
    camThinkB.visible = true;
    camThinkB.alpha = 1;
	camThinkB.bgColor = 0;
	FlxG.cameras.remove(camHUD, false);

    FlxG.cameras.remove(camThink, false);
	FlxG.cameras.remove(camThinkB, false);
    FlxG.cameras.add(camThink, false);
	FlxG.cameras.add(camHUD, false);
	FlxG.cameras.add(camThinkB, false);

	MBG = new FlxSprite();
    MBG.loadGraphic(Paths.image('stages/think/MarkBG'));
	MBG.camera = camThink;
	insert(2, MBG);

	chatBox = new FlxSprite();
    chatBox.loadGraphic(Paths.image('stages/think/ChatBox'));
	chatBox.camera = camThink;
	insert(0, chatBox);

	CBG = new FlxSprite();
    CBG.loadGraphic(Paths.image('stages/think/CeaserBG'));
	CBG.camera = camThink;
	insert(0, CBG);

	border = new FlxSprite();
    border.loadGraphic(Paths.image('stages/think/Black_Border'));
	border.camera = camThinkB;
	PlayState.defaultHudZoom = 0.8;
	camHUD.scroll.y += 100;

	blackOverlayForFlicker = new FlxSprite();
    blackOverlayForFlicker.loadGraphic(Paths.image('stages/think/BlackOverlay'));
	blackOverlayForFlicker.camera = camThinkB;
	blackOverlayForFlicker.visible = false;
}
function onCountdown(event) event.cancel();

function postCreate(){
	for (i in playerStrums.members) {
		i.alpha = 0;
	}
	doIconBop = false;

	healthBar.scale.set(1.1, 1.0);
	healthBar.y = 0;
	healthBar.x += 150;
	healthBar.camera = camThinkB;
	remove(healthBarBG, true);
	boyfriend.camera = camThink;
	dad.camera = camThink;
	remove(boyfriend, true);
	insert(1, boyfriend);
	remove(dad, true);
	insert(6, dad);

	insert(9, border);
	remove(chatBox, true);
	insert(10, chatBox);
	dad.x += 200;
	//dad.y += 270;
	camGame.alpha = 0;
	boyfriend.flipX = false;
	//boyfriend.y += 300;
	boyfriend.y -= 60;
	camThink.scroll.y += 100;
	boyfriend.x -= 50;
	dad.y += 700;
	iconP1.camera = camThinkB;
	iconP2.camera = camThinkB;
	scoreTxt.camera = camThinkB;
	missesTxt.camera = camThinkB;
	accuracyTxt.camera = camThinkB;

	scoreTxt.y = 50;
	missesTxt.y = 50;
	accuracyTxt.y = 50;
	scoreTxt.x += 150;
	accuracyTxt.x += 150;
	missesTxt.x += 150;

	iconP1.y = healthBar.y - 75;
	iconP2.y = healthBar.y - 75;
    markText = new FlxText(0,0,300);
    markText.setFormat(Paths.font("Arial.ttf"), 48, 0x000000,FlxTextBorderStyle.OUTLINE, "center");
    markText.borderSize = 2;
    markText.cameras = [camThinkB];
    markText.screenCenter(FlxAxes.X);
    markText.y = FlxG.height - markText.height;
	markText.screenCenter(FlxAxes.X);
	markText.updateHitbox();
    add(markText);

	cesarText = new FlxText(0,0,300);
    cesarText.setFormat(Paths.font("Arial.ttf"), 48, 0x000000,FlxTextBorderStyle.OUTLINE, "center");
    cesarText.borderSize = 2;
    cesarText.cameras = [camThinkB];
    cesarText.screenCenter(FlxAxes.X);
    cesarText.y = FlxG.height - 300;
	cesarText.screenCenter(FlxAxes.X);
	cesarText.updateHitbox();
	cesarText.width = FlxG.width - 500; // Adjust this value to ensure there’s padding from the screen edges

    add(cesarText);

	vhsShader = new CustomShader("VHS");
    FlxG.game.addShader(vhsShader);
	add(blackOverlayForFlicker);
	for(i in [camThink, camThinkB, camHUD]){
		i.scroll.x = -149;
	}
}
function destroy() {
	FlxG.game.removeShader(vhsShader);
}
function flickerCam(){
	FlxFlicker.flicker(blackOverlayForFlicker, 0.7, 0.07, false);
}
function flickerCam2(){
	FlxFlicker.flicker(blackOverlayForFlicker, 0.5, 0.03, false);
}
function generateSubs(text1:String, text2:String) { //timer is stupid >:( It No Work
    if(text1 != '') markText.visible = true;
    if(text2 != '') cesarText.visible = true;
	if(text1 == '') markText.visible = false;
	if(text2 == '') cesarText.visible = false;
	if(text1 != '') markText.text = text1;
	if(text2 != '') cesarText.text = text2;
	markText.updateHitbox();
	cesarText.updateHitbox();
    markText.y = FlxG.height - markText.height;
    cesarText.y = FlxG.height - 300;
	cesarText.screenCenter(FlxAxes.X);
	markText.screenCenter(FlxAxes.X);

}
function arrowOpacity(opac:Float, time:Float){
	for (i in playerStrums.members) {
		FlxTween.tween(i, {alpha: opac},time, {ease: FlxEase.sineInOut});
	}
}
function onSongStart(){
	if(!downscroll) 	comboGroup.y += 300;
	if(downscroll) 	comboGroup.y = 300;
	iconP1.x += 30;
	iconP2.x -= 30;
}
var defaultScale = 0.7;
function beatHit(){
	iconP2.bump();
}
function postUpdate(elapsed:Float){
	if(!downscroll){
	for (i in playerStrums.members) {
		i.y = 170;

	}
	}
	if(downscroll){
		for (i in playerStrums.members) {
			i.y = 0;
	
		}
	}
	var floater = elapsed;
	vhsShader.iTime = floater;
	var iconLerp = 0.33;
	iconP1.scale.x = iconP2.scale.x;
	iconP1.scale.y = iconP2.scale.y; 
	iconP2.scale.set(CoolUtil.fpsLerp(iconP2.scale.x, defaultScale, iconLerp), CoolUtil.fpsLerp(iconP2.scale.y, defaultScale, iconLerp));
	iconP2.updateHitbox();
	iconP1.updateHitbox();

	camHUD.zoom = 0.8;
	camThink.zoom = 0.8;
	camThinkB.zoom = 0.8;
	camThinkB.scroll.x = camThink.scroll.x;
	camThinkB.scroll.y = camThink.scroll.y;
	camThink.scroll.x = camHUD.scroll.x;
	camThink.scroll.y = camHUD.scroll.y;
	var iconOffset:Int = 1;
	var healthBarPercent = healthBar.percent;

	var center:Float = healthBar.x + healthBar.width * FlxMath.remapToRange(healthBarPercent, 0, 100, 1, 0);

	iconP1.x = center - iconOffset;
	iconP2.x = center - (iconP2.width - iconOffset);

	health = FlxMath.bound(health, 0, maxHealth);

	iconP1.health = healthBarPercent / 100;
	iconP2.health = 1 - (healthBarPercent / 100);
}