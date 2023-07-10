package classes.states.entity;

import flixel.util.FlxTimer;
import managers.Objects;
import utils.Config;

class WalkingState extends State {
    public static final NAME:String = "walking";
    public static final FLIP_COOLDOWN_DURATION:Float = .5;
    
    public final flipCooldownTimer = new FlxTimer();
    
    public function new() {
        super(NAME);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        updateFloorDetection();
        updateMovement();
    }

    function updateMovement() {
        var ownerLookDir = owner.getXLookDirection();
        
        owner.move(ownerLookDir);
    }
    function updateFloorDetection() {
        if (!owner.isOnGround) return;
        
        var ownerCenter = owner.getMidpoint();
        var ownerLookDir = owner.getXLookDirection();
        var horOffset = owner.width/2 + Config.SPRITE_SIZE/2;
        
        var isTileInFrontTop = false;
        var isTileInFront = Objects.worldTilemap.mainTilemap.getIsSolidTileAt(
            ownerCenter.x + horOffset * ownerLookDir,
            ownerCenter.y
        );
        var isTileInFrontBottom = Objects.worldTilemap.mainTilemap.getIsSolidTileAt(
            ownerCenter.x + horOffset * ownerLookDir,
            owner.y + owner.height + Config.SPRITE_SIZE/2
        );

        if (owner.height > Config.SPRITE_SIZE) {
            isTileInFrontTop = Objects.worldTilemap.mainTilemap.getIsSolidTileAt(
                ownerCenter.x + horOffset * ownerLookDir,
                ownerCenter.y - Config.SPRITE_SIZE/2
            );
        }

        if ((!isTileInFrontBottom || isTileInFront || isTileInFrontTop) && !flipCooldownTimer.active) {
            flipCooldownTimer.start(FLIP_COOLDOWN_DURATION);
            owner.flipX = !owner.flipX;
        }
    }

    // On
    override function onExit() {
        owner.move(0);
        
        super.onExit();
    }
}