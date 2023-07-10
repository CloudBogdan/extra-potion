package classes.states.entity;

import objects.entities.Entity.EntityAnim;
import objects.entities.SmartEntity;

class AttackState extends State {
    public static final NAME:String = "attack";
    
    public function new() {
        super(NAME);
        
        cooldownDuration = .4;
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (owner.animation.finished) {
            owner.stateMachine.set(WalkingState.NAME);
        }
    }
    
    // On
    override function onEnter(entity:SmartEntity, cooldown:Float=-1) {
        super.onEnter(entity, cooldown);

        entity.playAnimation(EntityAnim.ATTACK);
    }
}