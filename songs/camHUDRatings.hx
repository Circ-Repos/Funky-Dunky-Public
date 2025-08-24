public var ratingScaleDiff:Float = 0.1;

function displayCombo(_){
	_.displayCombo = false;
}

/*																		Use Later - fiffi
function postCreate()
{
	if(SONG.meta.name.toLowerCase() == "distraught") return;
	else
	{
		comboGroup.x = 560;
		comboGroup.y = 290;
	}
}

function postUpdate()
{
	comboGroup.forEachAlive(function(spr) {
		if(spr.camera != camHUD) spr.camera = camHUD;
	});
}

function onNoteHit(event)
{
	event.numScale -= ratingScaleDiff;
	event.ratingScale -= ratingScaleDiff;
}
*/