import flixel.FlxCameraFollowStyle;
import funkin.backend.system.Flags;

//funni revisetdr code
// Cam Values
var dadX:Float = 555;
var dadY:Float = 655.5;
var dadZoom:Float = 0.8;

var bfX:Float = 1700;
var bfY:Float = 682.5;
var bfZoom:Float = 0.6;

var gfX:Float = -80;
var gfY:Float = 22;
var gfZoom:Float = 0.4;

var iconP3:HealthIcon;

function dgv(alp1:Float = 1, alp2:Float = 1){
	strumLines.members[0].characters[0].alpha = iconP2.alpha = alp1;
	strumLines.members[0].characters[1].alpha = iconP3.alpha = alp2;
}

function postCreate(){
	FlxG.camera.zoom = defaultCamZoom;
	defaultCamZoom = dadZoom;
	iconArray.push(iconP3 = new HealthIcon(strumLines.members[0].characters[1] != null ? strumLines.members[0].characters[1].getIcon() : Flags.DEFAULT_HEALTH_ICON, true));
	iconP3.camera = camHUD;
	iconP3.y = healthBar.y - (iconP3.height / 2);
	iconP3.alpha = 0;
	iconP3.flipX = true;
	add(iconP3);
	remove(iconP3, true);
	insert(members.indexOf(iconP2), iconP3);
	dgv(1,0);
}

function create()PlayState.instance.introLength = 0;

function onCountdown(event) event.cancel();
function update() oppupdateIconPositions();
function oppupdateIconPositions() {
	var iconOffset = Flags.ICON_OFFSET;
	var healthBarPercent = healthBar.percent;
	var center:Float = healthBar.x + healthBar.width * FlxMath.remapToRange(healthBarPercent, 0, 100, 1, 0);
	
	iconP3.x = iconP2.x = center - (iconP2.width - iconOffset);

	iconP3.health = iconP2.health = 1 - (healthBarPercent / 100);
}

function onCameraMove(e) {
	switch (curCameraTarget){
		case 0:
			defaultCamZoom = dadZoom;
			e.position.set(dadX, dadY);
		case 1: 
			defaultCamZoom = bfZoom;
			e.position.set(bfX, bfY);
		case 2: 
			defaultCamZoom = gfZoom;
			e.position.set(gfX, gfY);
		}
}

var notePlacementX:Array = [0, 0, 0, 0];

var allowGlitch:Bool = false;
function postUpdate(elapsed:Float) {
	FlxG.camera.follow(camFollow, FlxCameraFollowStyle.LOCKON, 0.06);

	if(allowGlitch){
		for(no in playerStrums.notes){
			no.x += FlxG.random.int(-15, 15);
			no.angle = FlxG.random.int(-15, 15);
		}
		for(i in 0...4){
			playerStrums.members[i].x = notePlacementX[i] + FlxG.random.int(-6, 6);
			playerStrums.members[i].y = 50 + FlxG.random.int(-6, 6);
		}
	}
}

var angleShit:Array = [10, -15, 5, -10];

function stepHit(){
	switch(curStep){
		case 380: 
			for(i in 0...4) notePlacementX[i] = playerStrums.members[i].x;
		case 384: allowGlitch = true;
		case 400: 
			allowGlitch = false;
			for(i in 0...4) playerStrums.members[i].setPosition(notePlacementX[i], 50);
		
		case 1880:
			for(i in 0...4){
				for(strums in strumLines.members){
					FlxTween.tween(strums.members[i], {y: 740}, 2, {ease: FlxEase.expoIn, startDelay: 1 * (i * 0.33)});
					FlxTween.tween(strums.members[i], {angle: angleShit[i]}, 2, {ease: FlxEase.cubeIn, startDelay: 1 * (i * 0.33)});
				}
			}
			for(icon in iconArray){
				FlxTween.tween(icon, {y: 1280}, 2, {ease: FlxEase.expoIn, startDelay: 1 * (iconP1 ? 2 : 0 * 0.33)});
				FlxTween.tween(icon, {angle: iconP1 ? -10 : 5}, 2, {ease: FlxEase.cubeIn, startDelay: 1 * (iconP1 ? 2 : 0 * 0.33)});
			}
			for(i in [scoreTxt, missesTxt, accuracyTxt, healthBar, healthBarBG]){
				FlxTween.tween(i, {y: 1280}, 2, {ease: FlxEase.expoIn, startDelay: 1 * (0 * 0.33)});
				FlxTween.tween(i, {angle: -10}, 2, {ease: FlxEase.cubeIn, startDelay: 1 * (0 * 0.33)});
			}
			
			

	}
}


//onNotehit if dad.curName != Gab-True or someth health -= 0.02 bc .2 is amount added by default
function onNoteHit(event){
    if(event.characters[0].alpha == 0 && health > 0.03){
        health -= 0.02;
    }
}