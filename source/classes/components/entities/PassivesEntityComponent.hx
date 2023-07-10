package classes.components.entities;

import classes.passives.PassiveItem;
import objects.entities.Entity;

class PassivesEntityComponent extends EntityComponent {
    public static final NAME:String = "passives";

    public var list:Array<PassiveItem> = [];
    
    public function new(Parent:Entity) {
        super(Parent, NAME);
    }

    public function equip(item:PassiveItem):Bool {
        if (has(item.name)) return false;
        item.onEquip(parent);
        return true;
    }
    public function unequip(item:PassiveItem):Bool {
        var itemIndex = list.indexOf(item);
        if (itemIndex < 0) return false;
        item.onUnequip(parent);
        list.splice(itemIndex, 1);
        return true;
    }
    
    public function has(name:String):Bool {
        return list.filter(i-> i.name == name).length > 0;
    }
}