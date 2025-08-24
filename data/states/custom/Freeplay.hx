import funkin.backend.system.framerate.Framerate;
import funkin.menus.FreeplayState.FreeplaySonglist;
import funkin.savedata.FunkinSave;
import flixel.FlxObject;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import flixel.text.FlxTextBorderStyle;
import flixel.tweens.FlxEase;

var curWeek:Int = 0;
var transitioning = false;
var songs = FreeplaySonglist.get(true).songs;

var globalFont:String = 'Times New Roman Italic.ttf';

var nameTexts:Array<FunkinText> = [];
var songTexts:Array<FunkinText> = [];

var vhsArray:Array<FlxSprite> = [];
var iconBgArray:Array<FlxSprite> = [];
var iconArray:Array<HealthIcon> = [];

var scoreText:FunkinText;
var beatText:FunkinText;
var quoteText:FunkinText;
var frame:FlxSprite;
var albumSprite:FlxSprite;
var uniqueVolumeSongs:Array<String> = ['Grace', 'Thonk'];
// doing it like this frees ram from caching Inst's
var songLengths:Array<String> = [
	'04:30', //Grace
	'03:15', //Distraught
	'04:40', //Scary Night
	'02:35', //Think
	'03:15', //Gift
	'02:40'  //Thonk
];

var songPreviewText:FunkinText;
var volumeText:FunkinText;
var timerText:FunkinText;
var scrollBar:FlxSprite;

