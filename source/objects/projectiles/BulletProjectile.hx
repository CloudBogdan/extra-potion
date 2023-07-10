package objects.projectiles;

import flixel.util.FlxDirection;
import objects.entities.Entity;

class BulletProjectile extends Projectile {
    public var moveSpeed:Float = 200;
    public var direction:FlxDirection;
    
    public function new(Name:String, Direction:FlxDirection, Damage:Int=1, ?Owner:Entity) {
        super(Name, Damage, Owner);

        direction = Direction;
    }

    //
    override function update(elapsed:Float) {
        super.update(elapsed);

        updateMovement();
    }
    function updateMovement() {
        if (!exists) return;
        
        var speed = getMoveSpeed();
        
        if (direction == RIGHT) {
            velocity.x = speed;
            angle = 0;
        } else if (direction == LEFT) {
            velocity.x = -speed;
            angle = 180;
        } else if (direction == UP) {
            velocity.y = -speed;
            angle = 270;
        } else if (direction == DOWN) {
            velocity.y = speed;
            angle = 90;
        }
    }

    //
    override function deflect(deflector:Null<Entity>) {
        super.deflect(deflector);
        
        if (direction == RIGHT) {
            direction = LEFT;
        } else if (direction == LEFT) {
            direction = RIGHT;
        } else if (direction == UP) {
            direction = DOWN;
        } else if (direction == DOWN) {
            direction = UP;
        }
    }

    // Get
    public function getMoveSpeed():Float {
        return moveSpeed;
    }
}