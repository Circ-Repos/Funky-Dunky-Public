import flixel.FlxCameraFollowStyle;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import openfl.geom.Rectangle;
import openfl.display.BlendMode;
import flixel.text.FlxTextBorderStyle;
import flixel.text.FlxText;
import flixel.text.FlxTextAlign;
import flixel.text.FlxTextFormat;
import flixel.text.FlxTextFormatMarkerPair;

importScript('data/scripts/dodge'); //i coded it for portal funkin'

//funni revisetdr code
// Cam Values
var dadX:Float = 1860;
var dadY:Float = 533.5;

var bfX:Float = 1200;
var bfY:Float = 900;

var gfX:Float = 1500;
var gfY:Float = 750;

var camOther = new FlxCamera();
var vig:FlxSprite;
var iconP3:HealthIcon;
var treetime:Bool = false;

function dgv(alp1:Float = 1, alp2:Float = 0, alp3:Float = 0){
	strumLines.members[0].characters[0].alpha = iconP2.alpha = alp1;
	strumLines.members[0].characters[1].alpha = iconP3.alpha = alp2;
	strumLines.members[0].characters[2].alpha = iconP4.alpha = alp3;
	if(alp3 == 1) bow.alpha = 0;
	if(alp3 == 0) bow.alpha = 1;
}
function bgv(alp1:Float = 1, alp2:Float = 0){
	strumLines.members[1].characters[0].alpha = iconP1.alpha = alp1;
	strumLines.members[1].characters[1].alpha = iconP5.alpha = alp2;
}
function cutsceneAlpha(camAlph, camHUDAlph){
	camGame.alpha = camAlph;
	camHUD.alpha = camHUDAlph;
}
var alternateString1:String = 'dont do it.';
var alternateString2:String = 'theres not enough room for the two of us.';
function postCreate(){
	camOther.bgColor = 0;
    camOther.alpha = 1;

	FlxG.cameras.remove(camHUD, false);
    FlxG.cameras.add(camOther, false);
	FlxG.cameras.add(camHUD, false);

	camHUD.alpha = 0;
	camGame.zoom = 2.25;
	camGame.alpha = 0;
	defaultCamZoom = 1;

	camFollow.setPosition(gfX, gfY);

	PlayState.instance.introLength = 0.1;

	iconArray.push(iconP3 = new HealthIcon(strumLines.members[0].characters[1] != null ? strumLines.members[0].characters[1].getIcon() : Flags.DEFAULT_HEALTH_ICON, true));
	iconP3.camera = camHUD;
	iconP3.y = healthBar.y - (iconP3.height / 2);
	iconP3.alpha = 0;
	add(iconP3);
	remove(iconP3, true);
	insert(members.indexOf(iconP2) - 1, iconP3);


	iconArray.push(iconP4 = new HealthIcon(strumLines.members[0].characters[2] != null ? strumLines.members[0].characters[2].getIcon() : Flags.DEFAULT_HEALTH_ICON, true));
	iconP4.camera = camHUD;
	iconP4.y = healthBar.y - (iconP4.height / 2);
	iconP4.alpha = 0;
	add(iconP4);
	remove(iconP4, true);
	insert(members.indexOf(iconP2) - 1, iconP4);

	iconArray.push(iconP5 = new HealthIcon(strumLines.members[1].characters[1] != null ? strumLines.members[1].characters[1].getIcon() : Flags.DEFAULT_HEALTH_ICON, true));
	iconP5.camera = camHUD;
	iconP5.y = healthBar.y - (iconP5.height / 2);
	iconP5.alpha = 0;
	iconP5.flipX = true;
	add(iconP5);
	remove(iconP5, true);
	insert(members.indexOf(iconP1) - 1, iconP5);

	bgv(1,0);
	dgv(0,0,0);

	healthBar.alpha = 0;
	healthBarBG.alpha = 0;
	iconP2.alpha = iconP1.alpha = iconP3.alpha = iconP4.alpha = iconP5.alpha = 0;
	healthBar.angle = 180;

	strumLines.members[0].characters[1].x -= 60;
	strumLines.members[0].characters[1].y += 100;

	vig = new FlxSprite();
    vig.loadGraphic(Paths.image('vig'));
	vig.cameras = [camOther];
    add(vig);
	add(vig); //add twice cause yes

	iconP1.flipX = true;
	iconP2.flipX = true;

	tvlight.blend = BlendMode.ADD;

	tutorialText = new FlxText(0,350,0, 'When The Screen Flashes Yellow, \nPress SPACE to Shoot The Alternate!', 48);
	tutorialText.font = Paths.font('Times New Roman Italic.ttf');
	tutorialText.italic = true;
	tutorialText.underline = true;
	tutorialText.alignment = FlxTextAlign.CENTER;
	tutorialText.antialiasing = false;
	tutorialText.camera = camOther;
	tutorialText.setBorderStyle(FlxTextBorderStyle.NONE);
	tutorialText.screenCenter();
	tutorialText.alpha = 0;
	add(tutorialText);

}
function onDadHit(event){ //too fucking lazy rn
    if(health > 0.03 && event.note.isSustainNote == false){
        health -= 0.02;
    }
}
function hideStuff(){
	camGame.alpha = 0;
	camHUD.alpha = 0;
}

