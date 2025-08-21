import funkin.menus.FreeplayState.FreeplaySonglist;
import flixel.FlxObject;
import funkin.backend.system.framerate.Framerate;
import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxTextBorderStyle;
import flixel.tweens.FlxEase;
import funkin.savedata.FunkinSave;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;

var curWeek:Int = 0;

var globalFont:String = 'Times New Roman Italic.ttf';
var songs = FreeplaySonglist.get(true).songs;
var songTexts:Array<FunkinText> = [];
var nameTexts:Array<FunkinText> = [];

var iconArray:Array<HealthIcon> = [];
var bgArray:Array<FlxSprite> = [];
var iconbgArray:Array<FlxSprite> = [];

var scoreText:FunkinText;
var beatText:FunkinText;
var quoteText:FunkinText;
var curindex = 0;
var transitioning = false;
var curSelected = 'null';
var albumSprite:FlxSprite;
//doing it like this frees ram from caching Inst's
var songLengths:Array<String> = ['04:30','03:15', '04:42','02:35','02:40'];

function toTitleCase(input:String):String {
    return input.split(" ").map(word -> 
        word.length > 0 ? word.charAt(0).toUpperCase() + word.substr(1).toLowerCase() : ""
    ).join(" ");
}

var spike1:FlxBackdrop;
var spike2:FlxBackdrop;
var bgWeek1:FlxSprite;

