package classes.scarves;

import classes.events.Trigger;
import objects.entities.Player;

class Scarf {
    public final name:String;
    public var owner:Player;

    public var isEquipped:Bool = false;
    public var passivesLists:Array<ScarfPassivesList> = [];

    var unlistens:Array<()->Void> = [];
    
    public function new(Owner:Player, Name:String) {
        name = Name;
        owner = Owner;
    }

    public function update(elapsed:Float) {
        for (list in passivesLists) {
            list.update();
        }
    }

    //
    public function unequipPassiveItem() {
        var reversedPassivesLists = passivesLists.copy();
        reversedPassivesLists.reverse();
        for (list in reversedPassivesLists) {
            if (list.actionSlot.getIsEquipped()) {
                list.unequipActionItem();
                break;
            } else if (list.withModifier && list.modifierSlot.getIsEquipped()) {
                list.unequipModifierItem();
                break;
            } else if (list.withCondition && list.conditionSlot.getIsEquipped()) {
                list.unequipConditionItem();
                break;
            }
        }
    }

    //
    function listen<T>(trigger:Trigger<T>, listener:TriggerListener<T>) {
        unlistens.push(trigger.listen(listener));
    }

    // On
    public function onEquip() {
        isEquipped = true;
    }
    public function onUnequip() {
        isEquipped = false;
        
        for (unlisten in unlistens) {
            unlisten();
        }
    }
}