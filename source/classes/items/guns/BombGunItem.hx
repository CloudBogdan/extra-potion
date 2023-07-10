package classes.items.guns;

import flixel.math.FlxPoint;
import objects.projectiles.BombProjectile;

class BombGunItem extends GunItem {
    public static final NAME:String = "bomb-gun";
    
    public function new() {
        super(NAME);

        knockback = 80;
        recoil = 40;
        stunTime = 1;
        damage = 3;

        projectileCallback = ()-> new BombProjectile(owner.getXLookDirection(), getDamage(), owner);
    }

    override function getShootPoint():FlxPoint {
        return new FlxPoint(owner.x+owner.width/2, owner.y - 4);
    }
}