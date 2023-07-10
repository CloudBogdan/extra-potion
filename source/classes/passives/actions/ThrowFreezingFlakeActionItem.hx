package classes.passives.actions;

import managers.Entities;
import managers.Projectiles;
import objects.entities.Entity;
import objects.projectiles.FreezingFlakeProjectile;

class ThrowFreezingFlakeActionItem extends ActionPassiveItem {
    public static final NAME:String = "throw-freezing-flake";
    
    public function new() {
        super(NAME);

        cooldownDuration = 2;
    }

    override function execute(targetEntity:Null<Entity>):Bool {
        var result = super.execute(targetEntity);
        if (!result || owner == null) return false;
        if (targetEntity == null)
            targetEntity = owner.getNearestEntities()[0];

        var freezingFlake = new FreezingFlakeProjectile(targetEntity, 1, owner);
        freezingFlake.damage = Math.floor(freezingFlake.damage * damageScale);
        freezingFlake.knockback *= knockbackScale;
        freezingFlake.stunTime *= stunTimeScale;
        freezingFlake.effectTime *= effectTimeScale;
        Projectiles.add(freezingFlake, owner.x + owner.width/2, owner.y + owner.height/2);

        return true;
    }
}