package managers;

import flixel.FlxG;
import flixel.FlxObject;
import objects.collectible.OpiateCollectible;
import objects.entities.Entity;
import objects.entities.enemies.BomberEnemy;
import objects.entities.enemies.DummyEnemy;
import objects.entities.enemies.GolemEnemy;
import objects.entities.enemies.ShooterEnemy;
import objects.projectiles.BombProjectile;
import objects.projectiles.FlameBallProjectile;
import openfl.filters.ShaderFilter;
import registries.EnemiesRegistry;

class Game {
    public static var time:Int = 0;
    public static var isPaused:Bool = false;
    static var inited:Bool = false;
    static var musicInited:Bool = false;

    //
    public static function init() {
        if (inited) return;
        
        //
        EnemiesRegistry.init();
        
        Objects.init();
        // Gamepad.init();
        Particles.init();
        Entities.init();
        Collectibles.init();
        Projectiles.init();
        Gui.init();

        inited = true;
    }
    public static function initMusic() {
        if (musicInited) return;
        FlxG.sound.playMusic(AssetPaths.main_theme__wav);
        
        musicInited = true;
    }

    public static function update(elapsed:Float) {
        time ++;

        if (!isPaused) {
            Collectibles.update(elapsed);
            Projectiles.update(elapsed);
            Entities.update(elapsed);
            Objects.update(elapsed);
            Particles.update(elapsed);
        }
        
        Camera.update(elapsed);
        Gui.update(elapsed);

        FlxG.overlap(
			Entities.group,
			Objects.worldTilemap.mainTilemap,
			(a,b)->{},
			(a:Entity, b)-> a.getAllowCollideWithTilemap() && FlxObject.separate(a, b)
		);
		FlxG.collide(Entities.corpsesGroup, Objects.worldTilemap.mainTilemap);
        
        // DEBUG
        #if FLX_DEBUG
        if (FlxG.keys.justPressed.ONE) {
            Entities.add(new DummyEnemy(), FlxG.mouse.x, FlxG.mouse.y);
        }
        if (FlxG.keys.justPressed.TWO) {
            Entities.add(new GolemEnemy(), FlxG.mouse.x, FlxG.mouse.y);
        }
        if (FlxG.keys.justPressed.THREE) {
            Entities.add(new ShooterEnemy(), FlxG.mouse.x, FlxG.mouse.y);
        }
        if (FlxG.keys.justPressed.FOUR) {
            Entities.add(new BomberEnemy(), FlxG.mouse.x, FlxG.mouse.y);
        }

        if (FlxG.keys.pressed.F) {
            Collectibles.addMultiple(
                ()-> new OpiateCollectible(),
                ()-> FlxG.mouse.x,
                ()-> FlxG.mouse.y,
                ()-> FlxG.random.float(-100, 100),
                ()-> FlxG.random.float(-100, 100),
                1
            );
        }

        if (FlxG.keys.justPressed.G) {
            Projectiles.add(new FlameBallProjectile(Objects.player.getNearestEntities()[0], 1, Objects.player), FlxG.mouse.x, FlxG.mouse.y);
        }
        if (FlxG.keys.justPressed.B) {
            Projectiles.add(new BombProjectile(FlxG.random.sign()), FlxG.mouse.x, FlxG.mouse.y);
        }
        #end
    }
    public static function draw() {
        Objects.background.draw();
		Objects.worldTilemap.backgroundTilemap.draw();
		Entities.corpsesGroup.draw();
		Particles.group.draw();
		Objects.worldTilemap.mainTilemap.draw();
		Objects.worldTilemap.laddersTilemap.draw();
		Entities.group.draw();
		Projectiles.group.draw();
		Collectibles.group.draw();
		Particles.fgGroup.draw();
        
        Gui.draw();
    }

    //
    public static function every(frame:Int):Bool {
        return time % frame == 0;
    }
}