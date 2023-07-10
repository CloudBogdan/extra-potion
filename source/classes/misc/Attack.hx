package classes.misc;

import flixel.math.FlxPoint;
import objects.entities.Entity;

class Attack {
    public var fromEntity:Null<Entity>;
    public var damage:Int;

    public var fromPoint:Null<FlxPoint> = null;
    public var knockback:Float = 0;
    public var stunTime:Float = 0;
    
    public function new(FromEntity:Null<Entity>, Damage:Int, Knockback:Float=0) {
        fromEntity = FromEntity;
        damage = Damage;
        knockback = Knockback;
    }

    public function applyKnockback(entity:Entity, yKnockback:Bool=false, multiplier:Float=1) {
        if (knockback == 0) return;

        var velX:Float = knockback * multiplier;
        var velY:Float = 0;

        if (yKnockback)
            velY = knockback/2 * multiplier;

        entity.applyKnockback(velX, velY, fromPoint);
    }
}