
var camDeath = new FlxCamera();
var camFlash = new FlxCamera();

var dancinBF:FlxSprite;

function create(event){
    FlxG.camera.alpha = 0;
    //event.cancel();
    trace('HELP NOW');
    event.gameOverSong = 'gameover'; //NOTHING EVER HAPPENS -Any Interloper investigatorss
    event.retrySFX = 'flash';

    FlxG.cameras.add(camFlash, true);
    FlxG.cameras.add(camDeath, true);
    camDeath.bgColor = 0;
    camDeath.alpha = 1;
    FlxG.camera.alpha = 0;
    FlxG.camera.zoom = 3;
    //camGame.alpha = 0;

}
var creditTextPerson:FunkinText;
function postCreate(){
    var gabriel = new FlxSprite(0,0,Paths.image('game/die/gabriel-game-over-screen'));
    gabriel.scrollFactor.set(0,0);
    add(gabriel);
    creditTextPerson = new FunkinText(0,0,FlxG.width,'DISCONNECTED\nPRESS ACCEPT TO RETRY CONNECTION', 128);
    creditTextPerson.alignment = 'center';
    creditTextPerson.text = 'You Died';
    creditTextPerson.font = Paths.font('VCR.ttf');
    creditTextPerson.scrollFactor.set();
    creditTextPerson.color = FlxColor.RED;
    creditTextPerson.screenCenter();
    creditTextPerson.antialiasing = false;
    creditTextPerson.scale.set(3,3);
    creditTextPerson.camera = camDeath;
    creditTextPerson.alpha = 0;
    add(creditTextPerson);

    camDeath.zoom = 1;
}
var executed:Bool = false;

function update(elapsed:Float){
    creditTextPerson.screenCenter(FlxAxes.X);
    if(character.getAnimName() == 'firstDeath' && character.isAnimFinished() && !executed){
        //FlxTween.tween(bfdeathshit, {alpha: 1}, 1);
        executed = true;
        FlxG.sound.play(Paths.sound('died'), 0.7);
        FlxTween.tween(creditTextPerson.scale, {y: 1}, 2, {ease: FlxEase.sineOut});
        FlxTween.tween(creditTextPerson.scale, {x: 1}, 2, {ease: FlxEase.sineOut});
        FlxTween.tween(creditTextPerson, {alpha: 1}, 1.75, {ease: FlxEase.sineOut});

    }
}
function onEnd(){
    creditTextPerson.alpha = 0;
    camDeath.flash(FlxColor.BLACK, 4); // White flash for 0.5 seconds


}



