package classes.states;

import classes.events.Trigger;
import classes.states.State;
import objects.entities.SmartEntity;

typedef StateList = Map<String, State>;
typedef StateListener = (state:State)-> Void;

class StateMachine {
    public var parent:SmartEntity;
    public var states:StateList;
    public var curState:State;

    public final onChanged = new Trigger<State>("state-machine/on-changed");

    public function new(Parent:SmartEntity, curStateName:String, States:StateList) {
        parent = Parent;
        states = States;
        curState = states.get(curStateName);
        
        curState.onEnter(parent);
    }

    public function update(elapsed:Float) {
        if (!parent.exists) return;
        
        curState.update(elapsed);
    }

    //
    public function set(name:String, force:Bool=false, ?cooldown:Float):Bool {
        var state = states.get(name);
        
        if (!force && (curState.name == name || !state.getAllowEnter())) return false;

        curState.onExit();
        curState = state;
        curState.onEnter(parent, cooldown);
        
        onChanged.trigger(curState);
        return true;
    }
}