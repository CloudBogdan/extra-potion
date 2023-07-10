package classes.passives.conditions;

import objects.entities.Entity;

class JumpConditionItem extends ConditionPassiveItem {
    public static final NAME:String = "jump";
    
    public function new() {
        super(NAME);
    }

    override function onEquip(entity:Entity) {
        super.onEquip(entity);

        listen(entity.onJump, a-> {
            execute(null);
        });
    }
}