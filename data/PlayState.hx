public var lerpScore:Int = 0;
public var intendedScore:Int = 0;
public var thisisaeviltest:Bool = false;

function postCreate(){
    thisisaeviltest = false;
    PauseSubState.script = "data/scripts/funnyPause";
}
function update(elapsed){
    intendedScore = songScore;
    lerpScore = Math.floor(FlxMath.lerp(intendedScore, lerpScore, Math.exp(-elapsed * 24)));
    scoreTxt.text = 'Score: ' +lerpScore;

}