function destroy() Framerate.offset.y = 0; //sadly tweens cant happen
function create() {
	FlxG.mouse.visible = false;

    songList = Json.parse(Assets.getText(Paths.json('../data/songs')));

    FlxTween.tween(Framerate.offset, {y: 70}, 0.74, {ease: FlxEase.quadInOut});
	if(FlxG.sound.music == null) CoolUtil.playMenuSong(false);
    var bgWeek1 = new FlxSprite();
    bgWeek1.loadGraphic(Paths.image('menus/freeplay/freeplay bg'));
    bgWeek1.scrollFactor.set();
    add(bgWeek1);


	tbg = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0xFFBBBBBB, 0xFF000000));
	tbg.antialiasing = false;
	tbg.velocity.set(0, 200);
	tbg.alpha = 0.1;
	add(tbg);

    for (i => song in songs) {
        var bg = new FlxSprite();
        bg.loadGraphic(Paths.image("menus/freeplay/freeplay vhs select"));
        bg.updateHitbox();
        if(song.displayName == 'Thonk') bg.color = 0xFF4DF8; //Why Are You Pink?
        bg.scrollFactor.set();
        add(bg);
        bgArray.push(bg);


        var songText = new FunkinText(0, 0, FlxG.width, toTitleCase(song.displayName), 12);
        songText.alignment = 'center';
        songText.font = Paths.font(globalFont);
        songText.scrollFactor.set();
        songText.antialiasing = false;
        songText.text = '"???"';
        var beatenShit:Bool = false;
        if(FlxG.save.data.beatenGrace && FlxG.save.data.beatenDistraught && FlxG.save.data.beatenScaryNight && FlxG.save.data.beatenThink && FlxG.save.data.beatenGift && FlxG.save.data.beatenThonk) FlxG.save.data.beatenAll = true;
        if(!FlxG.save.data.beatenAll){
        switch(song.displayName){
            case 'Grace':
                beatenShit = FlxG.save.data.beatenGrace;
            case 'Scary Night':
                beatenShit = FlxG.save.data.beatenScaryNight;
            case 'Think':
                beatenShit = FlxG.save.data.beatenThink;
            case 'Distraught':
                beatenShit = FlxG.save.data.beatenDistraught;
            case 'Gift':
                beatenShit = FlxG.save.data.beatenGift;
        }
        if(beatenShit || (song.displayName == 'Thonk')){
            songText.text = '"' + song.displayName.toUpperCase() + '"';
        }
        }
        else{
            songText.text = '"' + song.displayName.toUpperCase() + '"';
        }
        add(songText);

        var nameText = new FunkinText(0, 0, FlxG.width, toTitleCase(song.displayName), 32);
        nameText.alignment = 'center';
        nameText.font = Paths.font(globalFont);
        nameText.scrollFactor.set();
        nameText.antialiasing = false;
        nameText.color = FlxColor.BLACK;
        var iconText:String = song.icon;
        switch(song.icon){
            case 'gabriel-true':
                iconText = 'GABRIEL';
            case 'SIX_DT_Icons':
                iconText = 'SIX';
            case 'intruder':
                iconText = 'INTRUDER';
            case 'lil-ceasers':
                iconText = 'CEASER';
            case 'Mark-Normal':
                iconText = "MARK";
            case 'face':
                iconText = 'Im Fucking Dumb';
            case 'dad':
                iconText = 'Im Fucking Dumb';
            case 'Ceaser-Gift':
                iconText = 'CEASER';
        }
        iconText = iconText.toUpperCase();
        nameText.text = '"???"';
        if(!FlxG.save.data.beatenAll){
        if(beatenShit || (song.displayName == 'Thonk')){
            nameText.text = iconText;
        }
        }
        else{
            nameText.text = iconText;
        }
        nameTexts.push(nameText);
        add(nameText);
        songTexts.push(songText);
        var iconToPush:String = song.icon;
        if(songText.text == '"???"'){
            iconToPush = 'locked';
        }

        var iconbg = new FlxSprite();
        if(song.displayName == 'Thonk') iconbg.color = 0xFF4DF8;
        
        iconbg.frames = Paths.getSparrowAtlas('menus/freeplay/freeplay white icon square');
        iconbg.animation.addByPrefix('idle','white icon square instância');
        iconbg.animation.play('idle');
        iconbg.scrollFactor.set();
        iconbgArray.push(iconbg);
        add(iconbg);

        var icon = new HealthIcon(iconToPush);
        icon.scrollFactor.set();
        if(song.displayName == 'Thonk') icon.color = 0xFF4DF8;

        icon.antialiasing = false;
        iconArray.push(icon);
        add(icon);
    }

    frame = new FlxSprite();
    frame.loadGraphic(Paths.image('menus/freeplay/freeplay portrait white square'));
    frame.screenCenter(FlxAxes.Y);
    frame.y += -60;
    frame.x = FlxG.width - 470;
    frame.scale.set(1.05,1.05);
    frame.antialiasing = false;
    add(frame);

    albumSprite = new FlxSprite(frame.x + 5, frame.x + 5);
	albumSprite.frames = Paths.getSparrowAtlas("menus/freeplay/Freeplay-Portraits");
    albumSprite.animation.addByPrefix("Gift","Gift");
    albumSprite.animation.addByPrefix("Grace","Grace");
    albumSprite.animation.addByPrefix("Scary Night","Scary Night");
    albumSprite.animation.addByPrefix("Think","ThinkFP");
    albumSprite.animation.addByPrefix("Thonk","thonk");
    albumSprite.animation.addByPrefix("Distraught","Distraught");
    albumSprite.scale.set(0.4,0.4);
    albumSprite.antialiasing = true;
    add(albumSprite);

    scoreText = new FunkinText(FlxG.width - 080, FlxG.height - 200, FlxG.width, "", 64);
    scoreText.setFormat(Paths.font(globalFont), 46, FlxColor.WHITE, 'left');
    scoreText.antialiasing = false;
    add(scoreText);

    songPreviewText = new FunkinText(900, 650, FlxG.width, "Now Previewing " + songs[curindex].name, 24);
    songPreviewText.setFormat(Paths.font(globalFont), 32, FlxColor.WHITE, 'right');
    songPreviewText.antialiasing = false;
    songPreviewText.scrollFactor.set();
    songPreviewText.visible = false;
    add(songPreviewText);

    text = new FunkinText(FlxAxes.X - 490, FlxG.height - 12, FlxG.width, 'Press SPACE to preview the song', 46);
    text.setFormat(Paths.font(globalFont), 32, FlxColor.WHITE, 'center');
    text.scrollFactor.set();
    text.textField.antiAliasType = 'ADVANCED';
    text.textField.sharpness = 400;
    add(text);


    scoreText.x -= 329;
    text.x += 65;
    text.y -= 36;

    var divider = new FlxSprite();
    divider.loadGraphic(Paths.image('menus/freeplay/freeplay division'));
    divider.screenCenter(FlxAxes.X);
    divider.x += 55;
    add(divider);

    clock = new FlxSprite(730);
    clock.loadGraphic(Paths.image('menus/freeplay/clock'));
    clock.antialiasing = true;
    add(clock);

    var volumeRectangle = new FlxSprite(0,0);
    volumeRectangle.frames = Paths.getSparrowAtlas("menus/freeplay/freeplay white vol rectangle");
    volumeRectangle.animation.addByPrefix("idle","category bar instância");
    volumeRectangle.animation.play('idle');
    volumeRectangle.antialiasing = true;
    add(volumeRectangle);

    volumeText = new FunkinText(-550, 4, FlxG.width, 'Volume 1', 46);
    volumeText.setFormat(Paths.font(globalFont), 46, FlxColor.WHITE, 'center');
    volumeText.scrollFactor.set();
    add(volumeText);

    timer = new FlxText(825, 5, FlxG.width, '0:00', 52);
	timer.color = FlxColor.WHITE;
	timer.font = Paths.font(globalFont);
	timer.alignment = 'left';
    timer.scrollFactor.set();
	add(timer);
    
    beatText = new FunkinText(1000, 5, FlxG.width, 'BPM: 333', 46);
    beatText.setFormat(Paths.font(globalFont), 56, FlxColor.WHITE, 'left');
    beatText.scrollFactor.set();
    beatText.text = 'Sigma';
    add(beatText);

    quoteText = new FunkinText(350, 630, FlxG.width, 'BPM: 333', 36);
    quoteText.setFormat(Paths.font(globalFont), 32, FlxColor.WHITE, 'center');
    quoteText.scrollFactor.set();
    quoteText.text = '"Sigma"';
    add(quoteText);

    var scrollthingbg = new FlxSprite();
    scrollthingbg.loadGraphic(Paths.image('menus/freeplay/freeplay scroll bar'));
    scrollthingbg.screenCenter(FlxAxes.X);
    scrollthingbg.x += 15;
    add(scrollthingbg);

    scrollthing = new FlxSprite();
    scrollthing.loadGraphic(Paths.image('menus/freeplay/freeplay scroll bar scroll'));
    scrollthing.x = scrollthingbg.x + 16;
    scrollthing.y = 60;
    add(scrollthing);

    changeItem();
    curindex = 0;
}

