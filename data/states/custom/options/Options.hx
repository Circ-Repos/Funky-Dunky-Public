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

    changeItem(0);
}

function update(elapsed){
    if(controls.UP_P || controls.DOWN_P) changeItem((controls.UP_P ? -1 : 0) + (controls.DOWN_P ? 1 : 0));
    if(controls.ACCEPT) selectOption();


    time.text = DateTools.format(Date.now(), "%r");
    if(controls.BACK){
        Options.save();
        FlxG.switchState(new MainMenuState());
    }
}

function changeItem(bleh){
    if(optionNum > 3 && controls.DOWN_P) optionNum = 0;
    else if(optionNum < 1 && controls.UP_P) optionNum = 4; 
    else optionNum += bleh;
    selectedOption.y = 210 + (optionNum * 66);
}

function selectOption(){
    if(optionNum != 5){
        persistentUpdate = persistentDraw = false;
        openSubState(new ModSubState('custom/options/' + subMenu[optionNum]));
    }
}