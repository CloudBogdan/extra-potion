package classes.components.entities;

import classes.events.Trigger;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import managers.Game;
import managers.Particles;
import objects.entities.Entity;
import objects.particles.CircleParticle;
import objects.particles.StarParticle;
import utils.TimeUtils;

class OpiateComponent extends EntityComponent {
    public static final NAME:String = "opiate-boost";
    static final BOOST_DURATION:Float = 10;

    public final maxLevel:Int = 20;
    public final levelToBoost:Int = 2;
    @:isVar public var level(get, set):Int;
    
    public var wasBoosted:Bool = false;
    public var boostForceStopped:Bool = false;
    public var boostFrameTime:Int = 0;

    public var opiateSpriteOverlay:Null<FlxSprite> = null;

    public final onBoostStart = new Trigger<Bool>("opiate-component/on-boost-start");
    public final onBoostEnd = new Trigger<Bool>("opiate-component/on-boost-end");
    
    public function new(Parent:Entity) {
        super(Parent, NAME);

        parent.onKillEntity.listen(a-> {
            if (getIsBoosted())
                boostFrameTime += TimeUtils.secondsToFrames(4);
        });
    }

    public function loadOverlay() {
        opiateSpriteOverlay = new FlxSprite();
        opiateSpriteOverlay.loadGraphic('assets/images/entities/${ parent.name }-opiate-overlay.png', true, parent.frameWidth, parent.frameHeight);
        opiateSpriteOverlay.pixelPerfectPosition = true;
    }
    
    public function update(elapsed:Float) {
        if (boostFrameTime > 0)
            boostFrameTime --;
        
        if (getIsBoosted()) {
            wasBoosted = true;
        } else {
            if (wasBoosted) {
                onBoostEnd.trigger(boostForceStopped);
                wasBoosted = false;
            }
        }
        
        if (getIsBoosted())
            spawnBoostParticles();
    }
    public function draw() {
        if (opiateSpriteOverlay == null || !getIsBoosted()) return;

        opiateSpriteOverlay.setSize(parent.width, parent.height);
        opiateSpriteOverlay.offset.copyFrom(parent.offset);
        opiateSpriteOverlay.flipX = parent.flipX;
        opiateSpriteOverlay.flipY = parent.flipY;
        opiateSpriteOverlay.color = FlxColor.fromHSL((Game.time * 20) % 360, 1, .5);
        opiateSpriteOverlay.animation.frameIndex = parent.animation.frameIndex;
        opiateSpriteOverlay.setPosition(parent.x, parent.y);
        opiateSpriteOverlay.draw();
    }
    
    //
    public function add(value:Int) {
        level += value;

        if (getIsBoosted()) {
            boostFrameTime += TimeUtils.secondsToFrames(1);
        }
    }
    public function boost():Bool {
        if (!getCanBoost()) return false;
        
        level -= 2;
        boostFrameTime += TimeUtils.secondsToFrames(BOOST_DURATION);
        onBoostStart.trigger(true);
        boostForceStopped = false;

        Particles.addMultiple(
			()-> new CircleParticle(null, true),
			()-> parent.x + parent.width/2,
			()-> parent.y + parent.height/2,
			()-> FlxG.random.float(-30, 30),
			()-> FlxG.random.float(-30, 30),
			6
		);

        return true;
    }
    public function stopBoost(forced:Bool=false) {
        boostFrameTime = 0;
        boostForceStopped = forced;
    }

    // Particles
    function spawnBoostParticles() {
		if (Game.every(4)) {
			var ownerCenter = parent.getCenter();
			
			Particles.addMultiple(
				()-> new StarParticle(null, true),
				()-> ownerCenter.x, ()-> ownerCenter.y,
				()-> FlxG.random.float(-80, 80),
				()-> FlxG.random.float(-80, 80),
				1
			);
		}
 	}

    // Set
    function set_level(value:Int):Int {
        level = Math.floor(FlxMath.bound(value, 0, maxLevel));
        return level;
    }

    // Get
    function get_level():Int {
        return level;
    }
    public function getIsBoosted():Bool {
        return boostFrameTime > 0;
    }
    public function getCanBoost():Bool {
        return level >= levelToBoost;
    }
}