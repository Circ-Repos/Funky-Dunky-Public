import flixel.FlxCameraFollowStyle;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import openfl.geom.Rectangle;

//funni revisetdr code
// Cam Values
var dadX:Float = 1900;
var dadY:Float = 603.5;

var bfX:Float = 800;
var bfY:Float = 900;

var gfX:Float = 1500;
var gfY:Float = 750;

var camOther = new FlxCamera();
var vig:FlxSprite;
var iconP3:HealthIcon;
var treetime:Bool = false;
function dgv(alp1:Float = 1, alp2:Float = 1){
	strumLines.members[0].characters[0].alpha = iconP2.alpha = alp1;
	strumLines.members[0].characters[1].alpha = iconP3.alpha = alp2;
}
function cutsceneAlpha(camAlph, camHUDAlph){
	camGame.alpha = camAlph;
	camHUD.alpha = camHUDAlph;
}
function stepHit(e){
	switch(e){
		case 512:
			healthBar.alpha = 1;
			healthBarBG.alpha = 1;
			iconP1.alpha = 1;
			iconP2.alpha = 1;
			iconP3.alpha = 1;
			dgv(0,1);
			doorclosed.alpha = 0;
			cutsceneAlpha(1,1);
		case 2080:
			iconP1.alpha = 0;
			iconP2.alpha = 0;
			iconP3.alpha = 0;
			treetime = true;
			scoreTxt.text = 'Score: 333333';
			missesTxt.text = 'Misses: 3333';
			accuracyTxt.text = "Accuracy: 333.333%";
			scoreTxt.color = missesTxt.color = accuracyTxt.color = FlxColor.RED;
		
			healthBar.alpha = 0;
			healthBarBG.alpha = 0;
			healthBarBG.alpha = 0;
		case 2111:
			FlxTween.tween(camHUD, {alpha: 0},10, {ease: FlxEase.linear});

	}
}
function postCreate(){
	iconArray.push(iconP3 = new HealthIcon(strumLines.members[0].characters[1] != null ? strumLines.members[0].characters[1].getIcon() : Flags.DEFAULT_HEALTH_ICON, true));
	iconP3.camera = camHUD;
	iconP3.y = healthBar.y - (iconP3.height / 2);
	iconP3.alpha = 0;
	add(iconP3);
	remove(iconP3, true);
	insert(members.indexOf(iconP2) - 1, iconP3);

	healthBar.alpha = 0;
	healthBarBG.alpha = 0;
	iconP2.alpha = iconP1.alpha = iconP3.alpha = 0;
	PlayState.instance.introLength = 0.1;

	healthBar.angle = 180;


	camFollow.setPosition(1700, dadY);
	strumLines.members[0].characters[0].alpha = 0;
	strumLines.members[0].characters[1].alpha = 0;
	
	strumLines.members[0].characters[1].x -= 60;
	strumLines.members[0].characters[1].y += 100;


	camHUD.alpha = 0;
	camGame.zoom = 2.25;
	camGame.alpha = 0;

	defaultCamZoom = 1;
	FlxG.cameras.add(camOther, false);
    camOther.bgColor = 0;
    camOther.alpha = 1;


	PlayState.instance.introLength = 0.1;
	vig = new FlxSprite();
    vig.loadGraphic(Paths.image('vig'));
	vig.cameras = [camOther];
    add(vig);
	remove(vig, true);
	insert(0, vig);

	iconP1.flipX = true;
	iconP2.flipX = true;
}
function hideStuff(){
	camGame.alpha = 0;
	camHUD.alpha = 0;
	
}
function onCountdown(e) e.cancel();
function onSongStart(){
	//PlayState.instance.dad.alpha = 0.001;
	camFollow.setPosition(1700, dadY);
	//char debug modes prevent the idle from playing
    camZooming = false; //usually off, but just incase i guess

	FlxTween.tween(camGame, {alpha: 1},2.35, {ease: FlxEase.linear});

}
function startZoom(){
	boyfriend.debugMode = true;
	dad.debugMode = true;
    camZooming = false; //usually off, but just incase i guess
    camGame.zoom = 1.25;
    camHUD.alpha = 0;
    camGame.alpha = 0;

	camFollow.setPosition(bfX + 450,bfY);
}
function showHUD(time:Float){
	FlxTween.tween(camHUD, {alpha: 1},time, {ease: FlxEase.linear});
}
function hideHUD(time:Float){
	FlxTween.tween(camHUD, {alpha: 0},time, {ease: FlxEase.linear});
}
function oppupdateIconPositions() {
	var iconOffset = 26;
	var healthBarPercent = healthBar.percent*-1;

	var center:Float = healthBar.x + healthBar.width * FlxMath.remapToRange(healthBarPercent, -100, 0, 1, 0);

	iconP2.x = center - iconOffset;
	iconP3.x = center - iconOffset;

	iconP1.x = center - (iconP2.width - iconOffset);


	iconP1.health = healthBarPercent / 100;
	iconP2.health = 1 - (healthBarPercent / 100);
}
function update(){
	if(treetime){
		scoreTxt.text = 'Score: 333333';
		missesTxt.text = 'Misses: 3333';
		accuracyTxt.text = "Accuracy: 333.333%";
		scoreTxt.color = missesTxt.color = accuracyTxt.color = FlxColor.RED;
	}
}
function postUpdate(){

	oppupdateIconPositions();
}
function onCountdown(event) event.cancel();
function idleEnable() boyfriend.debugMode = dad.debugMode = false;
function onCameraMove(e) {
	if(camZooming){
	switch (curCameraTarget){
		case 0:
			e.position.set(dadX, dadY);
		case 1: 
			e.position.set(bfX, bfY);
		default: 
			e.position.set(gfX, gfY);
		}
	}
	if(!camZooming) e.cancel();
}
