package managers;

import flixel.group.FlxGroup.FlxTypedGroup;
import objects.projectiles.Projectile;
import utils.GroupUtils;

typedef ProjectileCallback = GameObjectCallback<Projectile>;

class Projectiles {
    public static var group:FlxTypedGroup<Projectile>;
    
    public static function init() {
        if (group == null)
            group = new FlxTypedGroup();
    }
    public static function update(elapsed:Float) {
        group.update(elapsed);
    }

    public static function add(projectile:Projectile, x:Float, y:Float):Projectile {
        var proj = GroupUtils.add(group, projectile, x, y);
        proj.setup();
        return proj;
    }
    public static function addMultiple(projectileCallback:ProjectileCallback, x:FloatCallback, y:FloatCallback, count:Int=1) {
        function callback() {
            var proj = projectileCallback();
            return proj;
        }
        
        GroupUtils.addMultiple(group, callback, x, y, count);
    }

    public static function remove(projectile:Projectile):Projectile {
        return GroupUtils.remove(group, projectile);
    }
}