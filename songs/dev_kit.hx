function create()
{
	importScript("data/scripts/botplay");
	if(FlxG.save.data.DevMode)
		importScript("data/scripts/dev_tools/debug_tools");
}