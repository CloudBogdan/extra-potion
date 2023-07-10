package objects.entities;

import classes.states.entity.AttackState;
import managers.Entities;
import managers.Projectiles;
import utils.GameUtils;

class MeleeEntity extends SmartEntity {
    public var attackRange:Float = 16;
    
    public function new(Name:String) {
        super(Name);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (!alive || !getAllowActions()) return;

        if (stateMachine.curState.name == AttackState.NAME) return;
        
        var center = getCenter();
        
        var enemyEntities = getNearestEntities(attackRange).filter(e-> enemiesNames.contains(e.name) && e.alive);
        
        var nearestEntity = enemyEntities[0];
        if (nearestEntity != null) {
            var enemyCenter = nearestEntity.getMidpoint();
            if (Math.floor(center.y - enemyCenter.y) <= 4) {
                var directionToFirst = GameUtils.getDirectionBetween(getMidpoint().x, nearestEntity.getMidpoint().x);

                lookAtDirection(directionToFirst);
                stateMachine.set(AttackState.NAME);
            }
        }
    }
}