package classes.passives.actions;

import objects.entities.Entity;

class HealActionItem extends ActionPassiveItem {
    public static final NAME:String = "heal";
    
    public function new() {
        super(NAME);
        
        cooldownDuration = 3;
    }

    override function execute(targetEntity:Null<Entity>):Bool {
        var result = super.execute(targetEntity);
        if (!result || owner == null) return false;

        owner.heal(1);
        return true;
    }
}