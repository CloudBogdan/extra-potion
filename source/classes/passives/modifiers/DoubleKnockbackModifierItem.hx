package classes.passives.modifiers;

import classes.passives.actions.ActionPassiveItem;

class DoubleKnockbackModifierItem extends ModifierPassiveItem {
    public static final NAME:String = "double-knockback";
    
    public function new() {
        super(NAME);

        cooldownDuration = 1;
    }

    override function apply(actionItem:ActionPassiveItem):Bool {
        var result = super.apply(actionItem);
        if (!result) return false;

        actionItem.knockbackScale = 2;
        
        return true;
    }
}