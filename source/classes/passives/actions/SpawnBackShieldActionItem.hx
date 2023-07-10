package classes.passives.actions;

import classes.effects.ShieldEffect;
import objects.entities.Entity;

class SpawnBackShieldActionItem extends ActionPassiveItem {
    public static final NAME:String = "spawn-back-shield";
    
    var effect:Null<ShieldEffect> = null;
    
    public function new() {
        super(NAME);

        cooldownDuration = 2;
    }

    override function update() {
        super.update();

        if (effect != null && effect.isOver) {
            startCooldownTimer();
            
            allowExecute = true;
            isUsing = false;
            effect = null;
        }
    }
    
    override function execute(targetEntity:Null<Entity>):Bool {
        if (!getAllowUse() || owner == null) return false;

        isUsing = true;
        allowExecute = false;
        
        effect = new ShieldEffect(owner);
        owner.effects.add(effect);

        return true;
    }
}