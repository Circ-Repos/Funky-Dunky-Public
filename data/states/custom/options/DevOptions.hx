import flixel.text.FlxTextBorderStyle;
import Date;
import DateTools;

var options:Array = [];
var curOption:Array = [];

var optionNum:Int = 0;
var optionItemFix:Int = 0;

// TO-DO: make this less jank
var songShit:Array<String> = ['grace', 'distraught', 'scary-night', 'think', 'gift', 'thonk'];
var shits:Array<String> = ['DevMode', 'DevModeTracing', 'grace', 'distraught', 'scary-night', 'think', 'gift', 'thonk', 'allSongsBeaten'];
var names:Array<String> = ['DEVELOPER MODE', 'TRACES', 'BEATEN GRACE', 'BEATEN DISTRAUGHT', 'BEATEN SCARY NIGHT', 'BEATEN THINK', 'BEATEN GIFT', 'BEATEN THONK', 'ALL SONGS BEATEN'];
var songOffsetSetter:Int = 0;

function create(){
    bg = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xFF6617B5);
    insert(0, bg);

    topLayer = new FlxSprite(0, 0).makeGraphic(1280, 130, 0xFF000000);
    topLayer.alpha = 0.5;
    insert(100, topLayer);

    selectedOption =  new FlxSprite(40, 210).makeGraphic(1086, 75, 0xFF470C60);
    insert(1, selectedOption);

    for(a in 0...shits.length){
        options.push(new FlxText(50, 207 + (67 * a), FlxG.width, names[a], 75));
        options[a].setFormat(Paths.font('vcr.ttf'), 75, 0xFFffcaec, 'left', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        insert(2 + a, options[a]).antialiasing = false;

        curOption.push(new FlxSprite(940, 220 + (67 * a)).loadGraphic(Paths.image('menus/onionMenu/checkedBox'), true, 35, 35));
        insert(options.length + 1 + a, curOption[a]).antialiasing = false;
        curOption[a].setGraphicSize(50, 50);
        curOption[a].updateHitbox();
        curOption[a].animation.add('true', [0], 1, false);
        curOption[a].animation.add('false', [1], 1, false);

        if(shits[a] == songShit[a - 2]) // -2 because of the first 2 options
            curOption[a].animation.play(FlxG.save.data.songsBeaten.contains(shits[optionNum]) ? "true" : "false");
        else curOption[a].animation.play(Reflect.field(FlxG.save.data, shits[a]));
    }

    helperArrowA = new FlxSprite(249 + 70, 57 / 3).loadGraphic(Paths.image('menus/onionMenu/arrowSmall'));
    insert(102, helperArrowA);

    bottomLayer = new FlxSprite(0, FlxG.height - 100).makeGraphic(1280, 100, 0xFF000000);
    bottomLayer.alpha = 0.5;
    insert(101, bottomLayer);

    time = new FlxText(-50, FlxG.height - 80, FlxG.width, '', 20);
    time.setFormat(Paths.font('vcr.ttf'), 60, 0xFFffcaec, 'right', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    insert(104, time);

    settingsPage = new FlxText(50, 10, 0, 'OPTIONS  DEVELOPER', 20);
    settingsPage.setFormat(Paths.font('vcr.ttf'), 60, 0xFFffcaec, 'left', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    insert(105, settingsPage);

    helperArrowB = new FlxSprite(settingsPage.width + 70, settingsPage.height / 3).loadGraphic(Paths.image('menus/onionMenu/arrowSmall'));
    add(helperArrowB);

    changeItem(0);

    FlxG.camera.zoom = 1;
}

function postCreate(){
    controls.ACCEPT = false;
}

function postUpdate()
{
    time.text = DateTools.format(Date.now(), "%r");

    if(controls.BACK) close();

    if(controls.UP_P || controls.DOWN_P) changeItem((controls.UP_P ? -1 : 0) + (controls.DOWN_P ? 1 : 0));

    if(controls.ACCEPT)
    {
        if(shits[optionNum] == songShit[optionNum - 2]) // -2 because of the first 2 options
        {
            if(FlxG.save.data.songsBeaten.contains(shits[optionNum])) FlxG.save.data.songsBeaten.remove(shits[optionNum]);
            else FlxG.save.data.songsBeaten.push(shits[optionNum]);
            curOption[optionNum].animation.play(FlxG.save.data.songsBeaten.contains(shits[optionNum]) ? "true" : "false");
        }
        else
        {
            Reflect.setField(FlxG.save.data, shits[optionNum], !Reflect.field(FlxG.save.data, shits[optionNum]));
            curOption[optionNum].animation.play(Reflect.field(FlxG.save.data, shits[optionNum]) ? "true" : "false");
        }
        //Options.applySettings();
    }
}

function changeItem(bleh)
{
    if(optionNum > 6 && controls.DOWN_P) optionNum = 0;
    else if(optionNum < 1 && controls.UP_P) optionNum = 7; 
    else optionNum += bleh;
    selectedOption.y = 210 + (optionNum * 66);
}