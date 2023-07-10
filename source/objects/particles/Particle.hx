package objects.particles;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import managers.Particles;
import utils.Config;

class Particle extends FlxSprite {
    public function new(Graphic:FlxGraphicAsset, framesCount:Int=1, frameRate:Int=8, Width:Int=Config.SPRITE_SIZE, Height:Int=Config.SPRITE_SIZE) {
        super(0, 0);

        immovable = true;
        allowCollisions = NONE;
        pixelPerfectPosition = true;
        
        loadGraphic(Graphic, true, Width, Height);
        animation.add("default", [for (i in 0...framesCount) i], frameRate, false);
        animation.play("default");
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (animation.name == "default" && animation.finished) {
            Particles.remove(this);
        }
    }
}