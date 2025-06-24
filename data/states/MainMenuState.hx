import funkin.backend.utils.CoolUtil;

function create(){
    if(FlxG.sound.music == null) CoolUtil.playMusic(Paths.music("freakyMenu"), 1);
    else{
        FlxG.sound.music.stop();
        CoolUtil.playMusic(Paths.music("freakyMenu"), 1);
    }
}
function update(){
    if(FlxG.keys.justPressed.J) FlxG.switchState(new ModState('custom/options/Options'));
}