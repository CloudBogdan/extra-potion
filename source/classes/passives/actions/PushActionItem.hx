package classes.passives.actions;

import classes.effects.StunEffect;
import flixel.math.FlxMath;
import objects.entities.Entity;

class PushActionItem extends ActionPassiveItem {
    public static final NAME:String = "push";
    static final PUSH_DISTANCE:Float = 80;
    
    public function new() {
        super(NAME);

        cooldownDuration = 1.4;
    }

    override function execute(targetEntity:Null<Entity>):Bool {
        var result = super.execute(targetEntity);
        if (!result || owner == null) return false;

        var entities = owner.getNearestEntities(PUSH_DISTANCE);

        for (entity in entities) {
            var direction = entity.getCenter() - owner.getCenter();
            entity.effects.add(new StunEffect(entity, 1 * stunTimeScale));
            entity.velocity.x += FlxMath.signOf(direction.x) * Math.max(PUSH_DISTANCE - Math.abs(direction.x), 0);
            entity.velocity.y += FlxMath.signOf(direction.y) * Math.max(PUSH_DISTANCE - Math.abs(direction.y), 0);
        }
        
        return true;
    }
}