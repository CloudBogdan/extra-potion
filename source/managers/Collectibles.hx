package managers;

import flixel.group.FlxGroup.FlxTypedGroup;
import objects.collectible.Collectible;
import utils.GroupUtils;

typedef CollectibleCallback = GameObjectCallback<Collectible>;

class Collectibles {
    public static var group:FlxTypedGroup<Collectible>;
    
    public static function init() {
        if (group == null)
            group = new FlxTypedGroup();
    }
    public static function update(elapsed:Float) {
        group.update(elapsed);
    }

    public static function add(collectible:Collectible, x:Float, y:Float):Collectible {
        var coll = GroupUtils.add(group, collectible, x, y);
        coll.setup();
        return coll;
    }
    public static function addMultiple(collectibleCallback:CollectibleCallback, x:FloatCallback, y:FloatCallback, velX:FloatCallback, velY:FloatCallback, count:Int=1) {
        function callback() {
            var coll = collectibleCallback();
            coll.velocity.set(velX(), velY());
            coll.setup();
            return coll;
        }
        
        GroupUtils.addMultiple(group, callback, x, y, count);
    }

    public static function remove(collectible:Collectible):Collectible {
        return GroupUtils.remove(group, collectible);
    }
}