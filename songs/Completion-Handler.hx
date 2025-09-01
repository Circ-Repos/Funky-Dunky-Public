var songName:String = PlayState.SONG.meta.name.toLowerCase();

function onSongEnd(){
    if(FlxG.save.data.songsBeaten == null) FlxG.save.data.songsBeaten = [];
    if(FlxG.save.data.songsBeaten.contains(songName) == false) FlxG.save.data.songsBeaten.push(songName);
    if(songName == 'grace') FlxG.save.data.weeksBeaten.push('overthrone');
    if(songName == 'gift') FlxG.save.data.weeksBeaten.push('volume 1');

    //please let there be a better way
    if(FlxG.save.data.songsBeaten.contains('grace') && FlxG.save.data.songsBeaten.contains('gift') && FlxG.save.data.songsBeaten.contains('scary-night') && FlxG.save.data.songsBeaten.contains('think') && FlxG.save.data.songsBeaten.contains('thonk'))
    {
        FlxG.save.data.allSongsBeaten = true;
    }

}