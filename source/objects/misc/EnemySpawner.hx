package objects.misc;

import classes.events.Trigger;
import flixel.FlxG;
import flixel.util.FlxTimer;
import managers.Entities;
import objects.entities.Entity;
import registries.EnemiesRegistry;

class EnemySpawner extends MySprite {
    public static final SPAWN_DELAY:Float = 2;
    
    public var timer = new FlxTimer();

    public final onEnemySpawned = new Trigger<Entity>("enemy-spawner/on-enemy-spawned");
    
    public function new(X:Float, Y:Float) {
        super();
        
        x = X;
        y = Y;

        loadSprite(AssetPaths.enemy_spawner__png, 3);
        offset.set(4, 4);
        animation.add("spawn", [0,1,2], 8, false);
        animation.add("pulse", [1,2], 4, true);
        animation.play("spawn");

        timer.start(SPAWN_DELAY);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (!getIsAnimPlaying("spawn"))
            animation.play("pulse");

        if (timer.finished)
            spawnEntity();
    }
    public function spawnEntity() {
        var enemyCallbacks = EnemiesRegistry.getArray();
        var enemyCallback = enemyCallbacks[FlxG.random.int(0, enemyCallbacks.length)];
        if (enemyCallback == null) return;
        var enemy = enemyCallback();

        Entities.add(enemy, x - enemy.width/2, y - enemy.height);
        onEnemySpawned.trigger(enemy);

        destroy();
    }
}