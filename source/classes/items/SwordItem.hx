package classes.items;

import classes.events.Trigger;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxRect;
import flixel.util.FlxTimer;
import managers.Entities;
import managers.Particles;
import managers.Projectiles;
import objects.entities.Entity;
import objects.particles.CircleParticle;
import objects.particles.Particle;
import objects.particles.StarParticle;
import objects.projectiles.Projectile;
import utils.BoolUtils;
import utils.Palette;

class SwordItem extends WeaponItem {
    public var combo:Int = 0;
    public var maxCombo:Int = 1;
    public var range:Float = 14;
    public var allowMoveWhileUsing:Bool = false;
    
    public var attackParticleCallback:()->FlxSprite = ()-> new CircleParticle(Palette.WHITE);
    
    public final comboDuration:Float = 1;
    public var comboTimer = new FlxTimer();

    public final onDeflectProjectile = new Trigger<Projectile>("sword-item/on-deflect-projectile");
    
    public function new(Name:String) {
        super(Name);

        recoil = -60;
    }
    
    override function update() {
        super.update();

        isUsing = owner.getIsAnyAnimPlaying([
            EntityAnim.ATTACK,
            EntityAnim.ATTACK_LEFT,
            EntityAnim.ATTACK_RIGHT,
        ]);

        if (!allowMoveWhileUsing) {
            owner.allowMove = !isUsing;
            if (isUsing) {
                owner.acceleration.x = 0;
            }
        }
        
        //
        if (!comboTimer.active)
            combo = 0;
    }
    
    // On
    override function onUse() {
        super.onUse();

        comboTimer.start(comboDuration);
        
        combo ++;
        if (combo > maxCombo)
            combo = 1;

        attack();
    }

    //
    function attack() {
        var rangeRect = getRangeRect();
        var entities = Entities.group.members.filter(e-> (
            e != owner &&
            (owner.everyoneIsEnemy ? true : owner.enemiesNames.contains(e.name)) &&
            rangeRect.overlaps(e.getHitbox())
        ));
        var projectiles = Projectiles.group.members.filter(p-> (
            p.owner != owner &&
            (owner.everyoneIsEnemy ? true : owner.enemiesNames.contains(p.owner.name)) &&
            rangeRect.overlaps(new FlxRect(p.x-8, p.y-8, p.width+16, p.height+16))
        ));

        for (entity in entities) {
            hurtEntity(entity);
        }
        for (projectile in projectiles) {
            projectile.deflect(owner);
            onDeflectProjectile.trigger(projectile);
        }
        
        spawnAttackParticle();
        if (projectiles.length > 0)
            spawnDeflectParticles();
    }

    // Particles
    function spawnAttackParticle():FlxSprite {
        var particle = attackParticleCallback();
        var particlePos = owner.getFacePos(8);
        
        particle.flipX = owner.flipX;
        
        Particles.add(
            particle,
            particlePos.x,
            particlePos.y,
            true
        );

        return particle;
    }
    function spawnDeflectParticles() {
        var particlePos = owner.getFacePos(8);
        
        Particles.addMultiple(
            ()-> new StarParticle(Palette.CYAN_1),
            ()-> particlePos.x, ()-> particlePos.y,
            ()-> FlxG.random.float(-80, 80),
            ()-> FlxG.random.float(-80, 80),
            3
        );
    }

    // Get
    public function getRange():Float {
        return range;
    }
    public function getRangeRect():FlxRect {
        var ownerCenterPos = owner.getMidpoint();
        var ownerFlipped = BoolUtils.boolToInt(owner.flipX);
        var width = getRange() + owner.width;
        
        return new FlxRect(
            owner.x + (-width + owner.width) * ownerFlipped, 
            ownerCenterPos.y - 4,
            width, 8
        );
    }
}