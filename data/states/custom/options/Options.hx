import funkin.options.TreeMenu;
import flixel.text.FlxTextBorderStyle;
import Date;
import DateTools;

var optionNum:Int = 0;

var subMenu = [
    'ControlsOptions',
    'GameplayOptions',
    'AppearenceOptions',
    'DevOptions'
];

function create(){
    bg = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xFF6617B5);
    insert(0, bg);

    topLayer = new FlxSprite(0, 0).makeGraphic(1280, 130, 0xFF000000);
    topLayer.alpha = 0.5;
    insert(100, topLayer);

    selectedOption =  new FlxSprite(40, 210).makeGraphic(1086, 75, 0xFF470C60);
    insert(1, selectedOption);

    settingsOptions = new FlxText(50, 210, FlxG.width, 'CONTROLS\nGAMEPLAY\nAPPEARANCE\nDEV STUFF\nRESET DATA', 20);
    settingsOptions.setFormat(Paths.font('vcr.ttf'), 75, 0xFFffcaec, 'left', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    insert(2, settingsOptions);

    helperArrowA = new FlxSprite(249 + 70, 57 / 3).loadGraphic(Paths.image('menus/onionMenu/arrowSmall'));
    insert(102, helperArrowA);

    bottomLayer = new FlxSprite(0, FlxG.height - 100).makeGraphic(1280, 100, 0xFF000000);
    bottomLayer.alpha = 0.5;
    insert(101, bottomLayer);

    time = new FlxText(-50, FlxG.height - 80, FlxG.width, '', 20);
    time.setFormat(Paths.font('vcr.ttf'), 60, 0xFFffcaec, 'right', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    insert(104, time);

    settingsPage = new FlxText(50, 10, 0, 'OPTIONS  ', 20);
    settingsPage.setFormat(Paths.font('vcr.ttf'), 60, 0xFFffcaec, 'left', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    insert(105, settingsPage);

    resetWindow = new FlxSprite(0, 0).makeGraphic(1280, 720, 0xFF000000);
    resetWindow.alpha = 0;
    insert(200, resetWindow);

    resetTxtA = new FlxText(0, 180, FlxG.width, 'ARE YOU SURE?', 20);
    resetTxtA.setFormat(Paths.font('vcr.ttf'), 75, 0xFFffcaec, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    resetTxtA.alpha = 0;
    insert(201, resetTxtA);

    resetTxtB = new FlxText(0, 500, FlxG.width, '(PRESS ENTER TO CONFIRM)\n(PRESS BACK TO DENY)', 20);
    resetTxtB.setFormat(Paths.font('vcr.ttf'), 75, 0xFFffcaec, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    resetTxtB.alpha = 0;
    insert(202, resetTxtB);

    changeItem(0);

    //
}

var allowControl:Bool = true;
var allowSecondControl:Bool = false;

function update(elapsed){
    if(allowControl){
        if(controls.UP_P || controls.DOWN_P) changeItem((controls.UP_P ? -1 : 0) + (controls.DOWN_P ? 1 : 0));
        if(controls.ACCEPT) selectOption();
        if(controls.BACK){
            Options.save();
            if(TreeMenu.lastState != null)
            {
                TreeMenu.lastState = null;
                FlxG.switchState(new PlayState());
            }
            else FlxG.switchState(new MainMenuState());
        }
    } else {
        if(allowSecondControl){
            if(controls.ACCEPT){
                trace('lemme get back to you');
                allowSecondControl = false;
                resetWindow.alpha = resetTxtA.alpha = resetTxtB.alpha = 0;
                allowControl = true;
            } else if(controls.BACK){
                allowSecondControl = false;
                resetWindow.alpha = resetTxtA.alpha = resetTxtB.alpha = 0;
                allowControl = true;
            }

        }
    }

    time.text = DateTools.format(Date.now(), "%r");
}

function changeItem(bleh){
    if(optionNum > 3 && controls.DOWN_P) optionNum = 0;
    else if(optionNum < 1 && controls.UP_P) optionNum = 4; 
    else optionNum += bleh;
    selectedOption.y = 210 + (optionNum * 66);
}

function selectOption(){
    if(optionNum != 4){
        persistentUpdate = persistentDraw = false;
        openSubState(new ModSubState('custom/options/' + subMenu[optionNum]));
    } else {
        allowControl = false;
        FlxTween.tween(resetWindow, {alpha: 0.75}, 1);
        FlxTween.tween(resetTxtA, {alpha: 1}, 1, {startDelay: 1});
        FlxTween.tween(resetTxtB, {alpha: 1}, 1, {startDelay: 2, onComplete: function(){
            allowSecondControl = true;
        }});
    }
}