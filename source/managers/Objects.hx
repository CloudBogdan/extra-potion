package managers;

import objects.entities.Player;
import objects.misc.Background;
import objects.tilemaps.WorldTilemap;

class Objects {
    public static var player:Player;
    public static var worldTilemap:WorldTilemap;
    public static var background:Background;

    public static function init() {
        player = new Player();
        worldTilemap = new WorldTilemap();
        background = new Background();
    }
    public static function update(elapsed:Float) {
        worldTilemap.backgroundTilemap.update(elapsed);
        worldTilemap.mainTilemap.update(elapsed);
        worldTilemap.laddersTilemap.update(elapsed);
        background.update(elapsed);
    }
}