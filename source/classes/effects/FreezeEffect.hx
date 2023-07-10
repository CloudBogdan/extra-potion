package classes.effects;

import classes.components.entities.ModifiersComponent.EntityModifier;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import managers.Game;
import objects.entities.Entity;

class FreezeEffect extends Effect {
    public static final NAME:String = "freeze";

    var freezeSprite:FlxSprite;
    
    public function new(Entity:Entity, Duration:Float) {
        super(NAME, Entity, Duration);

        freezeSprite = new FlxSprite();
        freezeSprite.loadGraphic(AssetPaths.freezed__png, false, 16, 16);
        freezeSprite.offset.set(8, 8);
        freezeSprite.pixelPerfectPosition = true;
    }
    
    override function draw() {
        super.draw();

        if (timer.timeLeft < 1 && Game.time % 2 == 0)
            freezeSprite.offset.set(FlxG.random.int(-1, 1) + 8, 8);

        var entityCenter = entity.getCenter();
        
        freezeSprite.setPosition(entityCenter.x, entityCenter.y);
        freezeSprite.draw();
    }
    
    //
    override function onApplied(entity:Entity) {
        super.onApplied(entity);

        entity.playAnimation(EntityAnim.IDLE, true);
        entity.modifiers.add("freeze-effect-do-nothing", new EntityModifier(IS_DO_NOTHING, 1));
    }
    override function clear() {
        super.clear();

        entity.modifiers.remove("freeze-effect-do-nothing");
    }
}