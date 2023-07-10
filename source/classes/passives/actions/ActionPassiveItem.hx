package classes.passives.actions;

import objects.entities.Entity;

class ActionPassiveItem extends PassiveItem {
    public var damageScale:Float = 1;
    public var knockbackScale:Float = 1;
    public var stunTimeScale:Float = 1;
    public var effectTimeScale:Float = 1;
    public var cooldownScale:Float = 1;
    
    public function new(Name:String) {
        super(Name);

        pathToSprite = 'assets/images/passives/actions/$name-action.png';
    }
    
    public function resetScales() {
        damageScale = 1;
        knockbackScale = 1;
        stunTimeScale = 1;
        effectTimeScale = 1;
        cooldownScale = 1;
    }

    // Get
    override function getCooldownDuration():Float {
        return super.getCooldownDuration() * cooldownScale;
    }
}