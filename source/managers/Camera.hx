package managers;

import flixel.FlxG;
import utils.Config;

class Camera {
    public static final PADDINGS:Float = Config.SPRITE_SIZE*10;
    
    static public function update(elapsed:Float) {
        // var player = Objects.player;
        // var playerCenter = player.getCenter();

        // FlxG.camera.scroll.x = Math.floor(playerCenter.x/Config.CANVAS_WIDTH)*Config.CANVAS_WIDTH;
        // FlxG.camera.scroll.y = Math.floor(playerCenter.y/Config.CANVAS_HEIGHT)*Config.CANVAS_HEIGHT;
    }

    public static function getRight():Float {
        return FlxG.camera.scroll.x + FlxG.width;
    }
    public static function getLeft():Float {
        return FlxG.camera.scroll.x;
    }
}