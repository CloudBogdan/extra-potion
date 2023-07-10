package classes.passives;

import classes.items.Item;
import classes.scarves.ScarfPassivesList;
import flixel.util.FlxTimer;
import objects.entities.Entity;

class PassiveItem extends Item {
    public var parent:Null<ScarfPassivesList> = null;
    public var pathToSprite:String = "";

    public var allowExecute:Bool = true;
    
    public var cooldownDuration:Float = 0;
    public final cooldownTimer = new FlxTimer();
    
    public function new(Name:String) {
        super(Name);
    }

    public function execute(targetEntity:Null<Entity>):Bool {
        if (!getAllowUse()) return false;
        startCooldownTimer();
        return true;
    }
    public function startCooldownTimer() {
        var cd = getCooldownDuration();
        if (cd > 0) {
            cooldownTimer.start(cd);
        } 
    }
    
    // Get
    public function getCooldownDuration():Float {
        return cooldownDuration;
    }
    public function getCooldownProgress():Float {
        if (!cooldownTimer.active) return 1;
        return cooldownTimer.progress;
    }
    public function getIsEquippedWithScarf():Bool {
        return parent != null;
    }
    override function getAllowUse():Bool {
        return super.getAllowUse() && !cooldownTimer.active && getIsEquippedWithScarf() && allowExecute;
    }
}