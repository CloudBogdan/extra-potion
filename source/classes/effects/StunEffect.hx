package classes.effects;

import classes.components.entities.ModifiersComponent.EntityModifier;
import flixel.FlxSprite;
import objects.entities.Entity;

class StunEffect extends Effect {
    public static final NAME:String = "stun";
    
    final starsSprite:FlxSprite;
    
    public function new(Entity:Entity, Duration:Float) {
        super(NAME, Entity, Duration);

        controlsAnimations = true;
        
        starsSprite = new FlxSprite();
        starsSprite.loadGraphic(AssetPaths.stun__png, true, 8, 8);
        starsSprite.pixelPerfectPosition = true;
        starsSprite.offset.set(4, 4);
        starsSprite.animation.add("default", [0,1,2,3], 10, true);
        starsSprite.animation.play("default");
    }

    override function update(elapsed:Float) {
        allowDry = entity.isOnGround;
        
        super.update(elapsed);

        starsSprite.update(elapsed);
    }
    override function draw() {
        super.draw();

        starsSprite.setPosition(entity.x + entity.width/2, entity.y - 4);
        starsSprite.draw();
    }
    
    // On
    override function onApplied(entity:Entity) {
        super.onApplied(entity);

        var exists = entity.playAnimation(EntityAnim.STUNNED, true);
        if (!exists) {
            entity.playAnimation(EntityAnim.IDLE, true);
        }

        entity.weakPhysics();
        entity.modifiers.add("stun-effect", new EntityModifier(IS_DO_NOTHING, 1));
    }
    override function clear() {
        super.clear();
        
        entity.modifiers.remove("stun-effect");
        entity.resetPhysics();
    }
}