package classes.effects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import managers.Particles;
import objects.entities.Entity;
import objects.particles.StarParticle;
import utils.Palette;

class ShieldEffect extends Effect {
    public static final NAME:String = "shield";

    final shieldSprite:FlxSprite;
    
    public function new(Entity:Entity) {
        super(NAME, Entity, -1);

        shieldSprite = new FlxSprite();
        shieldSprite.loadGraphic(AssetPaths.shield__png);
        shieldSprite.offset.set(8, 8);
        shieldSprite.pixelPerfectPosition = true;
    }

    override function draw() {
        super.draw();

        var pos = getShieldPos();
        
        shieldSprite.flipX = entity.flipX;
        shieldSprite.setPosition(pos.x, pos.y);
        shieldSprite.draw();
        shieldSprite.alpha = .6;
    }

    // On
    override function onApplied(entity:Entity) {
        super.onApplied(entity);

        listen(entity.onGotHit, enemy-> {
            if (enemy != null) {
                var entityX = entity.getCenter().x;
                var enemyX = enemy.getCenter().x;
                
                if ((!entity.flipX && entityX > enemyX) || (entity.flipX && entityX < enemyX))
                    entity.isImmuneToDamage = true;
            }
            
            onDriedUp();
        });
    }
    override function clear() {
        super.clear();

        var pos = getShieldPos();
        
        Particles.addMultiple(
            ()-> new StarParticle(Palette.YELLOW_2),
            ()-> pos.x, ()-> pos.y,
            ()-> FlxG.random.float(-100, 100),
            ()-> FlxG.random.float(-100, 100),
            2
        );
    }

    // Get
    public function getShieldPos():FlxPoint {
        return entity.getFacePos(-entity.width - 4);
    }
}