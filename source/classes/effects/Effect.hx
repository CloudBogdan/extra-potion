package classes.effects;

import classes.events.Trigger;
import flixel.util.FlxTimer;
import objects.entities.Entity;

class Effect {
    public final name:String;
    public final entity:Entity;

    public var isOver:Bool = false;
    public var allowDry:Bool = true;
    
    public var controlsAnimations:Bool = false;
    
    public var isInfinite:Bool = false;
    public final timer = new FlxTimer();

    var unlistens:Array<()->Void> = [];
    
    public function new(Name:String, Entity:Entity, Duration:Float) {
        name = Name;
        entity = Entity;

        if (Duration < 0)
            isInfinite = true;
        else {
            timer.start(Duration, t-> onDriedUp());
            isInfinite = false;
        }
    }

    public function update(elapsed:Float) {
        timer.active = allowDry;
    }
    public function draw() {}

    public function clear() {
        isOver = true;
        
        for (unlisten in unlistens) {
            unlisten();
        }
    }
    
    //
    public function setTime(time:Float) {
        timer.reset(Math.max(time, timer.elapsedTime / 1000));
        isInfinite = false;
    }

    //
    function listen<T>(trigger:Trigger<T>, listener:TriggerListener<T>) {
        unlistens.push(trigger.listen(listener));
    }
    
    // On
    public function onApplied(entity:Entity) {}
    public function onDriedUp() {
        clear();
        entity.effects.remove(name);
    }
    public function onRemoved() {
        clear();
    }
}