import funkin.backend.scripting.events.StateEvent;
var chatBox:FlxSprite;
var CBG:FlxSprite;
var MBG:FlxSprite;
var border:FlxSprite;
function onOpenSubState(event:StateEvent) {
	if(camHUD.alpha == 1){
		camHUD.alpha = 0.5;
	}
}
function create(){
    camThink = new FlxCamera();
    camThink.visible = true;
    camThink.alpha = 1;
	camThink.bgColor = 0;
    FlxG.cameras.remove(camThink, false);
    FlxG.cameras.add(camThink, false);
	FlxG.cameras.add(camHUD, false);

	PlayState.instance.introLength = 0.1;

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
	border.camera = camThink;
	PlayState.defaultHudZoom = 0.8;

}
function onCountdown(event) event.cancel();

function postCreate(){
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
}
function postUpdate(){
	camHUD.zoom = 0.7;
	camThink.zoom = 0.7;

}