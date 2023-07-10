package objects.particles;

import flixel.util.FlxColor;
import utils.Animations;

class StarParticle extends Particle {
    public var time:Float = 0;

    public var isRainbow:Bool;
    
    public function new(FillColor:Null<Int>, IsRainbow:Bool=false) {
        super(AssetPaths.star_particle__png, 3, 6);

        isRainbow = IsRainbow;
        if (FillColor != null)
            color = FillColor;
        offset.set(4, 4);
        drag.set(200, 200);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        time ++;

        if (isRainbow)
            color = Animations.rainbowColor(time);
    }
}