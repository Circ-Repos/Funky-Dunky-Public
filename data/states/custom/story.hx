import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import flixel.text.FlxTextBorderStyle;
import flixel.text.FlxText;
import flixel.text.FlxTextAlign;
import flixel.tweens.FlxEase;
import funkin.backend.system.framerate.Framerate;
import funkin.savedata.FunkinSave;
import openfl.text.TextFormat;


var menuPath:String = 'menus/storyMenu/'; //im lazy
var nameTexts:Array<FunkinText> = [];
var vhsArray:Array<FlxSprite> = [];

var weeks:Array<Dynamic> = [ //yo sorry it aint easy to edit
	{
		"name": "Overthrone",
		"songs": [{"name": "Grace"}],
		"id": 0
	},
		{
		"name": "Volume 1",
		"songs": [{"name": "Distraught"}, {"name": "Scary Night"}, {"name": "Think"}, {"name": "Gift"},],
		"id": 1
	}
];

var weekIndex:Int = 0;
var songText:FlxText;
var transitioning = false;

function create(){
	if(FlxG.sound.music == null) CoolUtil.playMenuSong(false); //no music? Not a problem

	FlxTween.tween(Framerate.offset, {x: FlxG.width - 200, y: 60}, 0.21, {ease: FlxEase.quadInOut});
	Framerate.debugMode = 1;
	timesNew = Paths.font('Times New Roman Italic.ttf');
	menuBG = new FlxSprite(0,0,Paths.image(menuPath + 'funkdela-story-menu-bg'));
	menuBG.scrollFactor.set();
	add(menuBG);
	
	bgOverlay = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 720, 160, true, 0xFFBBBBBB, 0xFF000000), FlxAxes.Y);
	bgOverlay.antialiasing = false; //antialiasing on here would be dumb
	bgOverlay.velocity.set(0, 200);
	bgOverlay.alpha = 0.025;
	add(bgOverlay);

	bar = new FlxSprite(0,0,Paths.image(menuPath + 'bar that separates the two halves'));
	bar.screenCenter(FlxAxes.X);
	bar.x += 70;
	add(bar);
	
	weekIndex = 0;
	songText = new FunkinText(80,350,500,"The World Is Mine\n Into The Fire\n Versus\n In Absentia ΛΟΓΟΣ",64);
	songText.font = timesNew;
	songText.alignment = FlxTextAlign.CENTER;
	songText.antialiasing = Options.antialiasing;
	songText.setBorderStyle(FlxTextBorderStyle.NONE);
	add(songText);

	tracksLabel = new FunkinText(155,-5,0,"TRACKS",96);
	tracksLabel.font = timesNew;
	tracksLabel.antialiasing = Options.antialiasing;
	tracksLabel.setBorderStyle(FlxTextBorderStyle.NONE);
	add(tracksLabel);
	
	crossLeft = new FlxSprite(tracksLabel.x - 80,tracksLabel.y + 25,Paths.image(menuPath + 'cross'));
	add(crossLeft);

	crossRight = new FlxSprite(tracksLabel.x + 375,tracksLabel.y + 25,Paths.image(menuPath + 'cross'));
	add(crossRight);

	songBorder = new FlxSprite(75,125, Paths.image(menuPath + 'track list bar'));
	add(songBorder);

	scoreText = new FunkinText(02, FlxG.height - 100, FlxG.width, "HI-SCORE: hey babygrill will you play my fnf mod?", 126);
	scoreText.setFormat(Paths.font(timesNew), 84, FlxColor.WHITE, 'left');
	scoreText.antialiasing = Options.antialiasing;
	scoreText.italic = true;
	scoreText.setBorderStyle(FlxTextBorderStyle.NONE);
	add(scoreText);
	
	for(i in weeks){
		var vhs:FlxSprite = new FlxSprite(770).loadGraphic(Paths.image(menuPath + "vhs tape"));
		vhs.scale.set(0.4, 0.4);
		vhs.updateHitbox();
		vhs.scrollFactor.set();
		vhs.antialiasing = Options.antialiasing;
		add(vhs);
		vhsArray.push(vhs);

		var nameText:FunkinText = new FunkinText(770, 0, FlxG.width, '"FRAUD // FIRST \nHURTBREAK WONDERLAND"', 26);
		nameText.alignment = 'center';
		nameText.text = '"' + i.name.toUpperCase() + '"';

		nameText.font = Paths.font(timesNew);
		nameText.setBorderStyle(FlxTextBorderStyle.NONE);
		nameText.scrollFactor.set();
		nameText.antialiasing = Options.antialiasing;
		nameText.color = FlxColor.BLACK;
		nameText.italic = true;
		if(!FlxG.save.data.songsBeaten.contains("Grace") && i.name.toUpperCase() == 'VOLUME 1') nameText.text = '"???"';
		nameTexts.push(nameText);
		add(nameText);
	}

	chooseLabel = new FunkinText(760,5,0,"CHOOSE YOUR DEMISE",44); //YOUR DEMISE? LIKE THE DDTO SONG? 
	chooseLabel.font = timesNew;
	chooseLabel.setBorderStyle(FlxTextBorderStyle.NONE);
	chooseLabel.antialiasing = Options.antialiasing;
	chooseLabel.italic = true;
	chooseLabel.underline = true;
	add(chooseLabel);

	updatesongText();

}
function update(elapsed:Float) {
	if(Framerate.debugMode == 2) Framerate.debugMode = 0;
	if(!transitioning){
		if(controls.BACK)
		{
			transitioning = true;
			CoolUtil.playMenuSFX(2, 0.7);
			new FlxTimer().start(0.6, (_) -> FlxG.switchState(new MainMenuState()));
		}
		if(controls.DOWN_P){
			weekIndex = FlxMath.wrap(weekIndex + 1, 0, weeks.length -1);

			updatesongText();
		}
		if(controls.UP_P){
			weekIndex = FlxMath.wrap(weekIndex - 1, 0, weeks.length -1);
			updatesongText();
		}
		if(controls.ACCEPT){

			if(!FlxG.save.data.songsBeaten.contains("Grace") && weekIndex == 1){
				CoolUtil.playMenuSFX(2, 0.7);
			}
			else{
				PlayState.loadWeek(weeks[weekIndex]);
				FlxG.switchState(new PlayState());
				transitioning = true;
			}
		}
	}
}
var displaySongs:Array<String> = [];

