package classes.states.entity;

import flixel.FlxG;
import managers.Game;
import objects.entities.SmartEntity;

class IdleState extends State {
    public static final NAME:String = "idle";
    
    public function new() {
        super(NAME);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (Game.every(10) && FlxG.random.bool(15))
            owner.flipX = !owner.flipX;
    }

    // On
    override function onEnter(entity:SmartEntity, cooldown:Float=-1) {
        super.onEnter(entity, cooldown);

        nextStateTimer.start(FlxG.random.float(1, 10), t-> onNextState());
    }
    override function onNextState() {
        super.onNextState();

        owner.stateMachine.set(WalkingState.NAME);
    }
}