function create()
{
	FlxG.mouse.visible = false; //no mouse controls, no mouse

	songList = Json.parse(Assets.getText(Paths.json('../data/songs'))); //why did i make it like this

	FlxTween.tween(Framerate.offset, {y: 70}, 0.74, {ease: FlxEase.quadInOut});
	if(FlxG.sound.music == null) CoolUtil.playMenuSong(false); //no music? Not a problem

	var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/freeplay/bg'));
	bg.scrollFactor.set();
	bg.antialiasing = Options.antialiasing;
	add(bg);

	var bgOverlay:FlxBackdrop = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0xFFBBBBBB, 0xFF000000));
	bgOverlay.antialiasing = false; //antialiasing on here would be dumb
	bgOverlay.velocity.set(0, 200);
	bgOverlay.alpha = 0.1;
	add(bgOverlay);

	for(i => song in songs)
	{
		var beatenShit:Bool = false;
		if(FlxG.save.data.beatenGrace && FlxG.save.data.beatenDistraught && FlxG.save.data.beatenScaryNight && FlxG.save.data.beatenThink && FlxG.save.data.beatenGift && FlxG.save.data.beatenThonk)
			FlxG.save.data.beatenAll = true;

		if(!FlxG.save.data.beatenAll)
		{
			switch(song.displayName) //Im Sorry this is the only way i could i think
			{
				case 'Grace': beatenShit = FlxG.save.data.beatenGrace;
				case 'Scary Night': beatenShit = FlxG.save.data.beatenScaryNight;
				case 'Think': beatenShit = FlxG.save.data.beatenThink;
				case 'Distraught': beatenShit = FlxG.save.data.beatenDistraught;
				case 'Gift': beatenShit = FlxG.save.data.beatenGift;
			}
		}
		else beatenShit = true;

		var vhs:FlxSprite = new FlxSprite().loadGraphic(Paths.image("menus/freeplay/vhs"));
		vhs.updateHitbox();
		if(song.displayName == 'Thonk') vhs.color = 0xFF4DF8; //Why Are You Pink?
		vhs.scrollFactor.set();
		vhs.antialiasing = Options.antialiasing;
		add(vhs);
		vhsArray.push(vhs);

		var vhsName:String = '???';
		if(beatenShit || FlxG.save.data.songsBeaten.contains(song.displayName) || song.displayName == 'Thonk')
		{
			switch(song.icon.toUpperCase())
			{
				case 'GABRIEL-FALSE' | 'GABRIEL-TRUE': vhsName = 'GABRIEL';
				case 'SIX_DT_ICONS' | 'INTRUDER': vhsName = 'INTRUDER';
				case 'LIL-CEASERS' | 'CEASER-GIFT': vhsName = 'CESAR';
				case 'MARK-NORMAL': vhsName = 'MARK';
				default: vhsName = song.icon;
			}
		}

		var nameText:FunkinText = new FunkinText(0, 0, FlxG.width, vhsName.toUpperCase(), 32);
		nameText.alignment = 'center';
		nameText.font = Paths.font(globalFont);
		nameText.scrollFactor.set();
		nameText.antialiasing = Options.antialiasing;
		nameText.color = FlxColor.BLACK;
		nameTexts.push(nameText);
		add(nameText);

		var songName:String = '"???"';
		if(beatenShit || FlxG.save.data.songsBeaten.contains(song.displayName) || song.displayName == 'Thonk')
			songName = '"' + song.displayName.toUpperCase() + '"';

		var songText:FunkinText = new FunkinText(0, 0, FlxG.width, songName, 12);
		songText.alignment = 'center';
		songText.font = Paths.font(globalFont);
		songText.scrollFactor.set();
		songText.antialiasing = Options.antialiasing;
		songTexts.push(songText);
		add(songText);

		var iconBg = new FlxSprite();
		iconBg.frames = Paths.getSparrowAtlas('menus/freeplay/icon_bg');
		iconBg.animation.addByPrefix('idle', 'idle', 24, true);
		iconBg.animation.play('idle');
		iconBg.scrollFactor.set();
		if(song.displayName == 'Thonk') iconBg.color = 0xFF4DF8;
		iconBg.antialiasing = Options.antialiasing;
		iconBgArray.push(iconBg);
		add(iconBg);

		var iconName:String = 'locked';
		if(beatenShit || FlxG.save.data.songsBeaten.contains(song.displayName) || song.displayName == 'Thonk')
			iconName = song.icon;

		var icon:HealthIcon = new HealthIcon(iconName != null ? song.icon : Flags.DEFAULT_HEALTH_ICON, true);
		icon.scrollFactor.set();
		icon.antialiasing = Options.antialiasing;
		icon.flipX = true;
		iconArray.push(icon);
		add(icon);
	}

	frame = new FlxSprite().loadGraphic(Paths.image('menus/freeplay/frame'));
	frame.screenCenter(FlxAxes.Y);
	frame.y -= 60;
	frame.x = FlxG.width - 470;
	frame.scale.set(1.05, 1.05);
	frame.antialiasing = false;
	add(frame);

	albumSprite = new FlxSprite(frame.x + 5, frame.x + 5);
	albumSprite.frames = Paths.getSparrowAtlas("menus/freeplay/Freeplay-Portraits");
	albumSprite.animation.addByPrefix("Gift", "Gift");
	albumSprite.animation.addByPrefix("Grace", "Grace");
	albumSprite.animation.addByPrefix("Scary Night", "Scary Night");
	albumSprite.animation.addByPrefix("Think", "ThinkFP");
	albumSprite.animation.addByPrefix("Thonk", "thonk");
	albumSprite.animation.addByPrefix("Distraught", "Distraught");
	albumSprite.scale.set(0.4, 0.4);
	albumSprite.antialiasing = Options.antialiasing;
	add(albumSprite);

	scoreText = new FunkinText(FlxG.width - 80, FlxG.height - 200, FlxG.width, "", 64);
	scoreText.setFormat(Paths.font(globalFont), 46, FlxColor.WHITE, 'left');
	scoreText.antialiasing = Options.antialiasing;
	add(scoreText);
	scoreText.x -= 329;

	songPreviewText = new FunkinText(900, 650, FlxG.width, "Now Previewing " + songs[curSelectedFreeplay].name, 24);
	songPreviewText.setFormat(Paths.font(globalFont), 32, FlxColor.WHITE, 'right');
	songPreviewText.antialiasing = Options.antialiasing;
	songPreviewText.scrollFactor.set();
	songPreviewText.visible = false;
	add(songPreviewText);

	var hintText:FunkinText = new FunkinText(70, FlxG.height - 48, FlxG.width, 'Press SPACE to preview the song', 46);
	hintText.setFormat(Paths.font(globalFont), 32, FlxColor.WHITE, 'left');
	hintText.scrollFactor.set();
	hintText.antialiasing = Options.antialiasing;
	add(hintText);

	var divider:FlxSprite = new FlxSprite().makeGraphic(15, FlxG.height, FlxColor.WHITE);
	divider.screenCenter(FlxAxes.X);
	divider.x += 55;
	divider.antialiasing = false;
	add(divider);

	clock = new FlxSprite(730, 0);
	clock.loadGraphic(Paths.image('menus/freeplay/clock'));
	clock.antialiasing = Options.antialiasing;
	add(clock);

	var volumeRectangle:FlxSprite = new FlxSprite();
	volumeRectangle.frames = Paths.getSparrowAtlas("menus/freeplay/volume_bg");
	volumeRectangle.animation.addByPrefix("idle", "idle", 24, true);
	volumeRectangle.animation.play('idle');
	volumeRectangle.antialiasing = Options.antialiasing;
	add(volumeRectangle);

	volumeText = new FunkinText(-550, 4, FlxG.width, 'Volume 1', 46);
	volumeText.setFormat(Paths.font(globalFont), 46, FlxColor.WHITE, 'center');
	volumeText.scrollFactor.set();
	volumeText.antialiasing = Options.antialiasing;
	add(volumeText);

	timerText = new FlxText(825, 5, FlxG.width, '0:00', 52);
	timerText.color = FlxColor.WHITE;
	timerText.font = Paths.font(globalFont);
	timerText.alignment = 'left';
	timerText.scrollFactor.set();
	timerText.antialiasing = Options.antialiasing;
	add(timerText);

	beatText = new FunkinText(1000, 5, FlxG.width, 'BPM: 333', 46);
	beatText.setFormat(Paths.font(globalFont), 56, FlxColor.WHITE, 'left');
	beatText.scrollFactor.set();
	beatText.antialiasing = Options.antialiasing;
	add(beatText);

	quoteText = new FunkinText(350, 630, FlxG.width, '"Sigma"', 36);
	quoteText.setFormat(Paths.font(globalFont), 32, FlxColor.WHITE, 'center');
	quoteText.scrollFactor.set();
	quoteText.antialiasing = Options.antialiasing;
	add(quoteText);

	var scrollBarBG = new FlxSprite();
	scrollBarBG.loadGraphic(Paths.image('menus/freeplay/scroll_bg'));
	scrollBarBG.screenCenter(FlxAxes.X);
	scrollBarBG.x += 16;
	scrollBarBG.antialiasing = Options.antialiasing;
	add(scrollBarBG);

	scrollBar = new FlxSprite().makeGraphic(24, 142, FlxColor.BLACK);
	scrollBar.x = scrollBarBG.x + 14;
	scrollBar.y = 60;
	scrollBar.antialiasing = false;
	add(scrollBar);

	changeItem();
}