function repositionItems() {
	var spacing = 200;
	var visibleCount = 99;
	var half = Std.int(visibleCount / 2);

	for (i in 0...songs.length) {
		var stext = songTexts[i];
        var ntext = nameTexts[i];
		var bg = bgArray[i];
		var icon = iconArray[i];
        var iconbg = iconbgArray[i];
		var offset = i - curindex;

		if (Math.abs(offset) > half) {
			stext.visible = false;
			bg.visible = false;
			icon.visible = false;
			continue;
		}

		stext.visible = true;
		bg.visible = true;
		icon.visible = true;

		var isCenter = (i == curindex);
		var baseX = 175;
		var yPos = FlxG.height / 2 - 50 + offset * spacing;

		// distance-based scaling
		var scale = Math.max(1.2 - (Math.abs(offset) * 0.1), 0.1);
		var iconScale = scale - .2;
		var fontSize = Std.int(36 * scale);



		// TEXTBG
		FlxTween.tween(bg, {
			x: baseX,
			y: yPos - 10,
			alpha: isCenter ? 1 : 0.35
		}, 0.2, { ease: FlxEase.quadOut });

		FlxTween.tween(bg.scale, { x: scale, y: scale }, 0.2, { ease: FlxEase.quadOut });

		// Song TEXT
		stext.setFormat(Paths.font(globalFont), fontSize, FlxColor.BLACK, 'center');
		stext.fieldWidth = bg.width; // match text to BG size for proper alignment

		FlxTween.tween(stext.scale, { x: scale, y: scale }, 0.2, { ease: FlxEase.quadOut });
		// Name TEXT
		ntext.setFormat(Paths.font(globalFont), fontSize, FlxColor.BLACK, 'center');
		ntext.fieldWidth = bg.width; // match text to BG size for proper alignment

		FlxTween.tween(ntext.scale, { x: scale - .6, y: scale - .6}, 0.2, { ease: FlxEase.quadOut });

		// Recalculate raw text height
		var rawH = stext.textField.textHeight;
		var finalBGHeight = bg.height * scale;
		var textY = yPos + 7.5 + (finalBGHeight - rawH * scale) / 2;

		// X is just aligned with bg center
		var textX = baseX + 30;

		FlxTween.tween(stext, {
			x: textX,
			y: textY,
			alpha: isCenter ? 1 : 0.35
		}, 0.2, { ease: FlxEase.quadOut });

        FlxTween.tween(ntext, {
			x: textX,
			y: textY - 33,
			alpha: isCenter ? 1 : 0.35
		}, 0.2, { ease: FlxEase.quadOut });
		// ICON
		var iconTargetX = baseX - icon.width * iconScale - 30;
		var iconTargetY = yPos + ((60 * scale - icon.height * iconScale) / 2) + 25;

		FlxTween.tween(icon, {
			x: iconTargetX,
			y: iconTargetY,
			alpha: isCenter ? 1 : 0.4
		}, 0.2, { ease: FlxEase.quadOut });
		FlxTween.tween(icon.scale, {x: iconScale, y: iconScale}, 0.2, { ease: FlxEase.quadOut });

		FlxTween.tween(iconbg, {
			x: iconTargetX + 15,
			y: iconTargetY + 15,
			alpha: isCenter ? 1 : 0.6
		}, 0.2, { ease: FlxEase.quadOut });
		FlxTween.tween(iconbg.scale, {x: iconScale * 1.1, y: iconScale * 1.1}, 0.2, { ease: FlxEase.quadOut });

    }
}

