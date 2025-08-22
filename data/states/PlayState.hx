public var lerpScore:Int = 0;
public var intendedScore:Int = 0;
var displayedAccuracy:Float = 0;
public var treetime:Bool = false;
var songName:String = PlayState.SONG.meta.name.toLowerCase();

function stepHit(curStep:Int) {
	if(songName == 'gift'){
		switch(curStep){
			case 2080:
				treetime = true;
		}
	}
}
function postUpdate(elapsed)
{
	if(!treetime){
	intendedScore = songScore;
	lerpScore = Math.floor(FlxMath.lerp(intendedScore, lerpScore, Math.exp(-elapsed * 24)));
	scoreTxt.text = 'Score: ' + lerpScore;

	// Smoothly interpolate the displayed accuracy towards the actual accuracy
	displayedAccuracy = FlxMath.lerp(displayedAccuracy, accuracy, 0.15);
	displayedAccuracy = FlxMath.bound(displayedAccuracy, 0, 100); // Ensure it's within 0-100%

	// Round to two decimal places
	var roundedAcc:Float = Math.round(displayedAccuracy * 100) / 1;
	if(accuracy == 0) accuracyTxt.text = 'Accuracy:0 -% - ' + curRating.rating;
	else accuracyTxt.text = 'Accuracy:' + roundedAcc + '% - ' + curRating.rating;
	}
	else{
		scoreTxt.text = 'Score: 333333';
		missesTxt.text = 'Misses: 3333';
		accuracyTxt.text = 'Accuracy: 33.33%';
	}

}