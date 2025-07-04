import flixel.text.FlxTextBorderStyle;
import Date;
import DateTools;

var options:Array = [];
var noteOptions:Array = [];

var p1ControlsNotes:Array = [];
var p2ControlsNotes:Array = [];
var page:Int = 0;

var optionNum:Int = 0;
var optionItemFix:Int = 0;

var shitsA:Array<String> = ['NOTE_LEFT', 'NOTE_DOWN', 'NOTE_UP', 'NOTE_RIGHT'];
var shitsB:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT', 'ACCEPT', 'BACK'];
var songOffsetSetter:Int = 0;
var helper:Array = ['←', '⌄', '^', '→'];

function create(){
    bg = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xFF6617B5);
    insert(0, bg);

    topLayer = new FlxSprite(0, 0).makeGraphic(1280, 130, 0xFF000000);
    topLayer.alpha = 0.5;
    insert(100, topLayer);

    selectedOption =  new FlxSprite(40, 210).makeGraphic(1086, 75, 0xFF470C60);
    insert(1, selectedOption);

    for(a in 0...4){
        noteOptions.push(new FlxText(50, 207 + (67 * a), FlxG.width, ["LEFT", 'DOWN', 'UP', "RIGHT"][a], 75));
        noteOptions[a].setFormat(Paths.font('vcr.ttf'), 75, 0xFFffcaec, 'left', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        insert(103 + a, noteOptions[a]);

        var controlArrayP1:Array<FlxKey> = CoolUtil.keyToString(Reflect.field(Options, 'P1_' + shitsA[a])[0]);
        var controlArrayP2:Array<FlxKey> = CoolUtil.keyToString(Reflect.field(Options, 'P2_' + shitsA[a])[0]);

        p1ControlsNotes.push(new FlxText(550, 207 + (67 * a), FlxG.width, controlArrayP1, 75));
        p1ControlsNotes[a].setFormat(Paths.font('vcr.ttf'), 75, 0xFFffcaec, 'left', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        insert(50 + a, p1ControlsNotes[a]);

        if(p1ControlsNotes[a].text == helper[0...helper.length]){
            helpMe = new FlxSprite(p1ControlsNotes[a].x, p1ControlsNotes[a].y + 10).loadGraphic(Paths.image('menus/onionMenu/arrows'), true, 48, 48);
            p1ControlsNotes[a].alpha = 0;
            //helpMe.animation.add('arrow', [])
            insert(2000, helpMe);
        }

        p2ControlsNotes.push(new FlxText(850, 207 + (67 * a), FlxG.width, controlArrayP2, 75));
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

    changeItem(0);

    FlxG.camera.zoom = 1;
}

function postCreate(){
    controls.ACCEPT = false;
}

var onP2:Bool = false;
var allowControl:Bool = true;
var inputRequired:Bool = false;

function postUpdate(){
    time.text = DateTools.format(Date.now(), "%r");
    if(allowControl){
        if(controls.BACK) close();

        if(controls.UP_P || controls.DOWN_P) changeItem((controls.UP_P ? -1 : 1));

        if(controls.LEFT_P || controls.RIGHT_P){
            onP2 = controls.RIGHT_P;

            if(page == 0){
                for(a in 0...4){
                    p1ControlsNotes[a].alpha = onP2 ? 0.5 : 1;
                    p2ControlsNotes[a].alpha = onP2 ? 1 : 0.5;
                }
            }
        }
        if(controls.ACCEPT){
            allowControl = false;
            controls.ACCEPT = false;
            if(page == 0){
                if(!onP2){
                    p1ControlsNotes[optionNum].text = 'Input?';
                    new FlxTimer().start(0.1, function(timer){
				        inputRequired = true;
			        });
                } else {
                    p2ControlsNotes[optionNum].text = 'Input?';
                    new FlxTimer().start(0.1, function(timer){
				        inputRequired = true;
			        });
                }
            }
        }
    }

    if(inputRequired && FlxG.keys.justPressed.ANY){
        if(!onP2){
            p1ControlsNotes[optionNum].text = CoolUtil.keyToString(FlxG.keys.firstJustPressed());  
            inputRequired = false;
            allowControl = true;
            Reflect.setField(Options, 'P1_' + shitsA[optionNum], [FlxG.keys.firstJustPressed()]);
            Options.applyKeybinds();
            Options.save();
        } else {
            p2ControlsNotes[optionNum].text = CoolUtil.keyToString(FlxG.keys.firstJustPressed());  
            inputRequired = false;
            allowControl = true; 
            Reflect.setField(Options, 'P2_' + shitsA[optionNum], [FlxG.keys.firstJustPressed()]);
            Options.applyKeybinds();
            Options.save();
        }
    }


}

function changeItem(bleh){
    if(optionNum > 2 && controls.DOWN_P) optionNum = 0;
    else if(optionNum < 1 && controls.UP_P) optionNum = 3; 
    else optionNum += bleh;
    selectedOption.y = 210 + (optionNum * 66);

    trace(onP2);
}