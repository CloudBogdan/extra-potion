package objects.particles.weapons;

import classes.items.WeaponItem;
import flixel.util.FlxColor;
import managers.Game;
import utils.Animations;
import utils.Palette;

class JustSwordParticle extends WeaponParticle {
    public function new(Weapon:WeaponItem) {
        super(Weapon, AssetPaths.just_sword_particle__png, 4, 16, 16, 16);

        color = Palette.CYAN_1;
        offset.set(8, 8);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (weapon.owner.opiate.getIsBoosted()) {
            color = Animations.rainbowColor(Game.time + 5);
        }
    }
}