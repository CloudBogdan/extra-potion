package utils;

class GameUtils {
    public static function getDirectionBetween(ax:Float, bx:Float):Int {
        var delta = bx - ax;
        if (delta == 0)
            return 0;
        return delta > 0 ? 1 : -1; 
    }
}