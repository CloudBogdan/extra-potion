package classes.items.swords;

import flixel.FlxSprite;
import objects.particles.Particle;
import objects.particles.weapons.JustSwordParticle;

class JustSwordItem extends SwordItem {
    public static final NAME:String = "just-sword"; 
    
    public function new() {
        super(NAME);

        damage = 2;
        knockback = 50;
        maxCombo = 2;
        attackParticleCallback = ()-> new JustSwordParticle(this);
    }
    
    override function spawnAttackParticle():FlxSprite {
        var particle = super.spawnAttackParticle();
        particle.flipY = combo == 2;

        return particle;
    }
}