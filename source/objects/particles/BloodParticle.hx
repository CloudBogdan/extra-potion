package objects.particles;

import utils.Config;
import utils.Palette;

class BloodParticle extends CircleParticle {
    public function new(FillColor:Int=Palette.RED_3) {
        super(FillColor);

        acceleration.y = Config.GRAVITY/2;
        maxVelocity.y = Config.GRAVITY;
    }
}