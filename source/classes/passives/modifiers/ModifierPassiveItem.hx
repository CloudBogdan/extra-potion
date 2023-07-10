package classes.passives.modifiers;

import classes.passives.actions.ActionPassiveItem;
import objects.entities.Entity;

class ModifierPassiveItem extends PassiveItem {
    public function new(Name:String) {
        super(Name);

        pathToSprite = 'assets/images/passives/modifiers/$name-modifier.png';
    }

    public function apply(actionItem:ActionPassiveItem):Bool {
        if (!getAllowUse()) return false;
        startCooldownTimer();
        return true;
    }
}