package objects.projectiles;

import classes.misc.Attack;
import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import managers.Entities;
import managers.Particles;
import objects.entities.Entity;
import objects.particles.CircleParticle;
import objects.particles.StarParticle;
import utils.Config;
import utils.Palette;

class FlameBallProjectile extends Projectile {
    public static final NAME:String = "flame-ball";

    public var targetEntity:Null<Entity>;
    public var targetPos = new FlxPoint();
    
    var moveSpeed:Float = 4;
    var moveAngle:Float = FlxG.random.float(0, Math.PI*2);
    var accuracy:Float = .1;

    public var effectTime:Float = 2;

    public function new(TargetEntity:Null<Entity>, Damage:Int=1, ?Owner:Entity) {
        super(NAME, Damage, Owner);

        targetEntity = TargetEntity;

        knockback = 80;
        stunTime = 1;
        destroyOnHitTilemap = false;
        destroyOnHitEntity = false;
        hurtEveryone = true;
        hurtOwner = true;

        setSize(7, 7);
    }

    override function setup() {
        super.setup();
        FlxG.sound.play(AssetPaths.flame_ball__wav);

        for (i in 0...10) {
            var posX = x + FlxG.random.int(-64, 64);
            var posY = y + FlxG.random.int(-64, 64);

            if (!FlxG.camera.containsPoint(new FlxPoint(posX, posY)) && i < 10)
                continue;
            
            targetPos.set(posX, posY);
        }
    }

    //
    override function update(elapsed:Float) {
        super.update(elapsed);
        
        updateMovement();
        updateExplode();
        spawnTrail();
    }

    function updateExplode() {
        var center = getCenter();
        var targetCenter = targetPos;
        if (targetEntity != null && targetEntity.alive)
            targetCenter = targetEntity.getCenter();

        if (center.distanceTo(targetCenter) < 8)
            explode();
    }
    function updateMovement() {
        if (!exists) return;

        var center = getCenter();
        var targetCenter = targetPos;
        if (targetEntity != null && targetEntity.alive)
            targetCenter = targetEntity.getCenter();

        var direction = center.subtractNew(targetCenter).normalize();
        moveAngle = FlxMath.lerp(moveAngle, Math.atan2(direction.y, direction.x), accuracy);

        velocity.x -= Math.cos(moveAngle) * moveSpeed;
        velocity.y -= Math.sin(moveAngle) * moveSpeed;

        moveSpeed += .2;
        accuracy += .1;
        accuracy = FlxMath.bound(accuracy, 0, 1);
    }
    function spawnTrail() {
        if (time % 4 == 0) {
            Particles.addMultiple(
                ()-> new CircleParticle(Palette.ORANGE_3),
                ()-> x + width/2, ()-> y + height/2,
                ()-> FlxG.random.float(-20, 20),
                ()-> FlxG.random.float(-20, 20),
                1
            );
        }
    }

    //
    override function explode() {
        Particles.addMultiple(
            ()-> new CircleParticle(Palette.ORANGE_3),
            ()-> x + width/2, ()-> y + height/2,
            ()-> FlxG.random.float(-40, 40),
            ()-> FlxG.random.float(-40, 40),
            6,
            true
        );

        var entities = Entities.group.members.filter(e-> getIsEntityValid(e) && getCenter().distanceTo(e.getCenter()) < 32);

        for (entity in entities) {
            var attack = new Attack(owner, getDamage(), getKnockback());
            attack.fromPoint = getCenter();
            attack.stunTime = getStunTime();

            var isDead = entity.takeDamage(attack);

            if (isDead)
                owner.onKillEntity.trigger(entity);
            else 
                owner.onHitEntity.trigger(entity);
        }

        FlxG.camera.shake(.03, .16);
        FlxG.sound.play(AssetPaths.explosion__wav);
        
        super.explode();
    }

    // On
    override function onHitWithEntity(entity:Entity) {}
}