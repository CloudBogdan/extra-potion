package objects.projectiles;

import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;
import managers.Objects;
import managers.Particles;
import objects.entities.Entity;
import objects.particles.CircleParticle;
import objects.particles.Particle;
import utils.Config;
import utils.Palette;

class BombProjectile extends Projectile {
    public static final NAME:String = "bomb";
    static final LIFE_DURATION:Float = 3;

    public var rollSpeed = 50;
    public var direction:Int = 0;

    public final lifeTimer = new FlxTimer();
    
    public function new(Direction:Int, ?Damage:Int, ?Owner:Entity) {
        super(NAME, Damage, Owner);

        direction = FlxMath.signOf(Direction);
        destroyOnHitTilemap = false;
        instantlyDestroyOutScreen = true;

        acceleration.y = Config.GRAVITY;
        drag.set(2, Config.GRAVITY*2);
		maxVelocity.y = Config.GRAVITY;

        setSize(6, 6);
        offset.set(1, 1);

        lifeTimer.start(LIFE_DURATION);
    }

    override function setup() {
        super.setup();

        velocity.y += -100;
        velocity.x += direction * 90;
    }
    
    //
    override function update(elapsed:Float) {
        if (isTouching(RIGHT) || isTouching(LEFT))
            velocity.x *= .8;
        
        super.update(elapsed);
        if (!exists || !alive) return;

        if (lifeTimer.finished)
            explode();

        FlxG.collide(this, Objects.worldTilemap.mainTilemap);
    }

    //
    override function explode() {
        super.explode();

        Particles.addMultiple(
            ()-> new CircleParticle(Palette.YELLOW_2),
            ()-> x+width/2, ()-> y+height/2,
            ()-> FlxG.random.float(-40, 40),
            ()-> FlxG.random.float(-40, 40),
            3,
            true
        );

        FlxG.camera.shake(.016, .16);
        FlxG.sound.play(AssetPaths.explosion__wav);
    }
    override function deflect(deflector:Null<Entity>) {
        super.deflect(deflector);

        var direction = deflector.getXLookDirection();
        velocity.y += -80;
        velocity.x = direction * 120;
    }

    // On
    override function onHitWithEntity(entity:Entity) {
        super.onHitWithEntity(entity);
    }
}