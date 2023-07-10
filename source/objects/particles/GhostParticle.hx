package objects.particles;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import managers.Particles;
import utils.Animations;

class GhostParticle extends FlxSprite {
    static final LIFE_DURATION:Float = .4;
    
    public var time:Float = 0;
    public var isRainbow:Bool;

    public final lifeTimer = new FlxTimer();
    
    public function new(sprite:FlxSprite, IsRainbow:Bool=false) {
        super(0, 0);

        isRainbow = IsRainbow;
        immovable = true;
        pixelPerfectPosition = true;
        allowCollisions = NONE;
        
        loadGraphic(sprite.graphic, true, sprite.frameWidth, sprite.frameHeight);
        setSize(sprite.width, sprite.height);
        offset.copyFrom(sprite.offset);
        animation.frameIndex = sprite.animation.frameIndex;
        flipX = sprite.flipX;
        flipY = sprite.flipY;
        alpha = .3;
        
        //
        lifeTimer.start(LIFE_DURATION, t-> Particles.remove(this));
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        time ++;

        if (isRainbow)
            color = Animations.rainbowColor(time);
    }
}