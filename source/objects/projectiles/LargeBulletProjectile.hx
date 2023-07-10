package objects.projectiles;

import flixel.FlxG;
import flixel.util.FlxDirection;
import managers.Particles;
import objects.entities.Entity;
import objects.particles.StarParticle;
import utils.Palette;

class LargeBulletProjectile extends BulletProjectile {
    public static final NAME:String = "large-bullet";
    
    public function new(Direction:FlxDirection, Damage:Int=1, Owner:Entity) {
        super(NAME, Direction, Damage, Owner);

        setSize(4, 3);
        offset.set(2, 3);
    }

    override function explode() {
        super.explode();

        Particles.addMultiple(
            ()-> new StarParticle(Palette.ORANGE_3),
            ()-> x+width/2, ()-> y+height/2,
            ()-> FlxG.random.float(-60, 60),
            ()-> FlxG.random.float(-60, 60),
            3
        );
    }
}