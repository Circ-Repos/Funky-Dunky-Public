import funkin.editors.ui.UIWarningSubstate;
import funkin.backend.system.framerate.Framerate;
import flixel.text.FlxTextAlign;
import flixel.text.FlxTextFormatMarkerPair;
import flixel.text.FlxTextFormat;
import funkin.menus.ui.Alphabet;
var updateNOW:FunkinText;
var updateNOW2:FunkinText;
var versionText:FunkinText;

function create() {
    titleAlphabetfake = new Alphabet(0, 0, "OUTDATED VERSION", true);
    titleAlphabetfake.screenCenter(FlxAxes.X);
    add(titleAlphabetfake);

    updateNOW = new FunkinText(0, titleAlphabetfake.y + titleAlphabetfake.height + 10, FlxG.width, "", 32);
    updateNOW.applyMarkup('Hi There\n You appear to be using a *outdated version* of *Codename Engine*.\n That means *majority of the features* are either *buggy* or *non finished*. Please update to actually play the mod for what its for\n if you dont, i cant guarantee a good experience\n\n Sincerly, *Circuitella*',
        [
            new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFFF4444), "*")
        ]
    );
    updateNOW.alignment = FlxTextAlign.CENTER;

    add(updateNOW);

    var off = Std.int((FlxG.height - (updateNOW.y + updateNOW.height)) / 2);
    updateNOW.y += off;
    titleAlphabetfake.y += off;
}
function update(elapsed:Float) {
    if(controls.ACCEPT) controls.ACCEPT = false;
    titleAlphabet.alpha = 0;
    disclaimer.alpha = 0;
    Framerate.debugMode = 0;
}