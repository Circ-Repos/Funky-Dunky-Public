//this is all literally just the exe 2.5 code just ported to cne with some changes to make it work
import flixel.util.FlxAxes;
import openfl.text.TextFormat;
import flixel.text.FlxTextAlign;
import flixel.text.FlxTextBorderStyle;
import sys.FileSystem;
import sys.io.File;
//for the credits at beginning of song lol!
var creditsText:FlxTypedGroup<FlxText>;
var creditoText:FlxText;
var box:FlxSprite;

public var camCredits = new FlxCamera();

function postCreate(){
    FlxG.cameras.add(camCredits, false);
    camCredits.bgColor = 0;
    camCredits.alpha = 1;
}
function endit(){
    remove(creditsText);
    remove(box);
}
function update() if(FlxG.keys.justPressed.BACKSPACE) endit();
function onSongStart(){

    creditsText = new FlxTypedGroup();
    var fullCredits:String = Assets.getText(Paths.txt('../songs/' +SONG.meta.name.toLowerCase()+ '/credits'));

    switch(SONG.meta.name.toLowerCase())
    {
        default:
            if(fullCredits == null || fullCredits == "")
            {
                if(FlxG.save.data.DevModeTracing) trace('No credits found for '+ SONG.meta.name + ', skipping credits.');
                return;
            }
            box = new FlxSprite(0, -1000).loadGraphic(Paths.image("box"));
            box.cameras = [camCredits];
            box.setGraphicSize(Std.int(box.height * 0.8));
            box.screenCenter(FlxAxes.X);
            box.antialiasing = false; //FPS Go UP Bcause no need for aliasing on a fucking box
            add(box);

            var texti:String = 'CREDITS\nunfinished';
            var size:Int = 22;
            texti = fullCredits.split('TIME')[0]; // get the text before the first "Time" tag
            if(texti == null) texti = "CREDITS\nunfinished"; //default text if none is specified

            size = fullCredits.split('SIZE')[1];
            if(size == null) size = "22"; //default size if none is specified
                
            creditoText = new FlxText(0, -1000, 0, texti, 28);
            creditoText.setFormat(Paths.font("VCR.ttf"), Std.parseInt(size), FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            creditoText.cameras = [camCredits];
            creditoText.setGraphicSize(Std.int(creditoText.width * 0.8));
            creditoText.updateHitbox();
            creditoText.screenCenter(FlxAxes.X);
            creditsText.add(creditoText);

            
            if(FlxG.save.data.DevModeTracing) trace('BTW THE SIZE IS ' + Std.parseFloat(size));

    }
    add(creditsText);

    switch (SONG.meta.name.toLowerCase())
    {
        default:
            var timei:String;
            timei = "2.35";

            timei = fullCredits.split("TIME")[1];
            if(timei == null) timei = "2.35"; //default time if none is specified
            if(FlxG.save.data.DevModeTracing) trace('BTW THE TIME IS ' + Std.parseFloat(timei));

            new FlxTimer().start(Std.parseFloat(timei), function(tmr:FlxTimer)
                {
                    tweencredits();
                });
    }}
    function tweencredits()
        {
            FlxTween.tween(creditoText, {y: FlxG.height - 700}, 0.5, {ease: FlxEase.circOut});
            FlxTween.tween(box, {y: 0}, 0.5, {ease: FlxEase.circOut});
            //tween away
            new FlxTimer().start(3, function(tmr:FlxTimer)
                {
                    FlxTween.tween(creditoText, {y: -1000}, 0.5, {ease: FlxEase.circOut});
                    FlxTween.tween(box, {y: -1000}, 0.5, {ease: FlxEase.circOut});
                    //removal
                    new FlxTimer().start(0.5, function(tmr:FlxTimer)
                        {
                            remove(creditsText);
                            remove(box);
                        });
                });
        }