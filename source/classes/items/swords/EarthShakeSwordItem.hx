package classes.items.swords;

import flixel.FlxG;
import managers.Objects;
import managers.Particles;
import objects.entities.Entity;
import objects.particles.Particle;
import objects.particles.weapons.EarthShakeParticle;

class EarthShakeSwordItem extends SwordItem {
    public static final NAME:String = "earth-shake";
    
    public function new() {
        super(NAME);

        range = 24;
        stunTime = 1;
        damage = 4;
    }

    override function onUse() {
        super.onUse();

        if (FlxG.camera.containsPoint(Objects.player.getMidpoint())) {
            FlxG.sound.play(AssetPaths.earth_shake__wav);
            FlxG.camera.shake(.05, .03, ()->{}, true, Y);
        }
    }
    
    //
    override function spawnAttackParticle():Particle {
        var particle = new EarthShakeParticle();
        var ownerFacePos = owner.getFacePos(16);
        
        particle.flipX = owner.flipX;
        
        Particles.add(
            particle,
            ownerFacePos.x,
            owner.y + owner.height,
            true
        );

        return particle;
    }
    override function hurtEntity(entity:Entity):Bool {
        var ownerLookDir = owner.getXLookDirection();
        
        entity.y -= 1;
        entity.velocity.y -= 80;
        entity.velocity.x += ownerLookDir * 60;
        
        return super.hurtEntity(entity);
    }
}