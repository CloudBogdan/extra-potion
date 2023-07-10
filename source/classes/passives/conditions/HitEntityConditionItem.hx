package classes.passives.conditions;

import objects.entities.Entity;

class HitEntityConditionItem extends ConditionPassiveItem {
    public static final NAME:String = "hit-entity";
    
    public function new() {
        super(NAME);

        cooldownDuration = 1;
    }

    override function onEquip(entity:Entity) {
        super.onEquip(entity);

        listen(entity.onHitEntity, enemy-> {
            execute(enemy);
        });
    }
}