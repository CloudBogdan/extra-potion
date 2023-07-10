package registries;

import managers.Entities.EntityCallback;
import objects.entities.Entity;
import objects.entities.enemies.BomberEnemy;
import objects.entities.enemies.DummyEnemy;
import objects.entities.enemies.GolemEnemy;
import objects.entities.enemies.ShooterEnemy;

typedef EnemyCallback = ()->Entity; 

class EnemiesRegistry {
    public static var registered:Map<String, EnemyCallback> = [];

    public static function init() {
        register(DummyEnemy.NAME, ()-> new DummyEnemy());
        register(ShooterEnemy.NAME, ()-> new ShooterEnemy());
        register(GolemEnemy.NAME, ()-> new GolemEnemy());
        register(BomberEnemy.NAME, ()-> new BomberEnemy());
    }
    
    public static function register(name:String, callback:EntityCallback) {
        registered.set(name, callback);
    }
    public static function get(name:String):Null<EntityCallback> {
        return registered.get(name);
    }
    public static function getArray():Array<EntityCallback> {
        return Lambda.array(registered);
    }
}