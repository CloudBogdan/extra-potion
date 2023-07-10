package utils;

import flixel.util.FlxColor;

class Animations {
    public static function rainbowColor(time:Float):Int {
        return FlxColor.fromHSL((time * 20) % 360, 1, .5);
    }
}