function updatesongText() {
    displaySongs =[];

    var displayedWeekList = weeks[weekIndex];
    for (song in displayedWeekList.songs) {
        displaySongs.push(song.name);
    }
    songText.text = displaySongs.join("\n");
	if(weekIndex == 1 && !FlxG.save.data.songsBeaten.contains("Grace")) songText.text = "???\n???\n???\n???";
	songText.updateHitbox();
	songText.y = 250;
	if(weekIndex == 0) songText.y = 350;
	var highScorebutScuffed:Int = 0;

	for(i in weeks[weekIndex].songs){
		var saveData:SongHighscore = FunkinSave.getSongHighscore(i.name, 'normal');		
		highScorebutScuffed += saveData.score;

	}
	scoreText.text = 'HI-SCORE:' + highScorebutScuffed;

	for(i in 0...weeks.length)
	{
		var isCenter = (i == weekIndex);

		var baseX = 770;
		var stext = nameTexts[i];
		var bg = vhsArray[i];
		var offset = i - weekIndex;
		var spacing:Float = 200;
		var yPos = FlxG.height / 2 - 200 + offset * spacing;
		
		var baseTX = 440;
		
		var tyPos = (FlxG.height / 2 - 200 + offset * spacing) + 90;
		FlxTween.tween(bg, {
			x: baseX,
			y: yPos - 10,
			alpha: isCenter ? 1 : 0.35,
		}, 0.2, { ease: FlxEase.quadOut });
		FlxTween.tween(bg.scale, {
			x: isCenter ? 0.4 : 0.2,
			y: isCenter ? 0.4 : 0.2
		}, 0.2, { ease: FlxEase.quadOut });

		FlxTween.tween(stext, {
			x: baseTX - 70,
			y: yPos + 110,
			alpha: isCenter ? 1 : 0.35,
		}, 0.2, { ease: FlxEase.quadOut });
		FlxTween.tween(stext.scale, {
			x: isCenter ? 1 : 0.5,
			y: isCenter ? 1 : 0.5
		}, 0.2, { ease: FlxEase.quadOut });
	}
}