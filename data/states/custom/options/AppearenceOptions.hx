import flixel.text.FlxTextBorderStyle;
import Date;
import DateTools;
import funkin.backend.system.framerate.Framerate;

var options:Array<FlxText> = [];
var curOption:Array<Dynamic> = [];

var optionNum:Int = 0;
var scrollOffset:Int = 0;
var visibleRows:Int = 5;

var gameFPS:Int = Options.framerate;
var shits:Array<String> = ['framerate', 'antialiasing', 'gameplayShaders', 'flashingMenu', 'lowMemoryMode', 'gpuOnlyBitmaps', 'autoPause', 'fpsWatermark', 'showFPS'];
var labels:Array<String> = ["FRAMERATE", "ANTIALIASING", "SHADERS", "FLASHING LIGHTS", "LOW MEMORY MODE", "VRAM SPRITES", "AUTO PAUSE", "FPS WATERMARK", "SHOW FPS"];

function create() {
    bg = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xFF6617B5);
    insert(0, bg);

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

    topLayer = new FlxSprite(0, 0).makeGraphic(1280, 130, 0xFF000000);
    topLayer.alpha = 0.5;
    insert(100, topLayer);

    selectedOption = new FlxSprite(40, 210).makeGraphic(1086, 75, 0xFF470C60);
    insert(1, selectedOption);

    for (a in 0...shits.length) {
        options.push(new FlxText(50, 207 + (67 * a), FlxG.width, labels[a], 75));
        options[a].setFormat(Paths.font('vcr.ttf'), 75, 0xFFffcaec, 'left', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        options[a].antialiasing = false;
        insert(2 + a, options[a]);

        switch(a){
            case 0:
                var fpsText = new FlxText(900, options[a].y, 0, gameFPS + "", 75);
                fpsText.setFormat(Paths.font('vcr.ttf'), 75, 0xFFffcaec, 'left', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
                fpsText.antialiasing = false;
                curOption.push(fpsText);
                insert(100 + a, fpsText);
            case 7 | 8:
                var check = new FlxSprite(940, 220 + (67 * a)).loadGraphic(Paths.image('menus/onionMenu/checkedBox'), true, 35, 35);
                check.setGraphicSize(50, 50);
                check.updateHitbox();
                check.antialiasing = false;
                check.animation.add('false', [1], 1, false);
                check.animation.add('true', [0], 1, false);
                check.animation.play(Reflect.field(FlxG.save.data, shits[a]));
                curOption.push(check);
                insert(100 + a, check);
            default:
                var check = new FlxSprite(940, 220 + (67 * a)).loadGraphic(Paths.image('menus/onionMenu/checkedBox'), true, 35, 35);
                check.setGraphicSize(50, 50);
                check.updateHitbox();
                check.antialiasing = false;
                check.animation.add('false', [1], 1, false);
                check.animation.add('true', [0], 1, false);
                check.animation.play(Reflect.field(Options, shits[a]));
                curOption.push(check);
                insert(100 + a, check);

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

    settingsPage = new FlxText(50, 10, 0, 'OPTIONS  APPEARANCE', 20);
    settingsPage.setFormat(Paths.font('vcr.ttf'), 60, 0xFFffcaec, 'left', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    insert(105, settingsPage);

    helperArrowB = new FlxSprite(settingsPage.width + 70, settingsPage.height / 3).loadGraphic(Paths.image('menus/onionMenu/arrowSmall'));
    add(helperArrowB);

    changeItem(0);
}

function postCreate() controls.ACCEPT = false;

function postUpdate() {
    time.text = DateTools.format(Date.now(), "%r");

    if (controls.BACK) close();

    if (controls.UP_P || controls.DOWN_P)
        changeItem((controls.UP_P ? -1 : 1));

    switch (optionNum) {
        case 0:
            if (controls.LEFT_P || controls.RIGHT_P) {
                gameFPS = FlxMath.bound(gameFPS + (controls.LEFT_P ? -1 : 1) * (FlxG.keys.pressed.SHIFT ? 10 : 1), 30, 240);
                if (FlxG.updateFramerate < gameFPS) FlxG.drawFramerate = FlxG.updateFramerate = gameFPS;
                else FlxG.updateFramerate = FlxG.drawFramerate = gameFPS;

                curOption[0].text = gameFPS + "";
                curOption[0].x = FlxG.width - 290 - curOption[0].width;
            }
        case 7 | 8:
            if (controls.ACCEPT) {
                if(optionNum == 7 && FlxG.save.data.showFPS == false){
                    CoolUtil.playMenuSFX(2, 0.7);
                    return;
                }
                var key:String = shits[optionNum];
                var value:Bool = !Reflect.field(FlxG.save.data, key);
                Reflect.setField(FlxG.save.data, key, value);
                curOption[optionNum].animation.play(value ? "true" : "false");
		        Framerate.codenameBuildField.visible = FlxG.save.data.fpsWatermark;
		        Framerate.codenameBuildField.visible = FlxG.save.data.fpsWatermark;
                if(!FlxG.save.data.showFPS){
                    FlxG.save.data.showFPS = false;
                    Framerate.codenameBuildField.visible = false;
                    Framerate.fpsCounter.visible = false;
                    Framerate.memoryCounter.visible = false;
                }
                if(FlxG.save.data.showFPS){
                    FlxG.save.data.showFPS = true;
                    Framerate.codenameBuildField.visible = Framerate.codenameBuildField.visible;
                    Framerate.fpsCounter.visible = true;
                    Framerate.memoryCounter.visible = true;
                }
            }
        default:
            if (controls.ACCEPT) {
                var key:String = shits[optionNum];
                var value:Bool = !Reflect.field(Options, key);
                Reflect.setField(Options, key, value);
                curOption[optionNum].animation.play(value ? "true" : "false");
                Options.applySettings();
            }
    }
}

function changeItem(bleh:Int) {
    optionNum += bleh;
    if (optionNum < 0) optionNum = shits.length - 1;
    if (optionNum >= shits.length) optionNum = 0;

    // Update scroll offset
    if (optionNum < scrollOffset) scrollOffset = optionNum;
    if (optionNum >= scrollOffset + visibleRows) scrollOffset = optionNum - visibleRows + 1;

    for (i in 0...shits.length) {
        var visibleIndex = i - scrollOffset;
        var yPos = 207 + (visibleIndex * 67);

        var onScreen = visibleIndex >= 0 && visibleIndex < visibleRows;

        options[i].visible = onScreen;
        curOption[i].visible = onScreen;

        if (onScreen) {
            options[i].y = yPos;
            if (i == 0)
                curOption[i].y = yPos;
            else
                curOption[i].y = yPos + 13;
        }
    }
    if(optionNum == 8) arrowDown.alpha = 0;
    else
        arrowDown.alpha = 1;
    if(optionNum == 0) arrowUp.alpha = 0;
    if(optionNum == 5)
        arrowUp.alpha = 1;
    selectedOption.y = 210 + ((optionNum - scrollOffset) * 67);
}
