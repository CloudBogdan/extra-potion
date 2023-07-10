package classes.passives.actions;

import flixel.FlxG;
import managers.Projectiles;
import objects.entities.Entity;
import objects.projectiles.LargeBulletProjectile;
import utils.GameUtils;

class ShootBulletActionItem extends ActionPassiveItem {
    public static final NAME:String = "shoot-bullet";
    
    public function new() {
        super(NAME);
    }

    override function execute(targetEntity:Null<Entity>):Bool {
        var result = super.execute(targetEntity);
        if (!result || owner == null) return false;
        if (targetEntity == null)
            targetEntity = owner.getNearestEntities()[0];
        
        var direction = FlxG.random.sign();
        if (targetEntity != null)
            direction = GameUtils.getDirectionBetween(owner.getCenter().x, targetEntity.getCenter().x);

        Projectiles.add(new LargeBulletProjectile(direction > 0 ? RIGHT : LEFT, 2, owner), owner.x+owner.width/2, owner.y+owner.height/2);

        FlxG.sound.play(AssetPaths.shoot__wav);
        
        return true;
    }
}