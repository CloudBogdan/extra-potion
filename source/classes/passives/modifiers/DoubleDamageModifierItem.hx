package classes.passives.modifiers;

import classes.passives.actions.ActionPassiveItem;

class DoubleDamageModifierItem extends ModifierPassiveItem {
    public static final NAME:String = "double-damage";
    
    public function new() {
        super(NAME);

        cooldownDuration = 1.4;
    }

    override function apply(actionItem:ActionPassiveItem):Bool {
        var result = super.apply(actionItem);
        if (!result) return false;

        actionItem.damageScale = 2;
        
        return true;
    }
}