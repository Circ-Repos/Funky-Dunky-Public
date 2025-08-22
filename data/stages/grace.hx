import flixel.FlxCameraFollowStyle;
import funkin.backend.system.Flags;
import openfl.display.BlendMode;

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
	tvlight.blend = BlendMode.ADD;
}
function create(){
	PlayState.instance.introLength = 0;
}
function onCountdown(event) event.cancel();
function update() oppupdateIconPositions();
function oppupdateIconPositions() {
	var iconOffset = Flags.ICON_OFFSET;
	var healthBarPercent = healthBar.percent;

	var center:Float = healthBar.x + healthBar.width * FlxMath.remapToRange(healthBarPercent, 0, 100, 1, 0);

	iconP1.x = center - iconOffset;
	iconP2.x = center - (iconP2.width - iconOffset);
	iconP3.x = center - (iconP2.width - iconOffset);

	iconP1.health = healthBarPercent / 100;
	iconP2.health = 1 - (healthBarPercent / 100);
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
function postUpdate(elapsed:Float) {
	FlxG.camera.follow(camFollow, FlxCameraFollowStyle.LOCKON, 0.06);
}
//onNotehit if dad.curName != Gab-True or someth health -= 0.02 bc .2 is amount added by default
function onNoteHit(event){
    if(event.characters[0].alpha == 0 && health > 0.03){
        health -= 0.02;
    }
}