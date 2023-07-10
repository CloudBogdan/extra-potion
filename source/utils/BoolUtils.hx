package utils;

class BoolUtils {
    public static function boolToInt(bool:Bool):Int {
        if (bool)
            return 1;
        return 0;
    }
}