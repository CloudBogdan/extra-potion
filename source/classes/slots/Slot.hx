package classes.slots;

import classes.events.Trigger;
import classes.items.Item;
import objects.entities.Entity;

class Slot<T : Item> {
    public var name:String;
    public var parent:Entity;
    
    public var equippedItem:Null<T> = null;

    public final onEquipped = new Trigger<T>("slot/on-equipped");
    public final onUnequipped = new Trigger<T>("slot/on-unequipped");
    
    public function new(Parent:Entity, Name:String, ?item:T) {
        name = Name;
        parent = Parent;
        
        equippedItem = item;
    }

    public function update() {
        updateEquippedItem();
    }

    function updateEquippedItem() {
        if (equippedItem == null) return;

        equippedItem.update();
    }

    //
    public function use():Bool {
        if (equippedItem == null || !parent.alive) return false;
        if (!equippedItem.getAllowUse()) return false;

        equippedItem.onUse();
        return true;
    }
    public function equip(item:T):Bool {
        if (equippedItem == item) return false;
        unequip();
        
        equippedItem = item;
        item.onEquip(parent);
        onEquipped.trigger(item);
        
        return true;
    }
    public function unequip():Bool {
        if (equippedItem == null) return false;
        
        equippedItem.onUnequip(parent);
        onUnequipped.trigger(equippedItem);
        equippedItem = null;
        return true;
    }

    // Get
    public function getIsEquipped():Bool {
        return equippedItem != null;
    }
}