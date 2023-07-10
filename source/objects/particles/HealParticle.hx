package objects.particles;

class HealParticle extends Particle {
    public function new() {
        super(AssetPaths.heal_particle__png);

        animation.add("default", [0,1,2,3,3,3,3,3,3,3,3,3,4,4,4,4,5,5,5,6,6,6], 8, false);
        animation.play("default");

        acceleration.y = -6;
        maxVelocity.y = 6;
        offset.set(4, 4);
    }
}