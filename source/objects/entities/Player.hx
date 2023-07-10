package objects.entities;

import classes.components.player.InventoryComponent;
import classes.components.player.ScarvesComponent;
import classes.events.Trigger;
import classes.items.SwordItem;
import classes.items.swords.JustSwordItem;
import classes.misc.Attack;
import classes.misc.PressProgress;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import managers.Game;
import managers.Gamepad;
import managers.Gui;
import managers.Objects;
import managers.Particles;
import managers.Score;
import objects.entities.Entity.EntityAnim;
import objects.particles.KillParticle;
import objects.particles.StarParticle;
import objects.particles.SyringeParticle;
import objects.projectiles.Projectile;
import stages.GameOverStage;
import stages.RandomStage;
import utils.Config;
import utils.Palette;

class Player extends Entity {
	public static final NAME:String = "player";
	static final USING_OPIATE_BOOST_DURATION:Float = .6;

	var downPressed:Bool = false;
	var lastGroundPos = new FlxPoint();

	public final scarves:ScarvesComponent;
	public final inventory:InventoryComponent;

	public final useOpiateBoostProgress = new PressProgress(1);
	public final usingOpiateBoostTimer = new FlxTimer();
	public final gameOverTimer = new FlxTimer();

	public function new() {
		super(NAME);

		//
		var justSword = new JustSwordItem();
		weaponSlot.equip(justSword);
		
		listen(justSword.onHitEntity, entity-> {
			FlxG.camera.shake(.004, .02);
			FlxG.sound.play(AssetPaths.hit_entity__wav);
		});
		listen(justSword.onKillEntity, entity-> {
			FlxG.camera.shake(.008, .02);
			FlxG.sound.play(AssetPaths.kill_entity__wav);
			
			spawnKillParticle(entity);

			if (opiate.getIsBoosted())
				FlxTween.num(.01, 1, .01, { startDelay: .02 }, v-> FlxG.timeScale = v);
			else
				FlxTween.num(.2, 1, .1, { startDelay: .05 }, v-> FlxG.timeScale = v);
		});
		listen(justSword.onDeflectProjectile, projectile-> {
			onDeflectProjectile.trigger(projectile);

			FlxTween.num(.2, 1, .1, { startDelay: .02 }, v-> FlxG.timeScale = v);

			Score.add(Config.DEFLECT_PROJECTILE_SCORE + getScoreBoost(), projectile.x+projectile.width/2, projectile.y - 6);
		});

		listen(onKillEntity, enemy-> {
			Score.add(Config.KILL_ENTITY_SCORE + getScoreBoost(), enemy.x+enemy.width/2, enemy.y - 6);
		});

		listen(opiate.onBoostStart, a-> {
			FlxG.sound.play(AssetPaths.yeaaaah__wav);
		});
		listen(opiate.onBoostEnd, forced-> {
			if (forced)
				FlxG.sound.play(AssetPaths.boost_end__wav);
		});

		//
		inventory = new InventoryComponent(this);
		scarves = new ScarvesComponent(this);
		
		//
		addAnimation(EntityAnim.IDLE,         { row: 0, frames: [0] });
		addAnimation(EntityAnim.RUN,          { row: 1, frames: [0,1,2,3,4], frameRate: 14 });
		addAnimation(EntityAnim.DRIFT,        { row: 2, frames: [0] });
		addAnimation(EntityAnim.JUMP,         { row: 3, frames: [0,1,2], looped: false});
		addAnimation(EntityAnim.FALL,         { row: 3, frames: [2] });
		addAnimation(EntityAnim.ATTACK_LEFT,  { row: 4, frames: [0,0,1,2], looped: false });
		addAnimation(EntityAnim.ATTACK_RIGHT, { row: 5, frames: [0,0,1,2], looped: false });
		addAnimation(EntityAnim.DEAD,         { row: 6, frames: [0,1,2], frameRate: 6, looped: false });
		addAnimation(EntityAnim.STUNNED,      { row: 7, frames: [0,1], frameRate: 2 });
		addAnimation(EntityAnim.CLIMB,        { row: 8, frames: [0,1], frameRate: 4 });

		//
		setSize(4, 7);
		offset.set(2, 1);

		bloodColor = Palette.WHITE;
		jumpHeight = 18;
		everyoneIsEnemy = true;
		moveSpeed = 80;
	}

