package objects.entities;

import classes.states.StateMachine;
import classes.states.entity.AttackState;
import classes.states.entity.DeadState;
import classes.states.entity.IdleState;
import classes.states.entity.WalkingState;
import utils.ArrayUtils;

class SmartEntity extends Entity {
    public final stateMachine:StateMachine;

    public function new(Name:String) {
        super(Name);

        stateMachine = new StateMachine(this, WalkingState.NAME, [
            IdleState.NAME=> new IdleState(),
            WalkingState.NAME=> new WalkingState(),
            AttackState.NAME=> new AttackState(),
            DeadState.NAME=> new DeadState(),
        ]);
    }

    //
    override function update(elapsed:Float) {
        super.update(elapsed);

        updateStates(elapsed);
    }

    function updateStates(elapsed:Float) {
        stateMachine.update(elapsed);
    }

    override function kill() {
        super.kill();

        stateMachine.set(DeadState.NAME);
    }

    // Set
    function setStates(states:StateList) {
        ArrayUtils.mergeMaps(stateMachine.states, states);
    }
}