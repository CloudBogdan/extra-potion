package classes.components.entities;

import objects.entities.Entity;

enum abstract EntityModifierType(String) to String {
    var MOVE_SPEED_SCALE = "move-speed-scale";
    var IS_DO_NOTHING = "is-do-nothing";
    var COLOR = "color";
}

class ModifiersComponent extends EntityComponent {
    public static final NAME:String = "modifiers";
    
    public var list:Map<String, EntityModifier> = [];
    
    public function new(Parent:Entity) {
        super(Parent, NAME);
    }

    public function update(elapsed:Float) {
        for (modifier in list) {
            modifier.update(elapsed);
        }
    }

    public function add(key:String, modifier:EntityModifier) {
        list.set(key, modifier);
    }
    public function remove(key:String) {
        list.remove(key);
    }
}

class EntityModifier {
    public var type:EntityModifierType;
    public var value:Float;
    
    public function new(Type:EntityModifierType, Value:Float) {
        type = Type;
        value = Value;
    }

    public function update(elapsed:Float) {}
}