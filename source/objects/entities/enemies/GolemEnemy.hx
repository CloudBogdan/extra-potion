package objects.entities.enemies;

import classes.items.swords.EarthShakeSwordItem;
import flixel.FlxG;
import objects.entities.Entity.EntityAnim;
import utils.Palette;

class GolemEnemy extends MeleeEntity {
    public static final NAME:String = "golem";
    
    public function new() {
        maxHealth = 14;
        
        super(NAME);

        weaponSlot.equip(new EarthShakeSwordItem());

        addAnimation(EntityAnim.IDLE, { row: 0, frames: [0] });
        addAnimation(EntityAnim.WALK, { row: 1, frames: [0,1,2,3], frameRate: 3 });
        addAnimation(EntityAnim.DRIFT, { row: 2, frames: [0] });
        addAnimation(EntityAnim.DEAD, { row: 4, frames: [0,1,2], frameRate: 2, looped: false });

        addAnimation(EntityAnim.ATTACK, {
            row: 3, frameRate: 8, looped: false,
            frames: [0,1,1,2,2,3,3,3,4],
            flags:  [0,0,0,0,0,1]
        });
        
        moveSpeed = 8;
        setSize(6, 12);
        offset.set(13, 20);
        bloodColor = Palette.CYAN_3;
        enemiesNames = [Player.NAME];
        knockbackAfterDeath = false;
        corpseDarkness = .4;
        attackRange = 22;
        opiate.level = FlxG.random.int(1, 3);
    }

    override function load() {
        loadSprite('assets/images/entities/$name.png', 5, 32, 32);
    }

    //
    override function onAnimFlagReached(name:String, flag:Dynamic) {
        super.onAnimFlagReached(name, flag);

        if (name == ATTACK) {
            if (flag == 1) {
                weaponSlot.use();
            }
        }
    }
}