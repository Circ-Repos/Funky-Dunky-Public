function onNoteHit(e){
	if (e.note.isSustainNote){
		e.preventAnim();

		for(i in 0...e.characters.length){
			e.characters[i].lastAnimContext = 'LOCK';
			if(e.note.nextNote == null || !e.note.nextNote.isSustainNote){
				var event = e;
				event.characters[i].lastHit = Conductor.songPosition + 30;           
				event.characters[i].lastAnimContext = 'SING';
			}
		}
	}
}

function onPlayerMiss(e){
	if (e.note?.isSustainNote){
		for(i in 0...e.characters.length){
			e.characters[i].lastAnimContext = 'LOCK';
			if(e.note.nextNote == null || !e.note.nextNote.isSustainNote)
				e.characters[i].lastAnimContext = 'MISS';
		}
		e.preventAnim();
		e.preventVocalsUnmute();
		e.healthGain = e.misses = e.score = e.accuracy = 0;
		e.preventMissSound();
	}
}

//Delete this file and something wicked will happen to you

var fullTitle:String = 'Something wicked this way comes.';
var titleIndex:Int = 0;
var titleTimer:FlxTimer = new FlxTimer();
var letterTimer:FlxTimer = new FlxTimer();
var fadeOutTimer:FlxTimer = new FlxTimer();

var soundTimer:FlxTimer = new FlxTimer();
var camw = new FlxCamera();

function postCreate(){
    camw.bgColor = 0;
    camw.alpha = 1;
    FlxG.cameras.add(camw, false);   
}

function onSongStart(){
    var wJumpscare = FlxG.random.bool(3 / 300);
    if(wJumpscare)
    {
	    trace('Something wicked this way comes.');
        FlxG.sound.music.volume = 0;
        FlxG.sound.play(Paths.sound('w'));

        soundTimer.start(5, function(_){
            createSplash();
        });
    }
}
function createSplash() {
    titleText = new FlxText(0, 0, 0, "");
    titleText.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE);
    titleText.updateHitbox();
    titleText.screenCenter(FlxAxes.X);
    titleText.text = '';
    titleText.y = 600;
    titleText.alpha = 1;
	titleText.camera = camw;
    add(titleText);

    typeNextLetter();

}
function typeTitle() {
    titleText.text += fullTitle.charAt(titleIndex);
    titleIndex++;

    if (titleIndex >= fullTitle.length) {
        delayTimer.start(3, function(_) {
            FlxTween.tween(titleText, {alpha: 0}, 3.6);
        });
    }
}

function typeSubtitle() {
    subtitleText.text += fullSubtitle.charAt(subtitleIndex);
    subtitleIndex++;

    if (subtitleIndex >= fullSubtitle.length) {
        fadeOutTimer.start(2, function(_) {
            FlxTween.tween(titleText, {alpha: 0}, 0.6);
        });
    }
}


function typeNextLetter():Void {
    if (titleIndex < fullTitle.length) {
        titleText.text += fullTitle.charAt(titleIndex);
        titleIndex++;
        letterTimer.start(0.025, function(_) typeNextLetter());
    } else {
        FlxG.sound.play(Paths.sound('textNoise'));
        FlxG.sound.music.volume = 1;

        fadeOutTimer.start(2, function(_) {
            titleText.alpha = 0;
        });
    }
}