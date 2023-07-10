package classes.items;

import flixel.FlxG;
import flixel.math.FlxPoint;
import managers.Projectiles;
import objects.projectiles.LargeBulletProjectile;
import objects.projectiles.Projectile;

class GunItem extends WeaponItem {
    public var projectileCallback:GameObjectCallback<Projectile>;
    
    public function new(Name:String) {
        super(Name);

        projectileCallback = ()-> new LargeBulletProjectile(owner.flipX ? LEFT : RIGHT, 1, owner);
    }
    
    override function onUse() {
        super.onUse();

        shoot();

        FlxG.sound.play(AssetPaths.shoot__wav);
    }

    function shoot() {
        var projectile = projectileCallback();
        var pos = getShootPoint();

        projectile.owner = owner;
        projectile.damage = getDamage();
        projectile.knockback = getKnockback();
        projectile.stunTime = getStunTime();
        projectile.hurtEntitiesNames = owner.enemiesNames;

        Projectiles.add(projectile, pos.x, pos.y);
    }

    // Get
    public function getShootPoint():FlxPoint {
        return owner.getFacePos();
    }
}