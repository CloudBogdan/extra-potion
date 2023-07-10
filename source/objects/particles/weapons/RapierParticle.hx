package objects.particles.weapons;

class RapierParticle extends Particle {
    public function new() {
        super(AssetPaths.rapier_particle__png, 4, 16, 16, 16);

        offset.set(8, 8);
    }
}