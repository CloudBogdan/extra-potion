package classes.states.entity;

import objects.entities.SmartEntity;

class DeadState extends State {
    public static final NAME:String = "dead";
    
    public function new() {
        super(NAME);
    }

    override function onEnter(entity:SmartEntity, cooldown:Float=-1) {
        super.onEnter(entity, cooldown);
    }
}