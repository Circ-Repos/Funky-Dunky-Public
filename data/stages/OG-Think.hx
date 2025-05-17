var tic:Int = 1;
var letter:Int = 1;
var bruh:Bool = true;
var alpha:Bool = true;
var loosing:Bool = false;
var pos:Array<Int> = [190, 850];
var txt:Array<String> = ['one', 'two'];
var allshit:Array<String> = ['gray', 'layer'];
var anims:Array<String> = ['A', 'B', 'C', 'D', 'E'];
var assets:Array<String> = ['revealM', 'revealC', 'Alterlayer', 'Alterlayer2', 'Alterlayer3', 'black', 'eyes', 'markreveal', 'layerNORMAL', 'Alterlayer', 'cesarreveal', 'bighead', 'vintage'];
var victim:Array<FlxSprite> = [];
function create() {
    for (asset in assets) {
        Paths.image(asset); // precache image
    }
    Paths.sound('boomend');
}
var cIcon:FlxSprite;
var cesar:FlxSprite;
var mark:FlxSprite;
var vintage:FlxSprite;
function postCreate() {
    mark = new FlxText(140, 90, 424, "Mark Heathcliff", 40);
    mark.setFormat(null, 40, FlxColor.WHITE, 'LEFT');
    add(mark);

    cesar = new FlxText(825, 90, 424, "Cesar Torres", 40);
    cesar.setFormat(null, 40, FlxColor.WHITE, 'LEFT');
    add(cesar);

    cIcon = new FlxSprite(635, 580);
    cIcon.frames = Paths.getSparrowAtlas('stages/Retro-Think/cesariconss');
    cIcon.animation.addByPrefix('quiet', 'cesarstill', 1, true);
    cIcon.animation.addByPrefix('shakey', 'shakey', 24, true);
    cIcon.animation.play('quiet');
    add(cIcon);

    vintage = new FlxSprite(-200, -350);
    vintage.frames = Paths.getSparrowAtlas('stages/Retro-Think/vintage');
    vintage.animation.addByPrefix('idle', 'idle', 16, true);
    vintage.animation.play('idle');
    
    vintage.alpha = 0.3;
    add(vintage);

    eyeV = new FlxSprite(-200, -350);
    eyeV.frames = Paths.getSparrowAtlas('vintage');
    eyeV.animation.addByPrefix('idle', 'idle', 16, true);
    eyeV.animation.play('idle');
    eyeV.scale.set(3, 3);
    eyeV.alpha = 0.01;
    add(eyeV);

    gray2 = new FlxSprite(-300, -300);
    gray2.loadGraphic(Paths.image('stages/Retro-Think/gray'));
    gray2.alpha = 0.08;
    add(gray2);

    iconP1.alpha = 0.01;

    for (i in victim) {
        var vic = new FlxText(pos[i], 100, 324, 'victim ' + txt[i], 40);
        vic.setFormat(null, 40, FlxColor.WHITE, 'LEFT');
        //Reflect.setField(this, 'victim' + (i+1), vic);
        vic.alpha = 0.01;
        victim.add(vic);
    }
}

function update(elapsed:Float) {
    if (bruh) gf.alpha = 0.01;

    if (alpha) {
        for (i in playerStrums.members) {
            i.alpha = 0;
        }
    }

    if (health > 2) health = 2;
    //cIcon.x = 635 - 290 * (health - 1);

    if (health < 0.5 && !loosing) {
        cIcon.animation.play('shakey');
        loosing = true;
    } else if (loosing && health >= 0.5) {
        cIcon.animation.play('quiet');
        loosing = false;
    }
}

function onSongStart() {
    for (i in victim) {
        FlxTween.tween(i, {alpha: 1}, 1.0);
    }

    new FlxTimer().start(2.0, _ -> {
        for (i in victim) {
            FlxTween.tween(i, {alpha: 0}, 1.0);
        }
    });

    new FlxTimer().start(4.0, _ -> FlxTween.tween(mark, {alpha: 1}, 1.5));
    new FlxTimer().start(4.0, _ -> FlxTween.tween(cesar, {alpha: 1}, 1.5));
    new FlxTimer().start(6.0, _ -> FlxTween.tween(mark, {alpha: 0}, 1.0));
    new FlxTimer().start(6.0, _ -> FlxTween.tween(cesar, {alpha: 0}, 1.0));

    bruh = false;
    new FlxTimer().start(4.0, _ -> {
        alpha = false;
        for (i in playerStrums.members) {
            FlxTween.tween(i, {alpha: 0.6}, 2.0);
        }
    });
}

function stepHit() {
    if (curStep == 1334) {
        nothingIsWorthTheRisk();
    }
}

function nothingIsWorthTheRisk() {
    FlxG.camera.flash(FlxColor.BLACK, 1);
    camHUD.alpha = 0.01;

    for (i in playerStrums.members) {
        i.alpha = 0;
    }

    dad.alpha = 0.01;
    boyfriend.alpha = 0.01;

    for (name in allshit) {
        var sprite = name;
        if (sprite != null) remove(sprite);
    }

    var revealM = new FlxSprite(100, 100);
    revealM.loadGraphic(Paths.image("stages/Retro-Think/markreveal"));
    add(revealM);

    var alterLayer = new FlxSprite(-540, -725);
    alterLayer.loadGraphic(Paths.image("stages/Retro-Think/layerNORMAL"));
    add(alterLayer);

    var black = new FlxSprite(-540, -725);
    black.loadGraphic(Paths.image("stages/Retro-Think/black"));
    black.alpha = 0.01;
    black.setGraphicSize(Std.int(black.width * 2), Std.int(black.height * 2));
    add(black);

    // Add more layer and animation handling as needed based on rest of original Lua script
}

function onGameOver() {
    alpha = false;
    return Function_Continue;
}