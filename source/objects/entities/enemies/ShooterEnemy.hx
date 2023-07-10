package objects.entities.enemies;

import classes.items.guns.WeakGunItem;
import flixel.FlxG;
import flixel.util.FlxDirection;
import managers.Projectiles;
import objects.entities.Entity.EntityAnim;
import objects.projectiles.LargeBulletProjectile;

class ShooterEnemy extends RangeEntity {
    public static final NAME:String = "shooter";
    
    public function new() {
        maxHealth = 8;
        
        super(NAME);

        weaponSlot.equip(new WeakGunItem());

        addAnimation(EntityAnim.IDLE, { row: 0, frames: [0] });
		addAnimation(EntityAnim.WALK, { row: 1, frames: [0,1,2,3] });
		addAnimation(EntityAnim.DRIFT, { row: 2, frames: [0] });
		addAnimation(EntityAnim.JUMP, { row: 3, frames: [0,1,2], looped: false });
		addAnimation(EntityAnim.FALL, { row: 3, frames: [2] });
		addAnimation(EntityAnim.DEAD, { row: 5, frames: [0,1,2], frameRate: 6, looped: false });

		addAnimation(EntityAnim.ATTACK, {
			row: 4, frameRate: 12, looped: false,
			frames: [0,0,1,1,0,0,1,2,2,3,4],
			flags:  [0,0,0,0,0,0,0,1],
		});
        
        setSize(4, 7);
		offset.set(2, 1);
		opiate.level = FlxG.random.int(0, 2);
        enemiesNames = [Player.NAME];
    }

    // On
    override function onAnimFlagReached(name:String, flag:Dynamic) {
        super.onAnimFlagReached(name, flag);

        if (name == ATTACK) {
            if (flag == 1) {
                weaponSlot.use();
            }
        }
    }
}