var chatBox:FlxSprite;
var CBG:FlxSprite;
var MBG:FlxSprite;
var border:FlxSprite;

function create(){
	MBG = new FlxSprite();
    MBG.loadGraphic(Paths.image('stages/think/MarkBG'));
	MBG.camera = camHUD;
	insert(0, MBG);

	chatBox = new FlxSprite();
    chatBox.loadGraphic(Paths.image('stages/think/ChatBox'));
	chatBox.camera = camHUD;
	insert(0, chatBox);

	CBG = new FlxSprite();
    CBG.loadGraphic(Paths.image('stages/think/CeaserBG'));
	CBG.camera = camHUD;
	insert(0, CBG);

	border = new FlxSprite();
    border.loadGraphic(Paths.image('stages/think/Black_Border'));
	border.camera = camHUD;
	PlayState.defaultHudZoom = 0.8;

}

function postCreate(){
	boyfriend.camera = camHUD;
	dad.camera = camHUD;
	remove(boyfriend, true);
	insert(3, boyfriend);
	remove(dad, true);
	insert(3, dad);

	insert(7, border);
	dad.x += 240;
	dad.y += 90;
	camGame.alpha = 0;
	boyfriend.flipX = true;
}
function postUpdate(){
	camHUD.zoom = 0.7;
}