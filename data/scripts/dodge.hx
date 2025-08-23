import flixel.input.keyboard.FlxKey;

var canDodge:Bool = false;
var dodged:Bool = false;
var diedToDodge:Bool = false;
var tutorialPrompt:Bool = false;
var beatPerSound:Int = 3;
var beatCounter:Int = 0;

function create() {
    warningFlash = new FlxSprite(0, 0).makeSolid(FlxG.width*3, FlxG.height*3, FlxColor.YELLOW);
    warningFlash.alpha = 0;
    warningFlash.camera = camHUD;
    add(warningFlash);
    remove(warningFlash, true);
    insert(0, warningFlash);
}

function update() {
    if (canDodge && FlxG.keys.justPressed.SPACE) {
        dodged = true;
    }
}

function beatHit(curBeat:Int) {
    if(beatCounter == 2) FlxTween.tween(warningFlash, { alpha: 0.46 }, 0.2, { ease: FlxEase.expoInOut });

    if (canDodge) {
        beatCounter++;
        warningFlash.alpha = 0;
        //FlxTween.tween(warningFlash, { alpha: 0.46 }, 0.2, { ease: FlxEase.expoInOut });
        //FlxTween.tween(warningFlash, {alpha: 0.5}, 0.25);
        if (beatCounter % beatPerSound == 0) {
            if(beatCounter == 6) FlxTween.tween(warningFlash, {alpha: 0}, 0.25);
        }
    }
    else{
        warningFlash.alpha = 0;
    }
}

function opponentAttack():Void {
    canDodge = true;
    dodged = false;
    //FlxG.sound.play(Paths.sound('rocketTurret/rocketBeep'), 1.2);

    beatCounter = 1;

    new FlxTimer().start(1.35, function(tmr:FlxTimer) {
        canDodge = false;
        if (!dodged && !player.cpu) { //!player.cpu for botplay lore
            health = -3333;
            FlxG.camera.shake(0.01, 0.2);
            warningFlash.alpha = 0;
        } else {
            warningFlash.alpha = 0;
            if(strumLines.members[1].characters[1] != null) strumLines.members[1].characters[1].playAnim('shoot', true, NONE, false, 0);
            //FlxG.sound.play(Paths.sound('dodge'), 0.5);
        }
    });
}

function onEvent(_) {
    if (_.event.name == 'dodge') {
        beatPerSound = Std.parseInt(_.event.params[0]);
        opponentAttack();
        warningFlash.alpha = 0;

    }
}
