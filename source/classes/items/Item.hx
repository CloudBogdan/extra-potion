package classes.items;

import classes.events.Trigger;
import objects.entities.Entity;

class Item {
    public var name:String;
    public var owner:Null<Entity> = null;

    public var isUsing:Bool = false;

    var unlistens:Array<()->Void> = [];
    
    public function new(Name:String) {
        name = Name;
    }

    public function update() {}

    //
    function listen<T>(trigger:Trigger<T>, listener:TriggerListener<T>) {
        unlistens.push(trigger.listen(listener));
    }
    
    // On
    public function onUse() {}
    public function onEquip(entity:Entity) {
        owner = entity;
    }
    public function onUnequip(entity:Entity) {
        owner = null;
        
        for (unlisten in unlistens) {
            unlisten();
        }
    }

    // Get
    public function getAllowUse():Bool {
        return true;
    }
}