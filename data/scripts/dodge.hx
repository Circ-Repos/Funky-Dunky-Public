import flixel.input.keyboard.FlxKey;

var canDodge:Bool = false;
var dodged:Bool = false;
var diedToDodge:Bool = false;
var tutorialPrompt:Bool = false;
var dodgeTutorialPrompt:FlxSprite;
var beatPerSound:Int = 3;
var beatCounter:Int = 0;

function create() {
    dodgeTutorialPrompt = new FlxSprite(970, 300);
    dodgeTutorialPrompt.loadGraphic(Paths.image('dodgeTutorial'), false, 0, 0);
    dodgeTutorialPrompt.scale.set(0.5, 0.5);
    dodgeTutorialPrompt.visible = false;
    dodgeTutorialPrompt.alpha = 0;
    dodgeTutorialPrompt.camera = camHUD;
    add(dodgeTutorialPrompt);

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
    if (canDodge) {
        beatCounter++;
        warningFlash.alpha = 0;
        FlxTween.tween(warningFlash, { alpha: 0.46 }, 0.2, { ease: FlxEase.expoInOut });
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

    if(tutorialPrompt) {
        dodgeTutorialPrompt.visible = true;
        dodgeTutorialPrompt.alpha = 0;
        FlxTween.tween(dodgeTutorialPrompt, { alpha: 0.43 }, 0.4, { ease: FlxEase.bounceIn });
    }
    //FlxG.sound.play(Paths.sound('rocketTurret/rocketBeep'), 1.2);

    beatCounter = 1;

    new FlxTimer().start(0.35, function(tmr:FlxTimer) {
        canDodge = false;
        if (!dodged && !player.cpu) { //!player.cpu for botplay lore
            if(tutorialPrompt) dodgeTutorialPrompt.visible = false;
            health = -3333;
            FlxG.camera.shake(0.01, 0.2);
            warningFlash.alpha = 0;
        } else {
            warningFlash.alpha = 0;
            if(tutorialPrompt) FlxTween.tween(dodgeTutorialPrompt, { alpha: 0 }, 0.4, { ease: FlxEase.linear });
            if(strumLines.members[1].characters[1] != null) strumLines.members[1].characters[1].playAnim('shoot', true, NONE, false, 0);
            //FlxG.sound.play(Paths.sound('dodge'), 0.5);
        }
    });
}

function onEvent(_) {
    if (_.event.name == 'dodge') {
        beatPerSound = Std.parseInt(_.event.params[0]);
        tutorialPrompt = _.event.params[1];
        opponentAttack();
        warningFlash.alpha = 0;

    }
}
