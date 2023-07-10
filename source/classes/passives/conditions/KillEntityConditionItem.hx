package classes.passives.conditions;

import objects.entities.Entity;

class KillEntityConditionItem extends ConditionPassiveItem {
    public static final NAME:String = "kill-entity";
    
    public function new() {
        super(NAME);
    }

    override function onEquip(entity:Entity) {
        super.onEquip(entity);

        listen(entity.onKillEntity, enemy-> {
            execute(null);
        });
    }
}