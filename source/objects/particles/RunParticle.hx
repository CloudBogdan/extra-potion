package objects.particles;

class RunParticle extends Particle {
    public function new() {
        super(AssetPaths.run_particle__png, 5, 12);

        offset.set(width/2, height);
    }
}