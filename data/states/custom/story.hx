import funkin.menus.MainMenuState;

function create()
{
	FlxG.mouse.visible = false;
	if(FlxG.sound.music == null) CoolUtil.playMenuSong(false);
}

function update(elapsed:Float)
{
	FlxG.switchState(new MainMenuState());
}