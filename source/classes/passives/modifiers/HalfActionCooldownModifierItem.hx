package classes.passives.modifiers;

import classes.passives.actions.ActionPassiveItem;

class HalfActionCooldownModifierItem extends ModifierPassiveItem {
    public static final NAME:String = "half-action-cooldown";
    
    public function new() {
        super(NAME);

        cooldownDuration = 2;
    }

    override function apply(actionItem:ActionPassiveItem):Bool {
        var result = super.apply(actionItem);
        if (!result) return false;

        actionItem.cooldownScale = .5;

        return true;
    }
}