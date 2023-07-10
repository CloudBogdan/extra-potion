package utils;

import flixel.FlxObject;
import flixel.group.FlxGroup.FlxTypedGroup;

class GroupUtils {
    //
    public static function add<T:FlxObject>(group:FlxTypedGroup<T>, object:T, x:Float, y:Float):Null<T> {
        if (object == null) return null;

        object.x = x;
        object.y = y;
        return group.add(object);
    }
    public static function addMultiple<T:FlxObject>(group:FlxTypedGroup<T>, objectCallback:GameObjectCallback<T>, xCallback:FloatCallback, yCallback:FloatCallback, count:Int=1) {
        for (i in 0...count) {
            var object = objectCallback();
            if (object == null) continue;
            
            add(group, object, xCallback(), yCallback());
        }
    }
    
    public static function remove<T:FlxObject>(group:FlxTypedGroup<T>, object:T):T {
        object.destroy();
        group.remove(object, true);
        return object;
    }
}