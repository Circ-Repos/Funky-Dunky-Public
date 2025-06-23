import flixel.text.FlxTextBorderStyle;
import Date;
import DateTools;

var options:Array = [];
var curOption:Array = [];

var optionNum:Int = 0;
var optionItemFix:Int = 0;

var shits:Array<String> = ['downscroll', 'ghostTapping', 'songOffset', 'naughtyness', 'camZoomOnBeat'];
var songOffsetSetter:Int = 0;

function create(){
    bg = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xFF6617B5);
    insert(0, bg);

    topLayer = new FlxSprite(0, 0).makeGraphic(1280, 130, 0xFF000000);
    topLayer.alpha = 0.5;
    insert(100, topLayer);

    selectedOption =  new FlxSprite(40, 210).makeGraphic(1086, 75, 0xFF470C60);
    insert(1, selectedOption);

    for(a in 0...5){
        options.push(new FlxText(50, 207 + (67 * a), FlxG.width, ["DOWNSCROLL", 'GHOST TAPPING', 'SONG OFFSET', "NAUGHTYNESS", "CAM ZOOM ON BEAT"][a], 75));
        options[a].setFormat(Paths.font('vcr.ttf'), 75, 0xFFffcaec, 'left', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        insert(2 + a, options[a]).antialiasing = false;

        curOption.push(a == 2 ? new FlxText(950, options[2].y, 0, Options.songOffset, 75) : new FlxSprite(940, 220 + (67 * a)).loadGraphic(Paths.image('menus/onionMenu/checkedBox'), true, 35, 35));
        insert(options.length + 1 + a, curOption[a]).antialiasing = false;

        if(a == 2){
            curOption[a].setFormat(Paths.font('vcr.ttf'), 75, 0xFFffcaec, 'left', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        } else {
            curOption[a].setGraphicSize(50, 50);
            curOption[a].updateHitbox();
            curOption[a].animation.add('false', [1], 1, false);
            curOption[a].animation.add('true', [0], 1, false);
            curOption[a].animation.play(Reflect.field(Options, shits[a]));
        }
    }

    helperArrowA = new FlxSprite(249 + 70, 57 / 3).loadGraphic(Paths.image('menus/onionMenu/arrowSmall'));
    insert(102, helperArrowA);

    bottomLayer = new FlxSprite(0, FlxG.height - 100).makeGraphic(1280, 100, 0xFF000000);
    bottomLayer.alpha = 0.5;
    insert(101, bottomLayer);

    time = new FlxText(-50, FlxG.height - 80, FlxG.width, '', 20);
    time.setFormat(Paths.font('vcr.ttf'), 60, 0xFFffcaec, 'right', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    insert(104, time);

    settingsPage = new FlxText(50, 10, 0, 'OPTIONS  APPEARENCE', 20);
    settingsPage.setFormat(Paths.font('vcr.ttf'), 60, 0xFFffcaec, 'left', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    insert(105, settingsPage);

    helperArrowB = new FlxSprite(settingsPage.width + 70, settingsPage.height / 3).loadGraphic(Paths.image('menus/onionMenu/arrowSmall'));
    add(helperArrowB);

    changeItem(0);

    FlxG.camera.zoom = 1;
}

function postCreate(){
    controls.ACCEPT = false;
    curOption[2].x = FlxG.width - 290 - curOption[2].width;
}

function postUpdate(){
    time.text = DateTools.format(Date.now(), "%r");
    if(controls.BACK) close();

    if(controls.UP_P || controls.DOWN_P) changeItem((controls.UP_P ? -1 : 0) + (controls.DOWN_P ? 1 : 0));

    switch(optionNum){
        case 2:
            if((controls.LEFT_P || controls.RIGHT_P)){
                Options.songOffset += (controls.LEFT_P ? -1 : 1) * (FlxG.keys.pressed.SHIFT ? 10 : 1);

                curOption[2].text = Options.songOffset;
                curOption[2].x = FlxG.width - 290 - curOption[2].width;
            }
        default:
            if(controls.ACCEPT){
                Reflect.setField(Options, shits[optionNum], !Reflect.field(Options, shits[optionNum]));
                curOption[optionNum].animation.play(Reflect.field(Options, shits[optionNum]) ? "true" : "false");
                Options.applySettings();
            }
    }


}

function changeItem(bleh){
    if(optionNum > 3 && controls.DOWN_P) optionNum = 0;
    else if(optionNum < 1 && controls.UP_P) optionNum = 4; 
    else optionNum += bleh;
    selectedOption.y = 210 + (optionNum * 66);

    trace(optionNum);
}