package managers;

import flixel.group.FlxGroup.FlxTypedGroup;
import objects.entities.Entity;
import objects.entities.Player;
import utils.GroupUtils;

typedef EntityCallback = GameObjectCallback<Entity>;

class Entities {
    public static var group:FlxTypedGroup<Entity>;
    public static var corpsesGroup:FlxTypedGroup<Entity>;
    
    public static function init() {
        if (group == null)
            group = new FlxTypedGroup();
        if (corpsesGroup == null)
            corpsesGroup = new FlxTypedGroup();

        group.add(Objects.player);
    }
    public static function update(elapsed:Float) {
        group.update(elapsed);
        corpsesGroup.update(elapsed);
        
        group.sort((i, a, b)-> {
            if (Std.isOfType(a, Player))
                return -i;
            if (!Std.isOfType(a, Player) && !Std.isOfType(b, Player))
                return 0;
            
            return i;
        });
    }

    //
    public static function add(entity:Entity, x:Float, y:Float):Entity {
        return GroupUtils.add(group, entity, x, y);
    }
    public static function addMultiple(enemyCallback:EntityCallback, xCallback:FloatCallback, yCallback:FloatCallback, count:Int=1) {
        GroupUtils.addMultiple(group, enemyCallback, xCallback, yCallback, count);
    }

    public static function remove(entity:Entity):Entity {
        return GroupUtils.remove(group, entity);
    }
}