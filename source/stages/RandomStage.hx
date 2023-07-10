package stages;

import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxTimer;
import haxe.Timer;
import managers.Collectibles;
import managers.Entities;
import managers.Game;
import managers.Gamepad;
import managers.Objects;
import managers.Particles;
import managers.Projectiles;
import objects.MyText;
import objects.entities.Entity;
import objects.misc.EnemySpawner;
import utils.Config;

class RandomStage extends SampleStage {
    static final WAVE_COOLDOWN_DURATION:Float = 5;

    var spawnersGroup:FlxTypedGroup<EnemySpawner>;
    
    var wavesSurvived:Int = 0;
    var isWaveActive:Bool = false;
    var isWaveStarted:Bool = false;
    var waveEnemies:Array<Entity> = [];
    
    var menuText:MyText;

    final waveCooldownTimer = new FlxTimer();
    
    override function create() {
        super.create();

        //
        spawnersGroup = new FlxTypedGroup();
        menuText = new MyText("start to open menu");
        menuText.offset.x = menuText.width/2;
        menuText.alpha = .6;
        menuText.setPosition(FlxG.width/2, 4);
        
        //
		Game.init();
        
        Objects.worldTilemap.loadRandomLevel();

        if (!Objects.player.alive)
            Objects.player.revive();
        
        Projectiles.group.members = [];
        Collectibles.group.members = [];
        Particles.group.members = [];
        Entities.corpsesGroup.members = [];
        Entities.group.members = [];
        Entities.group.add(Objects.player);

        var point = Objects.worldTilemap.getRandomPlayerSpawnPoint();
        Objects.player.setPosition(point.x, point.y);
        
        //
        waveCooldownTimer.start(WAVE_COOLDOWN_DURATION);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        spawnersGroup.update(elapsed);
        Game.update(elapsed);

        if (wavesSurvived >= 3 && !isWaveActive && waveCooldownTimer.finished) {
            FlxG.switchState(new RandomStage());
            return;
        }

        if (!isWaveActive && !isWaveStarted && waveCooldownTimer.finished) {
            summonWave();
            menuText.alpha = 0;
        }
        
        if (isWaveActive && isWaveStarted && waveEnemies.filter(e-> e.alive && e.exists).length == 0) {
            wavesSurvived ++;
            waveCooldownTimer.start(WAVE_COOLDOWN_DURATION);
            isWaveActive = false;
            isWaveStarted = false;
        }
    }

    override function draw() {
        super.draw();

        Game.draw();
        spawnersGroup.draw();

        menuText.draw();
    }

    //
    function summonWave() {
        waveEnemies = [];
        var points = Objects.worldTilemap.enemiesSpawnPoints;
        
        for (pointIndex in 0...points.length) {
            var spawnPoint = points[pointIndex];
            
            Timer.delay(()-> {
                var spawner = new EnemySpawner(spawnPoint.x+Config.TILE_SIZE/2, spawnPoint.y+Config.TILE_SIZE/2);
                spawnersGroup.add(spawner);

                spawner.onEnemySpawned.listen(enemy-> {
                    waveEnemies.push(enemy);
                    isWaveActive = true;
                });
            }, pointIndex * 300);
        }

        isWaveStarted = true;
    }
}