package objects.projectiles;

import classes.misc.Attack;
import flixel.FlxG;
import flixel.util.FlxDirection;
import managers.Entities;
import managers.Objects;
import managers.Projectiles;
import objects.entities.Entity;
import utils.TimeUtils;

class Projectile extends MySprite {
    public var name:String;
    public var lastOwner:Null<Entity> = null;
    public var owner:Null<Entity> = null;
    public var time:Float = 0;

    public var instantlyDestroyOutScreen:Bool = false;
    public var destroyOnHitTilemap:Bool = true;
    public var destroyOnHitEntity:Bool = true;
    
    public var damage:Int;
    public var knockback:Float = 0;
    public var stunTime:Float = 0;

    public var hurtOwner:Bool = false;
    public var hurtEveryone:Bool = false;
    public var hurtEntitiesNames:Array<String> = [];
    
    public function new(Name:String, Damage:Int=1, ?Owner:Entity) {
        super();

        name = Name;
        owner = Owner;
        damage = Damage;

        if (owner != null) {
            hurtEveryone = owner.everyoneIsEnemy;
            hurtEntitiesNames = owner.enemiesNames;
        } else {
            hurtEveryone = true;
        }

        load();
    }

    function load() {
        loadSprite('assets/images/projectiles/$name.png');
    }
    public function setup() {}
    
    //
    override function update(elapsed:Float) {
        super.update(elapsed);
        time ++;

        updateCollisions();
    }

    function updateCollisions() {
        var center = getCenter();

        if (!FlxG.camera.containsPoint(center) && (instantlyDestroyOutScreen ? true :time > TimeUtils.secondsToFrames(6))) {
            Projectiles.remove(this);
        }
        
        if (Objects.worldTilemap.mainTilemap.overlaps(this))
            onHitWithTilemap();

        if (getAllowHitEntities()) 
            FlxG.overlap(this, Entities.group, (projectile, entity)-> {
                if (Std.isOfType(entity, Entity)) {
                    if (getIsEntityValid(entity))
                        onHitWithEntity(entity);
                }
            });
    }

    //
    public function explode() {
        Projectiles.remove(this);
    }
    public function deflect(deflector:Null<Entity>) {
        if (deflector != null) {
            lastOwner = owner;
            owner = deflector;
            hurtEveryone = deflector.everyoneIsEnemy;
            hurtEntitiesNames = deflector.enemiesNames;
        } else {
            hurtOwner = true;
        }

        damage *= 3;
    }

    // On
    public function onHitWithTilemap() {
        if (destroyOnHitTilemap)
            explode();
    }
    public function onHitWithEntity(entity:Entity) {    
        var attack = new Attack(owner, getDamage(), getKnockback());
        attack.fromPoint = getCenter();
        attack.stunTime = getStunTime();
        
        var isDead = entity.takeDamage(attack);

        if (isDead)
            owner.onKillEntity.trigger(entity);
        else 
            owner.onHitEntity.trigger(entity);
        
        if (destroyOnHitEntity)
            explode();
    }
    
    // Get
    public function getIsEntityValid(entity:Null<Entity>):Bool {
        if (entity == null) return false;
        if (!(hurtOwner || (owner != null ? entity.ID != owner.ID : true))) return false;
        return hurtEntitiesNames.contains(entity.name) || hurtEveryone || hurtOwner;
    }
    public function getAllowHitEntities():Bool {
        return true;
    }
    public function getDamage():Int {
        return damage;
    }
    public function getKnockback():Float {
        return knockback;
    }
    public function getStunTime():Float {
        return stunTime;
    }
    public function getLastOwner():Null<Entity> {
        if (lastOwner == null)
            return owner;
        return lastOwner;
    }
}