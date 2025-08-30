import funkin.backend.scripting.events.StateEvent;
import openfl.text.TextFormat;
import flixel.text.FlxTextBorderStyle;
import flixel.effects.FlxFlicker;

var chatBox:FlxSprite;
var CBG:FlxSprite;
var MBG:FlxSprite;
var border:FlxSprite;
var blackOverlayForFlicker:FlxSprite;

var textBlob2:FlxText;
var textBlob1:FlxText;

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
function destroy() {
	if (FlxG.cameras.list.contains(camThink))
		FlxG.cameras.remove(camThink);
	if (FlxG.cameras.list.contains(camThinkB))
		FlxG.cameras.remove(camThinkB);

}
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

	iconP1.y = healthBar.y - 65;
	iconP2.y = healthBar.y - 50;
    textBlob1 = new FlxText(0,0,629);
    textBlob1.setFormat(Paths.font("Arial.ttf"), 24, 0x000000,FlxTextBorderStyle.OUTLINE, "center");
    textBlob1.borderSize = 2;
    textBlob1.cameras = [camThink];
    textBlob1.screenCenter(FlxAxes.X);
    textBlob1.y = 870;
	textBlob1.x = 320;
	textBlob1.updateHitbox();
	textBlob1.antialiasing = Options.antialiasing; // I like my text smooth!
	textBlob1.text = "[CT]: HEY, IT'S CESAR. I HOPE IT'S NOT TOO LATE.\n\n[MH]: NO, IT'S FINE, DON'T WORRY. WHAT'S UP ARE YOU ALRIGHT?\n\n[CT]: YEAH, IT'S NOT ME IT'S MY MOM";
    add(textBlob1);

    textBlob2 = new FlxText(0,0,629);
    textBlob2.setFormat(Paths.font("Arial.ttf"), 24, 0x000000,FlxTextBorderStyle.OUTLINE, "center");
    textBlob2.borderSize = 2;
    textBlob2.cameras = [camThink];
    textBlob2.screenCenter(FlxAxes.X);
    textBlob2.y = 870;
	textBlob2.x = 320;
	textBlob2.updateHitbox();
	textBlob2.antialiasing = Options.antialiasing; // Unless it's a pixel font, then i like it crispy :]
	textBlob2.text = "[MH]: ALRIGHT, I MEAN IT SHOULDN'T BE TOO BAD. I'm JUST GONNA SWITCH THEM ON AND GET OUTTA THERE THOUGH. YOU KNOW WHAT I FEEL ABOUT YOUR HOUSE. \n\n[CT]: YEAH, THAT'S FINE. ONE LAST THING, TRY TO GET A GOOD VIEW";
    add(textBlob2);
	add(blackOverlayForFlicker);
	for(i in [camThink, camThinkB, camHUD]){
		i.scroll.x = -149;
	}
	hideArrows = true;

}
function flickerCam(){
	FlxFlicker.flicker(blackOverlayForFlicker, 0.7, 0.07, false);
}
function flickerCam2(){
	FlxFlicker.flicker(blackOverlayForFlicker, 0.5, 0.03, false);
}
/*function generateSubs(text1:String, text2:String) { //timer is stupid >:( It No Work
    if(text1 != '') textBlob1.visible = true;
    if(text2 != '') textBlob2.visible = true;
	if(text1 == '') textBlob1.visible = false;
	if(text2 == '') textBlob2.visible = false;
	if(text1 != '') textBlob1.text = text1;
	if(text2 != '') textBlob2.text = text2;
	textBlob1.updateHitbox();
	textBlob2.updateHitbox();
    textBlob1.y = FlxG.height - textBlob1.height;
    textBlob2.y = FlxG.height - 300;
	textBlob2.screenCenter(FlxAxes.X);
	textBlob1.screenCenter(FlxAxes.X);

}*/
function tweenText1(){
	hideArrows = false;
	FlxTween.tween(textBlob1, {y: -100}, 13, {
		ease: FlxEase.linear,
		onComplete: function(tween:FlxTween) {
			textBlob1.visible = false;
		}
	});
}
function tweenText2(){
	if(textBlob1.visible) textBlob1.visible = false;
	FlxTween.tween(textBlob2, {y: -100}, 14, {
		ease: FlxEase.linear,
		onComplete: function(tween:FlxTween) {
			textBlob2.visible = false;
		}
	});
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
	for (i in playerStrums.members) {
		i.alpha = 0;
	}
}
var defaultScale = 0.7;
function beatHit(){
	iconP2.scale.set(0.9,0.9);
}
function postUpdate(elapsed:Float){
	if(hideArrows){
		for (i in playerStrums.members) {
			i.alpha = 0;
		}
	}
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