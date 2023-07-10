package managers;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import utils.GroupUtils;

typedef DefaultParticle = FlxObject;
typedef ParticleCallback = GameObjectCallback<DefaultParticle>;

class Particles {
    public static var group:FlxTypedGroup<DefaultParticle>;
    public static var fgGroup:FlxTypedGroup<DefaultParticle>;
    
    public static function init() {
        if (group == null)
            group = new FlxTypedGroup();
        if (fgGroup == null)
            fgGroup = new FlxTypedGroup();
    }
    public static function update(elapsed:Float) {
        group.update(elapsed);
        fgGroup.update(elapsed);
    }

    public static function add(particle:DefaultParticle, x:Float, y:Float, foreground:Bool=false):DefaultParticle {
        if (foreground)
            GroupUtils.add(fgGroup, particle, x, y);
        
        return GroupUtils.add(group, particle, x, y);
    }
    public static function addMultiple(particleCallback:ParticleCallback, x:FloatCallback, y:FloatCallback, velX:FloatCallback, velY:FloatCallback, count:Int=1, foreground:Bool=false) {
        function callback() {
            var part = particleCallback();
            part.velocity.set(velX(), velY());
            return part;
        }
        
        if (foreground)
            GroupUtils.addMultiple(fgGroup, callback, x, y, count);
        else
            GroupUtils.addMultiple(group, callback, x, y, count);
    }

    public static function remove(particle:DefaultParticle):DefaultParticle {
        return GroupUtils.remove(group, particle);
    }
}