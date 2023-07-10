package objects.particles;

import utils.Animations;

class CircleParticle extends Particle {
    public var time:Float = 0;
    public var isRainbow = false;
    
    public function new(FillColor:Null<Int>, IsRainbow:Bool=false) {
        super(AssetPaths.circle_particle__png, 5, 8);

        if (FillColor != null)
            color = FillColor;
        isRainbow = IsRainbow;
        offset.set(4, 4);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        time ++;

        if (isRainbow)
            color = Animations.rainbowColor(time);
    }
}