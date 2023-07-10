package classes.items;

import classes.events.Trigger;
import classes.misc.Attack;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;
import objects.entities.Entity;

class WeaponItem extends Item {
    public var recoil:Float = 0;
    public var damage:Int = 1;
    public var knockback:Int = 0;
    public var stunTime:Float = 0;
    public var cooldownDuration:Float = .2;

    public final cooldownTimer = new FlxTimer();
    
    public final onHitEntity = new Trigger<Entity>("weapon-item/on-hurt-entity");
    public final onKillEntity = new Trigger<Entity>("weapon-item/on-kill-entity");
    
    public function new(Name:String) {
        super(Name);
    }

    // On
    override function onUse() {
        super.onUse();

        owner.velocity.set(0, 0);
        
        if (owner.flipX)
            owner.velocity.x += getRecoil();
        else 
            owner.velocity.x += -getRecoil();

        startCooldownTimer();
    }
    override function onUnequip(entity:Entity) {
        super.onUnequip(entity);

        onHitEntity.unlistenAll();
        onKillEntity.unlistenAll();
    }

    //
    function hurtEntity(entity:Entity):Bool {
        if (entity == null || !entity.alive) return false;
        
        var attack = new Attack(owner, getDamage(), getKnockback());
        attack.stunTime = stunTime;
        attack.fromPoint = owner.getMidpoint();
        
        var killed = entity.takeDamage(attack);

        if (killed)
            onKillEntity.trigger(entity);
        else
            onHitEntity.trigger(entity);
        
        return true;
    }
    function startCooldownTimer() {
        cooldownTimer.start(cooldownDuration);
    }

    // Get
    public function getRecoil():Float {
        return recoil;
    }
    public function getDamage():Int {
        if (owner.getIsDamageBoost())
            return damage * 2;
        
        return damage;
    }
    public function getKnockback():Int {
        return knockback;
    }
    public function getStunTime():Float {
        return stunTime;
    }
    override function getAllowUse():Bool {
        return super.getAllowUse() && !cooldownTimer.active;
    }
}