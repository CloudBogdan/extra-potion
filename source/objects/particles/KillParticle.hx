package objects.particles;

import managers.Game;
import utils.Animations;
import utils.Palette;

class KillParticle extends Particle {
    public var isUltraKill:Bool = false;
    
    public function new(IsUltraKill:Bool=false) {
        super(AssetPaths.kill_particle__png, 5, 16, 32, 32);

        color = Palette.CYAN_1;
        isUltraKill = IsUltraKill;
        offset.set(16, 16);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (isUltraKill)
            color = Animations.rainbowColor(Game.time);
    }
}