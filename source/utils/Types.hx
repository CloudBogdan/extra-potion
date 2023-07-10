package utils;

import flixel.FlxObject;

typedef FloatCallback = ()->Float;
typedef IntCallback = ()->Int;

typedef GameObjectCallback<T : FlxObject> = ()-> T;

typedef RGBA = Array<Float>;

enum Direction {
    HORIZONTAL;
    VERTICAL;
}