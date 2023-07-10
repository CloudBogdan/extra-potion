package objects.collectible;

import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;
import managers.Collectibles;
import managers.Entities;
import managers.Objects;
import objects.entities.Entity;
import objects.entities.Player;
import utils.Config;
import utils.TimeUtils;

class Collectible extends MySprite {
    static final ALLOW_COLLECT_DELAY:Float = 1;
    
    public var name:String;
    public var time:Int = 0;

    public var autoCollectDelay:Float = 2;
    
    public var entity:Null<Entity> = null;
    public var isAutoCollecting:Bool = false;
    public var isCollected:Bool = false;
    
    public final autoCollectTimer = new FlxTimer();
    public final allowCollectTimer = new FlxTimer();

    public function new(Name:String) {
        super();

        name = Name;

        drag.set(280, 280);

        autoCollectTimer.start(autoCollectDelay);
        allowCollectTimer.start(ALLOW_COLLECT_DELAY, t-> {
            searchEntity();
        });

        load();
    }

    function load() {
        loadSprite('assets/images/collectibles/$name.png');
    }
    public function setup() {
        
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        time ++;

        if (autoCollectTimer.finished && !isAutoCollecting) {
            isAutoCollecting = true;
            onStartCollecting();
        }

        updateMoveToEntity();
        updateCollecting();
    }

    function updateMoveToEntity() {
        if (!isCollected || entity == null || !alive) return;

        var entityCenter = entity.getCenter();
        var center = getCenter();
        
        var direction = (entityCenter - center).normalize();
        velocity.x += direction.x * 20;
        velocity.y += direction.y * 20;

        if (allowCollectTimer.finished && entity.overlaps(this)) {
            onCollected(entity);
        }
    }
    function updateCollecting() {
        if (!alive || isCollected || entity == null) return;
        
        var entityCenter = entity.getCenter();
        var center = getCenter();

        if (allowCollectTimer.finished && center.distanceTo(entityCenter) < Config.SPRITE_SIZE*2) {
            isCollected = true;
        }
        
        if (!isAutoCollecting) return;

        var direction = (entityCenter - center).normalize();
        velocity.x += direction.x * 16;
        velocity.y += direction.y * 16;

    }

    //
    public function searchEntity() {
        var center = getCenter();
        var entities = Entities.group.members.copy();
        entities.sort((a, b)-> Std.int(center.distanceTo(a.getCenter()) - center.distanceTo(b.getCenter())));
        
        entity = entities[0];
    }

    // On
    public function onStartCollecting() {}
    public function onCollected(entity:Entity) {
        entity.onCollect.trigger(this);
        Collectibles.remove(this);

        var sound = FlxG.sound.play(AssetPaths.collect__wav);
        sound.pitch = FlxG.random.float(.8, 1.2);
    }
}