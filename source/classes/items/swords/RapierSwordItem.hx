package classes.items.swords;

import flixel.FlxG;
import objects.particles.weapons.RapierParticle;

class RapierSwordItem extends SwordItem {
    public static final NAME:String = "rapier"; 
    
    public function new() {
        super(NAME);

        damage = 2;
        knockback = 80;
        attackParticleCallback = ()-> new RapierParticle();
    }
}