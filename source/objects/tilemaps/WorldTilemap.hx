package objects.tilemaps;

import flixel.FlxG;
import flixel.math.FlxPoint;
import ldtk.Entity;
import ldtk.Layer_AutoLayer.AutoTile;
import objects.tilemaps.TilemapProject;
import utils.Config;

class WorldTilemap {
    public var project:TilemapProject;
    public var world:TilemapProject_World_Default;
    
    public var backgroundTilemap:MyTilemap;
    public var mainTilemap:MyTilemap;
    public var laddersTilemap:MyTilemap;

    public var playerSpawnPoints:Array<FlxPoint> = []; 
    public var enemiesSpawnPoints:Array<FlxPoint> = [];

    var lastLevelIndex:Int = -1;
    
    public function new() {
        project = new TilemapProject();
        world = project.all_worlds.Default;
    }

    public function loadRandomLevel() {
        playerSpawnPoints = [];
        enemiesSpawnPoints = [];
        
        // Load level
        var allLevels = world.all_levels;
        var levels = [
            allLevels.Level_1,
            allLevels.Level_2,
            allLevels.Level_3,
            allLevels.Level_4,
            allLevels.Level_5,
            allLevels.Level_7,
            allLevels.Level_8,
            allLevels.Level_9,
        ];

        var levelIndex = 0;
        for (i in 0...5) {
            levelIndex = FlxG.random.int(0, levels.length-1);
            if (levelIndex != lastLevelIndex)
                break;
        }

        var level = levels[levelIndex];
        lastLevelIndex = levelIndex;

        var canCollideArray = project.all_tilesets.Tiles.json.enumTags[0];
        var platformsArray = project.all_tilesets.Tiles.json.enumTags[1];

        backgroundTilemap = new MyTilemap(AssetPaths.tiles__png);
        mainTilemap = new MyTilemap(AssetPaths.tiles__png);
        laddersTilemap = new MyTilemap(AssetPaths.tiles__png);

        backgroundTilemap.generate(level.l_Background.cWid, level.l_Background.cHei);
        backgroundTilemap.setTileProperties(0, NONE);
        backgroundTilemap.setTileProperties(1, NONE);

        mainTilemap.generate(level.l_Main.cWid, level.l_Main.cHei);

        laddersTilemap.generate(level.l_Main.cWid, level.l_Main.cHei);
        laddersTilemap.setTileProperties(0, NONE);
        laddersTilemap.setTileProperties(1, NONE);

        var bgTiles:Array<AutoTile> = level.l_Background.autoTiles;
        for (tile in bgTiles) {
            var x = Std.int(tile.renderX/8);
            var y = Std.int(tile.renderY/8);
            
            backgroundTilemap.setTile(x, y, tile.tileId);
        }

        var mainTiles:Array<AutoTile> = level.l_Main.autoTiles;
        for (tile in mainTiles) {
            var x = Std.int(tile.renderX/8);
            var y = Std.int(tile.renderY/8);
            
            mainTilemap.setTile(x, y, tile.tileId);

            if (canCollideArray.tileIds.contains(tile.tileId)) {
                mainTilemap.setTileProperties(tile.tileId, ANY);
            } else if (platformsArray.tileIds.contains(tile.tileId)) {  
                mainTilemap.setTileProperties(tile.tileId, UP);
            } else {
                mainTilemap.setTileProperties(tile.tileId, NONE);
            }
        }

        var laddersTiles:Array<AutoTile> = level.l_Ladders.autoTiles;
        for (tile in laddersTiles) {
            var x = Std.int(tile.renderX/8);
            var y = Std.int(tile.renderY/8);
            
            laddersTilemap.setTile(x, y, tile.tileId);
        }

        // Load spawn points
        var a:Array<Entity> = untyped level.l_SpawnPoints.all_PlayerSpawn;
        for (playerSpawnPoint in a) {
            playerSpawnPoints.push(new FlxPoint(playerSpawnPoint.cx * Config.TILE_SIZE, playerSpawnPoint.cy * Config.TILE_SIZE));
        }
        var b:Array<Entity> = untyped level.l_SpawnPoints.all_EnemiesSpawn;
        for (enemySpawnPoint in b) {
            enemiesSpawnPoints.push(new FlxPoint(enemySpawnPoint.cx * Config.TILE_SIZE, enemySpawnPoint.cy * Config.TILE_SIZE));
        }
    }

    public function getRandomPlayerSpawnPoint():FlxPoint {
        return playerSpawnPoints[FlxG.random.int(0, playerSpawnPoints.length-1)];
    }

    // Get
    public function getIsTilePlatform(tileIndex:Int):Bool {
        return project.all_tilesets.Tiles.json.enumTags[1].tileIds.contains(tileIndex);
        // return false;
    }
}