	override function load() {
		super.load();

		opiate.loadOverlay();
	}
	override function update(elapsed:Float) {
		super.update(elapsed);

		if (Objects.worldTilemap.mainTilemap.getIsSolidTileAt(x, y+height+1) && Objects.worldTilemap.mainTilemap.getIsSolidTileAt(x+width, y+height+1))
			lastGroundPos.set(x, y-2);
		
		scarves.update(elapsed);
		
		updateControls(elapsed);

		// DEBUG
		#if FLX_DEBUG
		if (FlxG.keys.justPressed.R) {
			revive();
			setPosition(FlxG.width/2, 0);
			FlxG.log.clear();
		}
		#end
	}
	override function draw() {
		super.draw();

		scarves.draw();
	}

	function updateControls(elapsed:Float) {
		// Moving
		move(Gamepad.getHorizontal(), true);
		// Climbing
		climb(Gamepad.getVertical());
		// Jump off platform
		if (!isClimbing && Gamepad.justDownReleased.triggered && !downPressed)
			jumpOffPlatform();

		// Jumping
		if (Gamepad.justB.triggered)
			jump();
		if (Gamepad.justBReleased.triggered && velocity.y < 0)
			velocity.y *= .8;

		// Items
		if (Gamepad.justA.triggered) {
			useWeapon();
		}

		// Use opiate boost
		if (Gamepad.isDown.triggered) {
			if (!isClimbing && isOnGround) {
				useOpiateBoostProgress.press(elapsed);

				if (useOpiateBoostProgress.getIsFinished()) {
					useOpiateBoost();
					useOpiateBoostProgress.cancel();
					downPressed = true;
				}
			}
 		} else {
			useOpiateBoostProgress.cancel();
			downPressed = false;
		}
	}

	//
	function useOpiateBoost() {
		if (!opiate.getCanBoost()) return;
		
		Particles.add(new SyringeParticle(), x + width/2, y-1, true);
		usingOpiateBoostTimer.start(USING_OPIATE_BOOST_DURATION, t-> opiate.boost());
	}
	function useWeapon() {
		if (!getAllowActions()) return;

		isClimbing = false;

		if (Gamepad.isRight.triggered)
			flipX = false;
		else if (Gamepad.isLeft.triggered)
			flipX = true;
		
		var weapon:Dynamic = weaponSlot.equippedItem;
		if (weapon == null) return;
		var sword:SwordItem = weapon;

		var success = weaponSlot.use();
		if (success)
			FlxG.sound.play(AssetPaths.sword_swipe__wav);

		if (Std.isOfType(sword, SwordItem)) {
			if (sword.combo % 2 == 1)
				playAnimation(EntityAnim.ATTACK_LEFT);
			else if (sword.combo % 2 == 0)
				playAnimation(EntityAnim.ATTACK_RIGHT);
		}
	}
	function spawnKillParticle(entity:Entity) {
		var entityCenter = entity.getMidpoint();
		var killParticle = new KillParticle(opiate.getIsBoosted());
		
		Particles.add(killParticle, entityCenter.x, entityCenter.y, true);
	}
	override function takeDamage(attack:Attack):Bool {
		FlxG.camera.shake(.01, .2);
		FlxG.sound.play(AssetPaths.hit_player__wav);
		
		return super.takeDamage(attack);
	}
	override function kill() {
		super.kill();

		FlxG.sound.play(AssetPaths.game_over__wav);

		gameOverTimer.start(3, t-> {
			FlxG.switchState(new GameOverStage());
		});
	}

	// On
	override function onFallOutScreen() {
		velocity.set(0, 0);
		setPosition(lastGroundPos.x, lastGroundPos.y);

		var attack = new Attack(null, 4);
		takeDamage(attack);
	}
	override function onAnimStart(name:String) {
		super.onAnimStart(name);

		if (name == ATTACK || name == ATTACK_LEFT || name == ATTACK_RIGHT)
			weaponSlot.use();
	}

	// Get
	public function getScoreBoost():Int {
		if (opiate.getIsBoosted())
			return 50;
		
		return 0;
	}
	override function getAllowActions():Bool {
		return super.getAllowActions() && !usingOpiateBoostTimer.active && !Gui.inventory.isVisible;
	}
}
