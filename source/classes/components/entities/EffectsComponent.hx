package classes.components.entities;

import classes.effects.Effect;
import objects.entities.Entity;

class EffectsComponent extends EntityComponent {
    public static final NAME:String = "effects";
    
    public var list:Array<Effect> = [];

    public function new(Parent:Entity) {
        super(Parent, NAME);
    }

    public function update(elapsed:Float) {
        for (effect in list) {
            effect.update(elapsed);
        }
    }
    public function draw() {
        for (effect in list) {
            effect.draw();
        }
    }

    //
    public function add(effect:Effect):Bool {
        var existsEffect = list.filter(e-> e.name == effect.name)[0];
        
        if (existsEffect != null && effect.isInfinite) return false;
        if (existsEffect != null) {
            existsEffect.setTime(effect.timer.time);
            return false;
        }

        effect.onApplied(parent);
        list.push(effect);
        return true;
    }
    public function remove(name:String):Bool {
        var effect = list.filter(e-> e.name == name)[0];
        if (effect == null) return false;
        var effectIndex = list.indexOf(effect);
        if (effectIndex < 0) return false;

        effect.onRemoved();
        list.splice(effectIndex, 1);
        return true;
    }
    public function clear() {
        for (effect in list) {
            effect.onRemoved();
        }
        
        list = [];
    }
}