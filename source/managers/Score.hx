package managers;

import flixel.util.FlxTimer;
import objects.particles.ScoreParticle;

class Score {
    public static var score:Int = 0;

    public static function add(value:Int, x:Float, y:Float):Bool {
        if (value <= 0) return false;
        
        score += value;

        Particles.add(new ScoreParticle(value), x, y, true);
        return true;
    }
    public static function reset() {
        score = 0;
    }
}