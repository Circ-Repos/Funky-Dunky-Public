public var lerpScore:Int = 0;
public var intendedScore:Int = 0;
var displayedAccuracy:Float = 0;
var upscaleAmt = 4;

function postCreate()
{
	for (i in [scoreTxt, missesTxt, accuracyTxt])
	{
		i.size *= upscaleAmt;
		i.scale.x /= upscaleAmt;
		i.scale.y /= upscaleAmt;
		i.antialiasing = true;
		i.y -= 21;
		i.borderSize *= upscaleAmt;
		i.fieldWidth += 1000;
		i.x -= 1000/2;
		i.borderQuality = 100;
	}

	scoreTxt.x += 65;
	accuracyTxt.x -= 80;
}

function postUpdate(elapsed)
{
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