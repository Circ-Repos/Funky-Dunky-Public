import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileCircle;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileSquare;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;

function create() {
    FlxTransitionableState.defaultTransIn = new TransitionData();
    FlxTransitionableState.defaultTransOut = new TransitionData();

    var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
    diamond.persist = true;
    diamond.destroyOnNoUse = false;
    
    FlxTransitionableState.defaultTransIn.tileData = {asset: diamond, width: 32, height: 32};
    FlxTransitionableState.defaultTransOut.tileData = {asset: diamond, width: 32, height: 32};
    
    // Of course, this state has already been constructed, so we need to set a transOut value for it right now:
    transOut = FlxTransitionableState.defaultTransOut;
    transIn = FlxTransitionableState.defaultTransOut;

}