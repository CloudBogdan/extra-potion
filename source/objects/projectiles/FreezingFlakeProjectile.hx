package objects.projectiles;

import classes.effects.FreezeEffect;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import managers.Particles;
import objects.entities.Entity;
import objects.particles.StarParticle;
import utils.Config;
import utils.Palette;

class FreezingFlakeProjectile extends Projectile {
    public static final NAME:String = "freezing-flake";

    public var targetEntity:Null<Entity>;
    
    var moveSpeed:Float = 1;
    var allowMove:Bool = false;

    public var effectTime:Float = 2;

    public function new(TargetEntity:Null<Entity>, Damage:Int=1, ?Owner:Entity) {
        super(NAME, Damage, Owner);

        targetEntity = TargetEntity;

        knockback = 50;
        destroyOnHitTilemap = false;

        setSize(7, 7);
    }

    override function setup() {
        super.setup();

        var startX = x;
        var startY = y;
        var dist = Config.SPRITE_SIZE*3;
        var direction = new FlxPoint(FlxG.random.float(-1, 1), FlxG.random.float(-1, 1)).normalize();

        FlxTween.tween(
            this,
            { x: startX + direction.x * dist, y: startY + direction.x * dist },
            .2,
            { ease: FlxEase.cubeIn, onComplete: t-> allowMove = true }
        );
    }

    //
    override function update(elapsed:Float) {
        super.update(elapsed);

        if (allowMove && (targetEntity != null ? !targetEntity.alive : true)) {
            explode();
        }
        
        updateMovement();
        spawnTrail();
    }

    function updateMovement() {
        if (!allowMove || !exists || targetEntity == null) return;

        var targetCenter = targetEntity.getCenter();
        var center = getCenter();

        velocity.copyFrom(
            targetCenter.subtractNew(center).normalize() * moveSpeed
        );
        moveSpeed += 4;
    }
    function spawnTrail() {
        if (time % 5 == 0) {
            var center = getCenter();
            
            Particles.addMultiple(
                ()-> new StarParticle(Palette.BLUE_4),
                ()-> center.x, ()-> center.y,
                ()-> FlxG.random.float(-40, 40),
                ()-> FlxG.random.float(-40, 40),
                1
            );
        }
    }

    //
    override function deflect(deflector:Null<Entity>) {
        targetEntity = owner;
        
        super.deflect(deflector);
    }

    // On
    override function onHitWithEntity(entity:Entity) {
        super.onHitWithEntity(entity);

        entity.effects.add(new FreezeEffect(entity, effectTime));
    }

    // Get
    override function getAllowHitEntities():Bool {
        return super.getAllowHitEntities() && allowMove;
    }
}