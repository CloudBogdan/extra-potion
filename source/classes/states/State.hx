package classes.states;

import flixel.FlxG;
import flixel.util.FlxTimer;
import objects.entities.SmartEntity;

class State {
    public var name:String;
    public var owner:Null<SmartEntity> = null;

    public var cooldownDuration:Float = 0;
    
    public final cooldownTimer = new FlxTimer();
    public final nextStateTimer = new FlxTimer();
    
    public function new(Name:String) {
        name = Name;
    }

    //
    public function update(elapsed:Float) {}
    
    // On
    public function onEnter(entity:SmartEntity, cooldown:Float=-1) {
        owner = entity;

        if (cooldown < 0)
            cooldownDuration = cooldown;
    }
    public function onExit() {
        owner = null;

        if (cooldownDuration != 0)
            cooldownTimer.start(cooldownDuration);
    }
    function onNextState() {}
    
    // Get
    public function getAllowEnter():Bool {
        return !cooldownTimer.active;
    }
}