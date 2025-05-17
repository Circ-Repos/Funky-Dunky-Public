var songNameThingy:String = SONG.meta.name.toLowerCase();
var isDistraught:Bool = SONG.meta.name.toLowerCase() == "distraught";
function postUpdate() comboGroup.forEachAlive(function(spr) if (spr.camera != camHUD) spr.camera = camHUD);
function postCreate(){
    if(isDistraught) return;
    else
    comboGroup.x = 560;
	comboGroup.y = 290;
}
public var ratingScaleDiff:Float = 0.1;

function onNoteHit(event) {
    event.numScale -= ratingScaleDiff;
    event.ratingScale -= ratingScaleDiff;
}