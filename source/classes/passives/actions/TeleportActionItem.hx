package classes.passives.actions;

import classes.effects.StunEffect;
import objects.entities.Entity;
import utils.GameUtils;

class TeleportActionItem extends ActionPassiveItem {
    public static final NAME:String = "teleport";
    
    public function new() {
        super(NAME);

        cooldownDuration = 1;
    }

    override function execute(targetEntity:Null<Entity>):Bool {
        var result = super.execute(targetEntity);
        if (!result || owner == null) return false;
        if (targetEntity == null)
            targetEntity = owner.getNearestEntities()[0];
        if (targetEntity == null) return false;

        var targetCenter = targetEntity.getCenter();
        
        var direction = GameUtils.getDirectionBetween(targetCenter.x, owner.getCenter().x);

        if (direction < 0)
            owner.flipX = false;
        else
            owner.flipX = true;

        owner.setPosition(
            targetCenter.x + (targetEntity.width + owner.width) * direction - owner.width/2,
            targetCenter.y - owner.height/2 - 1
        );
        targetEntity.effects.add(new StunEffect(targetEntity, .4));

        return true;
    }
}