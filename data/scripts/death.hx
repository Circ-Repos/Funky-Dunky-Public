
var camDeath = new FlxCamera();
var dancinBF:FlxSprite;

function create(event)
{
    //event.cancel();
	if(FlxG.save.data.DevModeTracing) trace('HELP NOW');
    event.gameOverSong = 'gameover';
    event.retrySFX = 'retry';
    FlxG.camera.zoom = 1;
}

var gameoverText:FunkinText;
function postCreate()
{
    character.alpha = 0;
    var gabriel = new FlxSprite(0,0,Paths.image('game/die/gabriel-game-over-screen'));
    gabriel.scrollFactor.set(0,0);
    gabriel.alpha = 0;
    FlxTween.tween(gabriel, {alpha: 1}, 1.75, {ease: FlxEase.sineOut});
    add(gabriel);
    gameoverText = new FunkinText(0,0,0,'DISCONNECTED\nPRESS ACCEPT TO RETRY CONNECTION', 62);
    gameoverText.alignment = 'center';
    gameoverText.font = Paths.font('VCR.ttf');
    gameoverText.scrollFactor.set();
    gameoverText.color = FlxColor.GRAY;
    gameoverText.screenCenter();
    gameoverText.antialiasing = false;
    gameoverText.scale.set(3,3);
    gameoverText.alpha = 0;
    add(gameoverText);

    camDeath.zoom = 1;
}

var executed:Bool = false;
function deathStart(event)
{
        //FlxTween.tween(bfdeathshit, {alpha: 1}, 1);
    if(FlxG.save.data.DevModeTracing) trace('Music here i think');    
    executed = true;
    FlxG.sound.play(Paths.sound('died'), 0.7);
    FlxTween.tween(gameoverText.scale, {y: 1}, 2, {ease: FlxEase.sineOut});
    FlxTween.tween(gameoverText.scale, {x: 1}, 2, {ease: FlxEase.sineOut});
    FlxTween.tween(gameoverText, {alpha: 1}, 1.75, {ease: FlxEase.sineOut});

}

function update(elapsed:Float)
{
    gameoverText.screenCenter(FlxAxes.X);
}
function onEnd()
{
    gameoverText.alpha = 1;
    gameoverText.scale.set(1,1);
    var sound = FlxG.sound.play(Paths.sound(retrySFX));
    var secsLength:Float = sound.length / 1000;
    var fadeOutTime = secsLength - 0.7;
    FlxTween.tween(gameoverText, {alpha: 0}, 0.75, {ease: FlxEase.sineOut});
    //FlxTween.tween(FlxG.camera, {zoom: 2}, fadeOutTime + 2, {ease: FlxEase.backInOut}, {startDelay: 1.2});
}

function destroy()
{
	if(camDeath != null)
	{
		if(FlxG.cameras.list.contains(camDeath))
			FlxG.cameras.remove(camDeath);
		camDeath.destroy();
	}
}