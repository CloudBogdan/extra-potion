package objects.collectible;

import flixel.FlxG;
import flixel.util.FlxColor;
import objects.entities.Entity;

class OpiateCollectible extends Collectible {
    public static final NAME:String = "opiate";
    
    public function new() {
        super(NAME);

        setSize(2, 2);
        offset.set(3, 3);

        time = FlxG.random.int(0, 360);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        color = FlxColor.fromHSL((time * 20) % 360, 1, .5);
    }

    // On
    override function onCollected(entity:Entity) {
        super.onCollected(entity);
        
        entity.opiate.add(1);
    }
}