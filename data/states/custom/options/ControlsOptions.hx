import flixel.text.FlxTextBorderStyle;
import Date;
import DateTools;

var options:Array = [];
var noteOptions:Array = [];

var p1ControlsNotes:Array<Dynamic> = [];
var p2ControlsNotes:Array<Dynamic> = [];
var p1FuckAssArrowIcons:Array<FlxSprite> = [];
var p2FuckAssArrowIcons:Array<FlxSprite> = [];
var page:Int = 0;

var optionNum:Int = 0;
var scrollOffset:Int = 0;
var visibleRows:Int = 5;

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

function getKeyImage(k:String):String {
    return switch(k.toUpperCase()) {
        case 'LEFT', '←': 'arrowLeft';
        case 'DOWN', '↓': 'arrowDown';
        case 'UP', '↑', '^': 'arrowUp';
        case 'RIGHT', '→': 'arrowRight';
        default: null;
    }
}

function create() {
    bg = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xFF6617B5);
    insert(0, bg);

    topLayer = new FlxSprite(0, 0).makeGraphic(1280, 130, 0xFF000000);
    topLayer.alpha = 0.5;
    insert(100, topLayer);

    selectedOption = new FlxSprite(40, 210).makeGraphic(1086, 75, 0xFF470C60);
    insert(1, selectedOption);

    arrowUp = new FlxText();
    arrowUp.text = '^';
    arrowUp.setFormat(Paths.font('vcr.ttf'), 75, 0xFFffcaec, 'left', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    arrowUp.antialiasing = false;
    arrowUp.screenCenter(FlxAxes.X);
    arrowUp.y += 140;
    add(arrowUp);

    arrowDown = new FlxText();
    arrowDown.text = '^';
    arrowDown.setFormat(Paths.font('vcr.ttf'), 75, 0xFFffcaec, 'left', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    arrowDown.antialiasing = false;
    arrowDown.screenCenter(FlxAxes.X);
    arrowDown.y = FlxG.height - 180;
    arrowDown.angle = 180;
    add(arrowDown);

    for (a in 0...shitsA.length) {
        var yPos = 207 + (67 * a);
        var labelText = shitsB[a];
        var labelSprite:FlxSprite = null;


        if (labelSprite != null) {
            labelSprite.setGraphicSize(60, 60);
            labelSprite.updateHitbox();
            noteOptions.push(labelSprite);
            insert(103 + a, labelSprite);
        } else {
            var text = new FlxText(50, yPos, FlxG.width, labelText, 75);
            text.setFormat(Paths.font('vcr.ttf'), 75, 0xFFffcaec, 'left', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            noteOptions.push(text);
            insert(103 + a, text);
        }

        var keyP1:String = CoolUtil.keyToString(Reflect.field(Options, 'P1_' + shitsA[a])[0]);
        var iconP1:String = getKeyImage(keyP1);

        if (iconP1 != null) {
            var arrow = new FlxSprite(550, yPos).loadGraphic(Paths.image('menus/onionMenu/' + iconP1));
            arrow.setGraphicSize(48, 48);
            arrow.updateHitbox();
            p1ControlsNotes.push(arrow);
            insert(150 + a, arrow);
        } else {
            var p1 = new FlxText(550, yPos, FlxG.width, keyP1, 75);
            p1.setFormat(Paths.font('vcr.ttf'), 75, 0xFFffcaec, 'left', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            insert(150 + a, p1);
            p1ControlsNotes.push(p1);
        }

        var keyP2:String = CoolUtil.keyToString(Reflect.field(Options, 'P2_' + shitsA[a])[0]);
        var iconP2:String = getKeyImage(keyP2);

        if (iconP2 != null) {
            var arrow = new FlxSprite(850, yPos).loadGraphic(Paths.image('menus/onionMenu/' + iconP2));
            arrow.setGraphicSize(48, 48);
            arrow.updateHitbox();
            arrow.alpha = 0.5;
            p2ControlsNotes.push(arrow);
            insert(160 + a, arrow);
        } else {
            var p2 = new FlxText(850, yPos, FlxG.width, keyP2, 75);
            p2.setFormat(Paths.font('vcr.ttf'), 75, 0xFFffcaec, 'left', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            p2.alpha = 0.5;
            insert(160 + a, p2);
            p2ControlsNotes.push(p2);
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

    settingsPage = new FlxText(50, 10, 0, 'OPTIONS  CONTROLS', 20);
    settingsPage.setFormat(Paths.font('vcr.ttf'), 60, 0xFFffcaec, 'left', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    insert(105, settingsPage);

    helperArrowB = new FlxSprite(settingsPage.width + 70, settingsPage.height / 3).loadGraphic(Paths.image('menus/onionMenu/arrowSmall'));
    add(helperArrowB);

    FlxG.camera.zoom = 1;

    changeItem(0);
}

function postCreate() controls.ACCEPT = false;
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
        var frame = getArrowFrameFor(strKey);

        clearArrowIcons(optionNum);

        if (!onP2) {
            if (frame != -1) {
                var icon = makeArrowSprite(p1ControlsNotes[optionNum].x, p1ControlsNotes[optionNum].y, frame);
                add(icon);
                p1FuckAssArrowIcons[optionNum] = icon;
                p1ControlsNotes[optionNum].visible = false;
            } else {
                p1ControlsNotes[optionNum].text = strKey;
                p1ControlsNotes[optionNum].visible = true;
            }
            Reflect.setField(Options, 'P1_' + shitsA[optionNum], [newKey]);
        } else {
            if (frame != -1) {
                var icon = makeArrowSprite(p2ControlsNotes[optionNum].x, p2ControlsNotes[optionNum].y, frame);
                icon.alpha = 0.5;
                add(icon);
                p2FuckAssArrowIcons[optionNum] = icon;
                p2ControlsNotes[optionNum].visible = false;
            } else {
                p2ControlsNotes[optionNum].text = strKey;
                p2ControlsNotes[optionNum].visible = true;
            }
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

    if (optionNum < scrollOffset) scrollOffset = optionNum;
    if (optionNum >= scrollOffset + visibleRows) scrollOffset = optionNum - visibleRows + 1;

    for (i in 0...shitsA.length) {
        var visibleIndex = i - scrollOffset;
        var baseY = 210 + (visibleIndex * 66);
        var onScreen = visibleIndex >= 0 && visibleIndex < visibleRows;

        noteOptions[i].visible = onScreen;
        p1ControlsNotes[i].visible = onScreen;
        p2ControlsNotes[i].visible = onScreen;

        if (p1FuckAssArrowIcons[i] != null) p1FuckAssArrowIcons[i].visible = onScreen;
        if (p2FuckAssArrowIcons[i] != null) p2FuckAssArrowIcons[i].visible = onScreen;

        if (onScreen) {
            noteOptions[i].y = baseY - 3;
            p1ControlsNotes[i].y = baseY;
            p2ControlsNotes[i].y = baseY;
            if (p1FuckAssArrowIcons[i] != null) p1FuckAssArrowIcons[i].y = baseY;
            if (p2FuckAssArrowIcons[i] != null) p2FuckAssArrowIcons[i].y = baseY;
        }
    }

    selectedOption.y = 210 + ((optionNum - scrollOffset) * 66);

    arrowDown.alpha = optionNum < shitsA.length - 1 ? 1 : 0;
    arrowUp.alpha = optionNum > 0 ? 1 : 0;
}

function getArrowFrameFor(k:String):Int {
    return switch(k.toUpperCase()) {
        case 'LEFT': 0;
        case 'DOWN': 1;
        case 'UP': 2;
        case 'RIGHT': 3;
        default: -1;
    }
}

function makeArrowSprite(x:Float, y:Float, frame:Int):FlxSprite {
    var sprite = new FlxSprite(x, y + 10).loadGraphic(Paths.image('menus/onionMenu/arrows'), true, 48, 48);
    sprite.animation.add('arrow', [frame], 0, false);
    sprite.animation.play('arrow');
    sprite.antialiasing = false;
    return sprite;
}

function clearArrowIcons(index:Int) {
    if (p1FuckAssArrowIcons[index] != null) {
        remove(p1FuckAssArrowIcons[index]);
        p1FuckAssArrowIcons[index] = null;
    }
    if (p2FuckAssArrowIcons[index] != null) {
        remove(p2FuckAssArrowIcons[index]);
        p2FuckAssArrowIcons[index] = null;
    }
}