var backOut:FlxTimer;
var backOutScale:FlxTween;
function popupPreview(songName:String)
{
	if(backOut != null) backOut.cancel();
	if(backOutScale != null) backOutScale.cancel();

	songPreviewText.y = 670;
	songPreviewText.visible = true;
	songPreviewText.text = "Now playing " + songName + ' Inst';
	FlxTween.tween(songPreviewText, { x: 0, y: 670 }, 0.5, { ease: FlxEase.backOut });
	backOut = new FlxTimer().start(2.5, function(_) {
		backOutScale = FlxTween.tween(songPreviewText, { x: 700, y: 670 }, 0.5, {
			ease: FlxEase.backIn,
			onComplete: function() {
				songPreviewText.visible = false;
			}
		});
	});
}

var curSongPlaying:Int = -1;
function update(elapsed:Float)
{
	if(transitioning) return;

	if(controls.DOWN_P || FlxG.mouse.wheel < 0) changeItem(1);
	if(controls.UP_P || FlxG.mouse.wheel > 0) changeItem(-1);

	if(FlxG.keys.justPressed.ENTER) selectSong();
	if(controls.BACK)
	{
		transitioning = true;
		CoolUtil.playMenuSFX(2, 0.7);
		new FlxTimer().start(0.6, (_) -> FlxG.switchState(new MainMenuState()));
	}

	if(FlxG.keys.justPressed.SPACE)
	{
		if(curSongPlaying == curSelectedFreeplay)
		{
			curSongPlaying = -1;
			FlxG.sound.music.stop();
			CoolUtil.playMenuSong(true);
		}
		else
		{
			curSongPlaying = curSelectedFreeplay;
			if(songPreviewText.text != "Now playing " + songs[curSelectedFreeplay].displayName + ' Inst') popupPreview(songs[curSelectedFreeplay].displayName);
			FlxG.sound.playMusic(Paths.inst(songs[curSelectedFreeplay].name, "normal"), 1);
			Conductor.changeBPM(songs[curSelectedFreeplay].bpm, songs[curSelectedFreeplay].beatsPerMeasure, songs[curSelectedFreeplay].stepsPerBeat);
		}
	}
}

function changeAlbum(artTuah:String = 'ph')
{
	albumSprite.color = FlxColor.WHITE;
	frame.color = FlxColor.WHITE;
	if(artTuah == 'Thonk') frame.color = 0xFF4DF8;
	albumSprite.animation.play(artTuah);
	albumSprite.updateHitbox();
	albumSprite.setPosition(frame.x - 85.1, frame.y - 85.1);
}

