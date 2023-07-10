package classes.passives.conditions;

import objects.entities.Entity;

class GotHitConditionItem extends ConditionPassiveItem {
    public static final NAME:String = "got-hit";
    
    public function new() {
        super(NAME);
    }

    override function onEquip(entity:Entity) {
        super.onEquip(entity);

        listen(owner.onGotHit, enemy-> {
            execute(enemy);
        });
    }
}