package classes.scarves;

import classes.passives.actions.ThrowFreezingFlakeActionItem;
import classes.passives.conditions.GotHitConditionItem;
import classes.passives.conditions.HitEntityConditionItem;
import classes.passives.modifiers.DoubleDamageModifierItem;
import objects.entities.Player;

class CyanScarf extends Scarf {
    public static final NAME:String = "cyan";
    
    public function new(Owner:Player) {
        super(Owner, NAME);

        passivesLists = [
            new ScarfPassivesList(this, true, true),
            new ScarfPassivesList(this, true, false)
        ];
        
        // passivesLists[0].equipConditionItem(new HitEntityConditionItem());
        // passivesLists[0].equipModifierItem(new DoubleDamageModifierItem());
        // passivesLists[0].equipActionItem(new ThrowFreezingFlakeActionItem());
    }
}