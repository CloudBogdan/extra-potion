package objects.particles;

class JumpParticle extends Particle {
    public function new() {
        super(AssetPaths.jump_particle__png, 4, 12);

        offset.set(width/2, height);
    }
}