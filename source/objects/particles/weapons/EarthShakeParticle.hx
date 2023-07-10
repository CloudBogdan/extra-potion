package objects.particles.weapons;

class EarthShakeParticle extends Particle {
    public function new() {
        super(AssetPaths.earth_shake_particle__png, 4, 8, 32, 16);

        offset.set(16, 16);
        origin.set(16, 16);
    }
}