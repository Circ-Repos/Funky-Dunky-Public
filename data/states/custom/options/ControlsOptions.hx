import flixel.text.FlxTextBorderStyle;
import Date;
import DateTools;

var options:Array = [];
var noteOptions:Array = [];

var p1ControlsNotes:Array = [];
var p2ControlsNotes:Array = [];
var page:Int = 0;

var optionNum:Int = 0;
var scrollOffset:Int = 0;
var visibleRows:Int = 6;

var shitsA:Array<String> = [
    'NOTE_LEFT', 'NOTE_DOWN', 'NOTE_UP', 'NOTE_RIGHT',
    'LEFT', 'DOWN', 'UP', 'RIGHT',
    'ACCEPT', 'BACK'
];

var shitsB:Array<String> = [
    'NOTE LEFT', 'NOTE DOWN', 'NOTE UP', 'NOTE RIGHT',
    'UI LEFT', 'UI DOWN', 'UI UP', 'UI RIGHT',
    'ACCEPT', 'BACK'
];

var helper:Array = ['←', '⌄', '^', '→'];

function create() {
    bg = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xFF6617B5);
    insert(0, bg);

    topLayer = new FlxSprite(0, 0).makeGraphic(1280, 130, 0xFF000000);
    topLayer.alpha = 0.5;
    insert(100, topLayer);

    selectedOption = new FlxSprite(40, 210).makeGraphic(1086, 75, 0xFF470C60);
    insert(1, selectedOption);

    for (a in 0...shitsA.length) {
        var yPos = 207 + (67 * a);

        noteOptions.push(new FlxText(50, yPos, FlxG.width, shitsB[a], 75));
        noteOptions[a].setFormat(Paths.font('vcr.ttf'), 75, 0xFFffcaec, 'left', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        insert(103 + a, noteOptions[a]);

        var controlArrayP1:Array<FlxKey> = CoolUtil.keyToString(Reflect.field(Options, 'P1_' + shitsA[a])[0]);
        p1ControlsNotes.push(new FlxText(550, yPos, FlxG.width, controlArrayP1, 75));
        p1ControlsNotes[a].setFormat(Paths.font('vcr.ttf'), 75, 0xFFffcaec, 'left', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        insert(50 + a, p1ControlsNotes[a]);

        var controlArrayP2:Array<FlxKey> = CoolUtil.keyToString(Reflect.field(Options, 'P2_' + shitsA[a])[0]);
        p2ControlsNotes.push(new FlxText(850, yPos, FlxG.width, controlArrayP2, 75));
        p2ControlsNotes[a].setFormat(Paths.font('vcr.ttf'), 75, 0xFFffcaec, 'left', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        p2ControlsNotes[a].alpha = 0.5;
        insert(50 + a, p2ControlsNotes[a]);
    }

    helperArrowA = new FlxSprite(249 + 70, 57 / 3).loadGraphic(Paths.image('menus/onionMenu/arrowSmall'));
    insert(102, helperArrowA);

    bottomLayer = new FlxSprite(0, FlxG.height - 100).makeGraphic(1280, 100, 0xFF000000);
    bottomLayer.alpha = 0.5;
    insert(101, bottomLayer);

    time = new FlxText(-50, FlxG.height - 80, FlxG.width, '', 20);
    time.setFormat(Paths.font('vcr.ttf'), 60, 0xFFffcaec, 'right', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    insert(104, time);

    settingsPage = new FlxText(50, 10, 0, 'OPTIONS  CONTROLS', 20);
    settingsPage.setFormat(Paths.font('vcr.ttf'), 60, 0xFFffcaec, 'left', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    insert(105, settingsPage);

    helperArrowB = new FlxSprite(settingsPage.width + 70, settingsPage.height / 3).loadGraphic(Paths.image('menus/onionMenu/arrowSmall'));
    add(helperArrowB);

    FlxG.camera.zoom = 1;

    changeItem(0);
}

function postCreate() {
    controls.ACCEPT = false;
}

var onP2:Bool = false;
var allowControl:Bool = true;
var inputRequired:Bool = false;

function postUpdate() {
    time.text = DateTools.format(Date.now(), "%r");

    if (allowControl) {
        if (controls.BACK) close();

        if (controls.UP_P || controls.DOWN_P)
            changeItem((controls.UP_P ? -1 : 1));

        if (controls.LEFT_P || controls.RIGHT_P) {
            onP2 = controls.RIGHT_P;
            for (a in 0...shitsA.length) {
                p1ControlsNotes[a].alpha = onP2 ? 0.5 : 1;
                p2ControlsNotes[a].alpha = onP2 ? 1 : 0.5;
            }
        }

        if (controls.ACCEPT) {
            allowControl = false;
            controls.ACCEPT = false;

            if (!onP2)
                p1ControlsNotes[optionNum].text = 'Input?';
            else
                p2ControlsNotes[optionNum].text = 'Input?';

            new FlxTimer().start(0.1, function(_) inputRequired = true);
        }
    }

    if (inputRequired && FlxG.keys.justPressed.ANY) {
        var newKey = FlxG.keys.firstJustPressed();
        var strKey = CoolUtil.keyToString(newKey);

        if (!onP2) {
            p1ControlsNotes[optionNum].text = strKey;
            Reflect.setField(Options, 'P1_' + shitsA[optionNum], [newKey]);
        } else {
            p2ControlsNotes[optionNum].text = strKey;
            Reflect.setField(Options, 'P2_' + shitsA[optionNum], [newKey]);
        }

        Options.applyKeybinds();
        Options.save();
        inputRequired = false;
        allowControl = true;
    }
}

function changeItem(bleh:Int) {
    optionNum += bleh;
    if (optionNum < 0) optionNum = shitsA.length - 1;
    if (optionNum >= shitsA.length) optionNum = 0;

    // scrollOffset is the topmost visible item index
    if (optionNum < scrollOffset) scrollOffset = optionNum;
    if (optionNum >= scrollOffset + visibleRows) scrollOffset = optionNum - visibleRows + 1;

    // update visible positions
    for (i in 0...shitsA.length) {
        var visibleIndex = i - scrollOffset;
        var baseY = 210 + (visibleIndex * 66);

        var onScreen = visibleIndex >= 0 && visibleIndex < visibleRows;

        noteOptions[i].visible = onScreen;
        p1ControlsNotes[i].visible = onScreen;
        p2ControlsNotes[i].visible = onScreen;

        if (onScreen) {
            noteOptions[i].y = baseY - 3;
            p1ControlsNotes[i].y = baseY;
            p2ControlsNotes[i].y = baseY;
        }
    }

    // selectedOption position remains within 5 slots
    selectedOption.y = 210 + ((optionNum - scrollOffset) * 66);
}
