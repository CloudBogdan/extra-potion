package objects.particles;

import flixel.util.FlxTimer;
import managers.Particles;
import utils.Palette;

class ScoreParticle extends MyText {
    static final LIFE_DURATION:Float = 1.4;
    
    final lifeTimer = new FlxTimer();
    
    public function new(score:Int) {
        super(Std.string(score));

        acceleration.y = -10;
        maxVelocity.y = 10;
        color = Palette.LIGHT_GRAY;
        offset.x = width/2;

        lifeTimer.start(LIFE_DURATION, t-> Particles.remove(this));
    }
}