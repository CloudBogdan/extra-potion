package utils;

class TimeUtils {
    public static function framesToSeconds(frames:Int):Float {
        return frames/60;
    }
    public static function secondsToFrames(seconds:Float):Int {
        return Math.floor(seconds*60);
    }
}