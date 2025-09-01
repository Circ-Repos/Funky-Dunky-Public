function onSongEnd(){
	var songName:String = PlayState.SONG.meta.name.toLowerCase();
    switch(songName)
    {
        case 'grace':
            FlxG.save.data.beatenGrace = true;
        case 'gift':
            FlxG.save.data.beatenGift = true;
        case 'scary-night':
            FlxG.save.data.beatenScaryNight = true;
        case 'think':
            FlxG.save.data.beatenThink = true;
        case 'thonk':
            FlxG.save.data.beatenThonk = true;
    }
    //please let there be a better way
    if(FlxG.save.data.beatenGrace && FlxG.save.data.beatenGift && FlxG.save.data.beatenScaryNight && FlxG.save.data.beatenThink && FlxG.save.data.beatenThonk)
    {
        FlxG.save.data.allSongsBeaten = true;
    }

}