var scrollTween:FlxTween;
function changeItem(change:Int = 0)
{
	if(scrollTween != null) scrollTween.cancel();

	if(change != 0) CoolUtil.playMenuSFX(0, 0.7);
	curSelectedFreeplay = FlxMath.wrap(curSelectedFreeplay + change, 0, songs.length - 1);

	changeAlbum(songs[curSelectedFreeplay].displayName);
	repositionItems();

	if(songs[curSelectedFreeplay].quote != null)
		quoteText.text = '"' + songs[curSelectedFreeplay].quote + '"';
	else
		quoteText.text = '"' + "I'll Make you feel M@GICAL" + '"';

	var saveData:SongHighscore = FunkinSave.getSongHighscore(songs[curSelectedFreeplay].name, 'normal');

	var score = (saveData != null) ? saveData.score : 0;
	var acc = (saveData != null) ? Std.int(saveData.accuracy * 10000) / 100 : 0;
	var misses = (saveData != null) ? saveData.misses : 0;

	scoreText.text = 'HI-SCORE:' + score + ' (' + acc + '%)';
	beatText.text = 'BPM: ' + songs[curSelectedFreeplay].bpm;

	timerText.text = songLengths[curSelectedFreeplay];
	clock.visible = timerText.text.length > 0;

	var scrollBarYTarg:Float = 91.5 * curSelectedFreeplay + 1 + 60;
	if(scrollTween == null) scrollTween = new FlxTween();
	scrollTween.tween(scrollBar, {y: scrollBarYTarg}, 0.21, {ease: FlxEase.quadOut});

	if(uniqueVolumeSongs.indexOf(songs[curSelectedFreeplay].displayName) != -1){
		switch(songs[curSelectedFreeplay].displayName){
			case 'Grace':
				volumeText.text = "Overthrone";
			case 'Thonk':
				volumeText.text = "Scrimblo";
		}
	}
	else{
		volumeText.text = "Volume 1";
	}
}

function repositionItems()
{
	var spacing:Float = 200;
	var visibleCount:Int = 99;
	var half:Int = Std.int(visibleCount / 2);

	for(i in 0...songs.length)
	{
		var stext = songTexts[i];
		var ntext = nameTexts[i];
		var bg = vhsArray[i];
		var icon = iconArray[i];
		var iconBg = iconBgArray[i];
		var offset = i - curSelectedFreeplay;

		if(Math.abs(offset) > half)
		{
			stext.visible = false;
			bg.visible = false;
			icon.visible = false;
			continue;
		}

		stext.visible = true;
		bg.visible = true;
		icon.visible = true;

		var isCenter = (i == curSelectedFreeplay);
		var isFar = (i <= curSelectedFreeplay - 2 || i >= curSelectedFreeplay + 2);
		var baseX = 175;
		var yPos = FlxG.height / 2 - 50 + offset * spacing;

		// distance-based scaling
		var scale:Float = Math.max(1.2 - (Math.abs(offset) * 0.1), 0.1);
		var iconScale:Float = scale - 0.2;
		var fontSize:Int = Std.int(36 * scale);

		// TEXTBG
		FlxTween.tween(bg, {
			x: baseX,
			y: yPos - 10,
			alpha: isCenter ? 1 : (isFar ? 0.15 : 0.35)
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
		var finalBGHeight:Float = bg.height * scale;
		var textY:Float = yPos + 7.5 + (finalBGHeight - rawH * scale) / 2;

		// X is just aligned with bg center
		var textX:Float = baseX + 30;

		FlxTween.tween(stext, {
			x: textX,
			y: textY,
			alpha: isCenter ? 1 : (isFar ? 0.15 : 0.35)
		}, 0.2, { ease: FlxEase.quadOut });

		FlxTween.tween(ntext, {
			x: textX,
			y: textY - 33,
			alpha: isCenter ? 1 : (isFar ? 0.15 : 0.35)
		}, 0.2, { ease: FlxEase.quadOut });

		// ICON
		var iconTargetX:Float = baseX - icon.width * iconScale - 30;
		var iconTargetY:Float = yPos + ((60 * scale - icon.height * iconScale) / 2) + 25;

		FlxTween.tween(icon, {
			x: iconTargetX,
			y: iconTargetY,
			alpha: isCenter ? 1 : (isFar ? 0.2 : 0.4)
		}, 0.2, { ease: FlxEase.quadOut });
		FlxTween.tween(icon.scale, {x: iconScale, y: iconScale}, 0.2, { ease: FlxEase.quadOut });

		FlxTween.tween(iconBg, {
			x: iconTargetX + 15,
			y: iconTargetY + 15,
			alpha: isCenter ? 1 : (isFar ? 0.4 : 0.6)
		}, 0.2, { ease: FlxEase.quadOut });
		FlxTween.tween(iconBg.scale, {x: iconScale * 1.1, y: iconScale * 1.1}, 0.2, { ease: FlxEase.quadOut });
	}
}

function selectSong()
{
	transitioning = true;
	PlayState.loadSong(songs[curSelectedFreeplay].name, 'normal');
	FlxG.switchState(new PlayState());
}

function destroy()
{
	Framerate.offset.y = 0; //sadly tweens cant happen
}