function onCountdown(e) e.cancel(); //0 sound or graphics happen if i do this

function onSongStart(){
	camFollow.setPosition(gfX, gfY);
    camZooming = false; //usually off, but just incase
	FlxTween.tween(camGame, {alpha: 1},2.35, {ease: FlxEase.linear});
}

function showHUD(time:Float){
	FlxTween.tween(camHUD, {alpha: 1},time, {ease: FlxEase.linear});
}
function hideHUD(time:Float){
	FlxTween.tween(camHUD, {alpha: 0},time, {ease: FlxEase.linear});
}

function oppupdateIconPositions() {
	var iconOffset = 26;
	var healthBarPercent = healthBar.percent*-1; //x-1 = good thing

	var center:Float = healthBar.x + healthBar.width * FlxMath.remapToRange(healthBarPercent, -100, 0, 1, 0);

	iconP3.x = iconP4.x = iconP2.x = center - iconOffset;
	iconP5.x = iconP1.x = center - (iconP2.width - iconOffset);
	iconP5.health = iconP1.health = healthBarPercent / 100;
	iconP4.health = iconP3.health = iconP2.health = 1 - (healthBarPercent / 100);
}
function update(){
	if(healthBar.alpha == 0) health = 1; //lazy
	if(treetime){
		scoreTxt.color = missesTxt.color = accuracyTxt.color = FlxColor.RED;
	}
}
function postUpdate() oppupdateIconPositions();
function onCountdown(event) event.cancel();

function onCameraMove(e) {
	switch (curCameraTarget){
		default: //anything other than BF or DAD = gf
			e.position.set(gfX, gfY);
			defaultCamZoom = 0.65;
		case 0:
			e.position.set(dadX, dadY);
			defaultCamZoom = 1;
		case 1: 
			e.position.set(bfX, bfY);
			defaultCamZoom = 0.7;
		}
}
function stepHit(e){
	switch(e){
		case 385:
			FlxTween.tween(tutorialText, { alpha: 1 }, 2, { ease: FlxEase.expoInOut});
		case 450:
			tutorialText.antialiasing = false;
			tutorialText.font = Paths.font('VCR.ttf');
			tutorialText.italic = false;
			tutorialText.underline = false;
			tutorialText.text = alternateString1;
			tutorialText.screenCenter();

			tutorialText.alpha = 1;
		case 460:
			tutorialText.alpha = 0;
		case 500:
			tutorialText.text = alternateString2;
			tutorialText.screenCenter();

			tutorialText.alpha = 1;
		case 514:
			tutorialText.alpha = 0;
		case 512:
			tutorialText.alpha = 0;
			healthBar.alpha = 1;
			healthBarBG.alpha = 1;
			iconP1.alpha = 1;
			iconP2.alpha = 1;
			iconP3.alpha = 1;
			dgv(0,1,0);
			health = 1; //reset health since player didnt see it before now
			doorclosed.alpha = 0;
			cutsceneAlpha(1,1);
		case 2080:
			iconP1.alpha = iconP3.alpha =iconP2.alpha = iconP5.alpha = iconP4.alpha = 0;
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