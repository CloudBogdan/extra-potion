package objects;

import flixel.system.FlxAssets.FlxTilemapGraphicAsset;
import flixel.tile.FlxTilemap;
import utils.Config;

class MyTilemap extends FlxTilemap {
    public var tilesGraphic:FlxTilemapGraphicAsset;
    public var map:Array<Array<Int>> = [[]];
    
    public function new(Graphic:FlxTilemapGraphicAsset, tileSize:Int=Config.TILE_SIZE) {
        super();

        tilesGraphic = Graphic;
        tileWidth = tileSize;
        tileHeight = tileSize;
    }

    public function generate(widthTiles:Int, heightTiles:Int) {
        load([ for (y in 0...heightTiles) [ for (x in 0...widthTiles) 0 ] ]);
    }
    public function load(map:Array<Array<Int>>) {
        loadMapFrom2DArray(map, tilesGraphic, tileWidth, tileHeight);
    }

    // Get
    public function getTileAt(x:Float, y:Float):Int {
        var tileX = Math.floor(x / tileWidth);
        var tileY = Math.floor(y / tileHeight);
        
        if (tileX < 0 || tileY < 0 || tileX >= widthInTiles || tileY >= heightInTiles)
            return 0;
        
        return getTile(tileX, tileY);
    }
    public function getIsSolidTileAt(x:Float, y:Float):Bool {
        var tile = getTileAt(x, y);
        return tile != 0 && getTileCollisions(tile) != NONE;
    }
}