public var timeUntilAutoplay:Float = 1;
public var disableAutoPlay:Bool = false;
public var autoplayElapsed:Float = 0;
public var songInstPlaying:Bool = true;
public var curPlayingInst:String = null;
public var autoplayShouldPlay:Bool = true;
var backOut:FlxTimer;
var backOutScale:FlxTween;

function popupPreview(songName:String) {
    if(backOut != null) {
        backOut.cancel();
    }
    if(backOutScale != null) {
        backOutScale.cancel();
    }
    songPreviewText.y = 670;
    songPreviewText.visible = true;
    songPreviewText.text = "Now playing " + songName + ' Inst';
    FlxTween.tween(songPreviewText, { x: 0, y: 670 }, 0.5, { ease: FlxEase.backOut });
    backOut = new FlxTimer().start(2.5, function(_) {
        backOutScale = FlxTween.tween(songPreviewText, { x: 700, y: 670 }, 0.5, { ease: FlxEase.backIn, onComplete: function() {
            songPreviewText.visible = false;
        }});
    });
}
function update(elapsed:Float) {


    if (FlxG.sound.music != null && FlxG.sound.music.volume < 0.7)
        {
            FlxG.sound.music.volume += 0.5 * elapsed;
        }

    var dontPlaySongThisFrame = false;
    autoplayElapsed += elapsed;
    var upP = controls.UP_P;
    var leftP = controls.LEFT_P;
    var rightP = controls.RIGHT_P;
    var downP = controls.DOWN_P;
    if (!transitioning) {
        if (upP || downP)
			changeItem((upP ? -1 : 0) + (downP ? 1 : 0));
        if (FlxG.keys.justPressed.ENTER) {
            selectSong();
        }
        if (FlxG.keys.justPressed.BACKSPACE || FlxG.keys.justPressed.ESCAPE) {
            FlxG.switchState(new MainMenuState());
        }
    }
    if(songs[curindex] != null){
        curSelected = '' + songs[curindex].name;
    } else {
        curSelected = 'grace';
    }
    if (FlxG.keys.justPressed.SPACE) {
        var songToPlay = Paths.inst(songs[curindex].name, "normal");
        FlxG.sound.music.stop();

        if(songPreviewText.text != "Now playing " + songs[curindex].displayName + ' Inst') popupPreview(songs[curindex].displayName);
        FlxG.sound.playMusic(songToPlay, 1);
        Conductor.changeBPM(songs[curindex].bpm, songs[curindex].beatsPerMeasure, songs[curindex].stepsPerBeat);
    }
}

function changeAlbum(artTuah:String = 'ph'){
    albumSprite.color = FlxColor.WHITE;
    frame.color = FlxColor.WHITE;
    if(artTuah == 'Thonk') frame.color = 0xFF4DF8;
	albumSprite.animation.play(artTuah);
    albumSprite.updateHitbox();
    albumSprite.x = frame.x - 85.1;
    albumSprite.y = frame.y - 85.1;
    
}

var scrollTween:FlxTween;

function changeItem(change:Int = 0) {
	if (transitioning) return;
    
    if(scrollTween != null) scrollTween.cancel();

	curSelected += change;
	if (curSelected < 0) curSelected = songList.weeks[curWeek].songs.length - 1;

    curindex = FlxMath.wrap(curindex + change, 0, songs.length - 1);
	FlxG.sound.play(Paths.sound('menu/scroll'), 0.7);
    changeAlbum(songs[curindex].displayName);
	repositionItems();
    if(songs[curindex].quote != null){
        quoteText.text = '"' + songs[curindex].quote + '"';
    } else {
        quoteText.text = '"' + "I'll Make you feel M@GICAL" + '"';
    }
    var song = songs[curindex];

	var saveData:SongHighscore = FunkinSave.getSongHighscore(song.name, 'normal', 0);

	var score = (saveData != null) ? saveData.score : 0;
	var acc = (saveData != null) ? Std.int(saveData.accuracy * 10000) / 100 : 0;
	var misses = (saveData != null) ? saveData.misses : 0;

    
	scoreText.text = 'HI-SCORE:'+score + ' (' + acc +'%)';
    beatText.text = 'BPM: ' + song.bpm;

	var songData = songs[curindex];
	timer.text = songLengths[curindex];
	clock.visible = timer.text.length > 0;

    scrollTween = new FlxTween();

    var scrollThingYTarg:Int = 114 * curindex + 1 + 60;

    scrollTween.tween(scrollthing, {y: scrollThingYTarg}, 0.21, {ease: FlxEase.quadOut});

}
function selectSong() {
    PlayState.loadSong(songs[curindex].name, 'normal');
    FlxG.switchState(new PlayState());
}