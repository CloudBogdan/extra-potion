package objects.entities;

import classes.states.entity.AttackState;
import flixel.FlxG;
import utils.GameUtils;

class RangeEntity extends SmartEntity {
    public var minAttackRange:Float = 16;
    public var isEnemyNear:Bool = false;

    public var attackCooldown:Float = -1;
    
    public function new(Name:String) {
        super(Name);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (!alive || !getAllowActions()) return;
        if (stateMachine.curState.name == AttackState.NAME) return;
        
        var enemyEntities = getNearestEntities().filter(e-> enemiesNames.contains(e.name) && e.alive);
        var nearestEntity = enemyEntities[0];
        if (nearestEntity == null) return;
        
        var center = getMidpoint();
        var enemyCenter = nearestEntity.getMidpoint();
        
        if (!FlxG.camera.containsPoint(center) || !FlxG.camera.containsPoint(enemyCenter)) {
            isEnemyNear = false;
            return;
        }

        isEnemyNear = center.distanceTo(enemyCenter) <= minAttackRange;
        
        if (!isEnemyNear && Math.abs(center.y - enemyCenter.y) <= 4) {
            var directionToNearest = GameUtils.getDirectionBetween(getMidpoint().x, nearestEntity.getMidpoint().x);
            lookAtDirection(directionToNearest);
            stateMachine.set(AttackState.NAME, attackCooldown);
        }
    }

    // Get
    override function getMoveSpeedMultiplier():Float {
        if (isEnemyNear)
            return super.getMoveSpeedMultiplier() * 2;
        
        return super.getMoveSpeedMultiplier();
    }
}