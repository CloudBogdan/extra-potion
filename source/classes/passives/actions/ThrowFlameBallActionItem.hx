package classes.passives.actions;

import flixel.FlxG;
import managers.Projectiles;
import objects.entities.Entity;
import objects.projectiles.FlameBallProjectile;

class ThrowFlameBallActionItem extends ActionPassiveItem {
    public static final NAME:String = "throw-flame-ball";
    
    public function new() {
        super(NAME);

        cooldownDuration = 3;
    }

    override function execute(targetEntity:Null<Entity>):Bool {
        var result = super.execute(targetEntity);
        if (!result || owner == null) return false;
        if (targetEntity == null)
            targetEntity = owner.getNearestEntities()[0];

        var flameBall = new FlameBallProjectile(targetEntity, 2, owner);
        flameBall.damage = Math.floor(flameBall.damage * damageScale);
        flameBall.knockback *= knockbackScale;
        flameBall.stunTime *= stunTimeScale;
        flameBall.effectTime *= effectTimeScale;
        
        Projectiles.add(
            flameBall,
            owner.x + owner.width/2 + FlxG.random.int(-16, 16),
            owner.y + owner.height/2 + FlxG.random.int(-16, 16)
        );

        return true;
    }
}