package objects.particles;

import flixel.util.FlxColor;
import managers.Game;
import utils.Animations;

class SyringeParticle extends Particle {
    public function new() {
        super(AssetPaths.syringe_particle__png, 1, 0, 16, 16);

        animation.add("default", [0,1,2,2,2,3,4,4,5,5,6,6,6,6,6,6], 10, false);
        animation.play("default", true);
        offset.set(7, 16);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        color = Animations.rainbowColor(Game.time + 10);
    }
}