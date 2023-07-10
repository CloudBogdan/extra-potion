package classes.passives.conditions;

import objects.entities.Entity;

class DeflectProjectileConditionItem extends ConditionPassiveItem {
    public static final NAME:String = "deflect-projectile";
    
    public function new() {
        super(NAME);
    }

    override function onEquip(entity:Entity) {
        super.onEquip(entity);

        listen(entity.onDeflectProjectile, projectile-> {
            execute(projectile.getLastOwner());
        });
    }
}