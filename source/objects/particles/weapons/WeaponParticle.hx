package objects.particles.weapons;

import classes.items.WeaponItem;
import flixel.system.FlxAssets.FlxGraphicAsset;
import utils.Config;

class WeaponParticle extends Particle {
    public var weapon:WeaponItem;
    
    public function new(Weapon:WeaponItem, Graphic:FlxGraphicAsset, framesCount:Int=1, frameRate:Int=8, Width:Int=Config.SPRITE_SIZE, Height:Int=Config.SPRITE_SIZE) {
        super(Graphic, framesCount, frameRate, Width, Height);

        weapon = Weapon;
    }
}