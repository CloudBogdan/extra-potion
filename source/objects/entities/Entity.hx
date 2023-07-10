package objects.entities;

import classes.components.entities.EffectsComponent;
import classes.components.entities.ModifiersComponent;
import classes.components.entities.OpiateComponent;
import classes.components.entities.PassivesEntityComponent;
import classes.effects.StunEffect;
import classes.events.Trigger;
import classes.items.WeaponItem;
import classes.misc.Attack;
import classes.slots.Slot;
import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import managers.Collectibles;
import managers.Entities;
import managers.Game;
import managers.Objects;
import managers.Particles;
import objects.collectible.Collectible;
import objects.collectible.OpiateCollectible;
import objects.particles.BloodParticle;
import objects.particles.HealParticle;
import objects.particles.JumpParticle;
import objects.particles.RunParticle;
import objects.projectiles.Projectile;
import shaders.DarkenShader;
import utils.Config;
import utils.GameUtils;
import utils.Palette;
import utils.TimeUtils;

enum abstract EntityAnim(String) to String {
	var IDLE = "idle";
	var WALK = "walk";
	var RUN = "run";
	var JUMP = "jump";
	var FALL = "fall";
	var CLIMB = "climb";
	var DRIFT = "drift";
	var DEAD = "dead";
	var STUNNED = "stunned";
	var ATTACK = "attack";
	var ATTACK_LEFT = "attack-left";
	var ATTACK_RIGHT = "attack-right";
}

class Entity extends MySprite {
	final COYOTE_DURATION:Float = TimeUtils.framesToSeconds(6);
	final JUMP_BUFFER_DURATION:Float = TimeUtils.framesToSeconds(10);
	final ROTTING_DURATION:Float = 40;
	
	public var name:String;
	public var maxHealth:Int = 10;
	public var darkenShader:DarkenShader;

	public var moveSpeed:Float = 25;
	public var jumpHeight:Float = 10;
	public var bloodColor:Int = Palette.RED_3;
	public var everyoneIsEnemy:Bool = false;
	public var enemiesNames:Array<String> = [];
	public var knockbackAfterDeath:Bool = true;
	public var corpseDarkness:Float = .6;
	public var gravity:Float = Config.GRAVITY;
	
	public var isOnGround:Bool = false;
	public var isRunning:Bool = false;
	public var isCorpse:Bool = false;
	public var isClimbing:Bool = false;
	public var isImmuneToDamage:Bool = false;
	public var isWeakPhysics:Bool = false;
	public var allowCollideWithTilemap:Bool = true;
	public var allowMove:Bool = true;
	public var movementDirection:Int = 0;
	public var lastAttack:Null<Attack> = null;
	
	public final coyoteTimer = new FlxTimer();
	public final jumpBufferTimer = new FlxTimer();
	public final rottingTimer = new FlxTimer();
	
	public final weaponSlot:Slot<WeaponItem>;
	public final opiate:OpiateComponent;
	public final effects:EffectsComponent;
	public final modifiers:ModifiersComponent;

	public final onJump = new Trigger<Bool>("entity/on-jump");
	public final onGotHit = new Trigger<Null<Entity>>("entity/on-got-hurt");
	public final onDeath = new Trigger<Null<Entity>>("entity/on-death");
	public final onHeal = new Trigger<Int>("entity/on-heal");
	public final onHitEntity = new Trigger<Entity>("entity/on-hurt-entity");
	public final onKillEntity = new Trigger<Entity>("entity/on-kill-entity");
	public final onCollect = new Trigger<Collectible>("entity/on-collect");
	public final onDeflectProjectile = new Trigger<Projectile>("entity/on-deflect-projectile");

	var unlistens:Array<()->Void> = [];

	public function new(Name:String) {
		super();

		name = Name;
		health = maxHealth;

		darkenShader = new DarkenShader();
		shader = darkenShader;
		
		acceleration.y = gravity;
		
		weaponSlot = new Slot(this, "main-hand");
		// passives = new PassivesEntityComponent(this);
		opiate = new OpiateComponent(this);
		effects = new EffectsComponent(this);
		modifiers = new ModifiersComponent(this);

		weaponSlot.onEquipped.listen(item-> {
			item.onHitEntity.listen(entity-> onHitEntity.trigger(entity));
			item.onKillEntity.listen(entity-> onKillEntity.trigger(entity));
		});

		setAnimationsPriorities([
			EntityAnim.IDLE         => ()-> 1,
			EntityAnim.WALK         => ()-> 1,
			EntityAnim.RUN          => ()-> 1,
			EntityAnim.DRIFT        => ()-> 1,
			EntityAnim.FALL         => ()-> 1,
			EntityAnim.STUNNED      => ()-> 1,
			EntityAnim.CLIMB        => ()-> 1,
			EntityAnim.JUMP         => ()-> 2,
			EntityAnim.ATTACK       => ()-> 4,
			EntityAnim.ATTACK_LEFT  => ()-> 4,
			EntityAnim.ATTACK_RIGHT => ()-> 4,
			EntityAnim.DEAD         => ()-> 10,
		]);

		load();
	}

	// Setup
	function load() {
		loadSprite('assets/images/entities/$name.png');
	}

	// Lifecycle
	override function update(elapsed:Float) {
		if (isCorpse || !exists) return;
		
		if (isTouching(DOWN)) {
			isOnGround = true;
		} else {
			if (isOnGround) {
				coyoteTimer.start(COYOTE_DURATION);
			}
			isOnGround = false;
		}
		
		super.update(elapsed);
		
		weaponSlot.update();
		opiate.update(elapsed);
		effects.update(elapsed);

		updateMovement();
		updateAnimations();
		updateTileCollision();

		if (exists && alive && y > FlxG.camera.scroll.y + FlxG.height)
			onFallOutScreen();
	}

	function updateMovement() {
		updateMoveSpeed();
		
		if (!getAllowMove()) return;
		if (jumpBufferTimer.active && isOnGround) {
			jump();
			jumpBufferTimer.cancel();
		}
	}
	function updateAnimations() {
		if (!alive) return;

		color = getColor();

		if (effects.list.filter(e-> e.controlsAnimations).length > 0)
			return;
		
		if (isClimbing) {
			playAnimation(EntityAnim.CLIMB, true);
			animation.paused = velocity.y == 0;
			return;
		}
		
		if (velocity.x != 0) {
			if (isRunning)
				playAnimation(EntityAnim.RUN);
			else
				playAnimation(EntityAnim.WALK);
		} else {
			playAnimation(EntityAnim.IDLE);
		}

		if (!isOnGround) {
			playAnimation(EntityAnim.FALL);
		}
	}
	function updateMoveSpeed() {
		acceleration.y = gravity;

		if (isWeakPhysics) return;
		
		var speed = moveSpeed * getMoveSpeedMultiplier();
		var yDrag = gravity*2;
		var yMaxVelocity = gravity;
		
		if (isClimbing) {
			yDrag = speed * 20;
			yMaxVelocity = speed/2;
			acceleration.y = 0;
		}
		
		drag.set(speed * 8, yDrag);
		maxVelocity.set(speed, yMaxVelocity);
	}
	function updateTileCollision() {
		if (allowCollideWithTilemap) return;
		
		var offsets:Array<Array<Float>> = [[0, 0], [width, 0], [0, height-2], [width, height-2]];
		var result = 0;
		
		for (offset in offsets) {
			if (!Objects.worldTilemap.mainTilemap.overlapsPoint(new FlxPoint(x + offset[0], y + offset[1])))
				result ++;
		}
		if (result >= 4)
			allowCollideWithTilemap = true;
	}

	override function draw() {
		super.draw();

		opiate.draw();
		effects.draw();
	}

	// Health
	public function takeDamage(attack:Attack):Bool {
		if (!alive) return true;
		lastAttack = attack;
		
		onGotHit.trigger(attack.fromEntity);
		
		if (isImmuneToDamage) {
			isImmuneToDamage = false;
			return false;
		}
		
		hurt(attack.damage);
		spawnBloodParticles();
		opiate.stopBoost(true);

		isImmuneToDamage = false;
		isClimbing = false;
		
		if (health > 0) {
			attack.applyKnockback(this);
			if (attack.stunTime > 0)
				effects.add(new StunEffect(this, attack.stunTime));
		} else
			return true;

		return false;
	}
	override function kill() {
		effects.clear();
		spawnOpiate();
		weakPhysics();
		playAnimation(EntityAnim.DEAD);
		
		alive = false;

		rottingTimer.start(ROTTING_DURATION, t-> {
			FlxTween.tween(
				this, { alpha: 0 }, 2,
				{
					onComplete: t-> {
						destroy();
						Entities.corpsesGroup.remove(this);
					}
				}
			);
		});

		FlxTween.num(
			0, corpseDarkness, 1,
			{ startDelay: 1, onComplete: t-> isCorpse = true },
			v-> darkenShader.setFactor(v)
		);

		if (lastAttack != null && knockbackAfterDeath) {
			var direction = applyKnockback(80, 40, lastAttack.fromPoint);

			if (lastAttack.fromPoint != null)
				lookAtDirection(-direction);
		}

		// Move to corpses group
		Entities.group.remove(this, true);
		Entities.corpsesGroup.add(this);

		if (lastAttack != null)
			onDeath.trigger(lastAttack.fromEntity);
		else
			onDeath.trigger(null);
	}
	override function revive() {
		super.revive();

		// Move to normal group
		Entities.corpsesGroup.remove(this, true);
		Entities.group.add(this);
		rottingTimer.cancel();
		
		resetPhysics();
		darkenShader.setFactor(0);
		health = maxHealth;
		isCorpse = false;
	}
	public function heal(value:Int):Bool {
		value = Math.floor(FlxMath.bound(value, 0, maxHealth - health));
		if (health >= maxHealth || value <= 0) return false;
		
		health += value;

		onHeal.trigger(value);
		spawnHealParticles();
		return true;
	}
	override function destroy() {
		super.destroy();

		for (unlisten in unlistens) {
            unlisten();
        }
	}

	// Particles
	public function spawnHealParticles() {
        Particles.add(new HealParticle(), x + width/2, y - 4, true);
    }
	public function spawnBloodParticles() {
		var center = getMidpoint();
		
		Particles.addMultiple(
			()-> new BloodParticle(bloodColor),
			()-> center.x, ()-> center.y,
			()-> FlxG.random.float(-70, 70),
			()-> FlxG.random.float(-100, 0),
			4
		);
	}
	public function spawnRunningParticles() {
		var runParticle = new RunParticle();
		runParticle.flipX = flipX;
		Particles.add(runParticle, x + width/2, y + height);
	}
	public function spawnOpiate() {
		var level = getOpiateLevel();
		var center = getCenter();

		Collectibles.addMultiple(
			()-> new OpiateCollectible(),
			()-> center.x, ()-> center.y,
			()-> FlxG.random.float(-100, 100),
			()-> FlxG.random.float(-100, 100),
			level
		);

		opiate.level = 0;
	}
	
	// Movement
	public function move(direction:Int, IsRunning:Bool=false) {
		if (!exists) return;
		if (!getAllowMove() || isClimbing) {
			isRunning = false;
			movementDirection = 0;
			acceleration.x = 0;
			return;
		}
		
		isRunning = IsRunning;
		movementDirection = direction;
		acceleration.x = direction * drag.x;

		if (velocity.x < 0 && direction > 0 || velocity.x > 0 && direction < 0)
			playAnimation(EntityAnim.DRIFT);
		
		if (movementDirection != 0) {
			flipX = movementDirection < 0;

			if (isRunning && isOnGround && Game.every(10))
				spawnRunningParticles();
		}
	}
	public function climb(direction:Float) {
		if (direction == 0 && !isClimbing || !getAllowMove()) return;
		
		var center = getCenter();
		var climbableTile = Objects.worldTilemap.laddersTilemap.getTileAt(center.x, y + height + direction - 1);
		if (climbableTile <= 0) {
			isClimbing = false;
			return;
		}
		
		velocity.y += moveSpeed * direction;
		
		isClimbing = true;
		allowCollideWithTilemap = false;
	}
	public function jump(?Height:Float) {
		if (!getAllowMove()) return;

		if (!isOnGround && !isClimbing) {
			jumpBufferTimer.start(JUMP_BUFFER_DURATION);
		}
		if (!(coyoteTimer.active ? velocity.y > 0 : isOnGround) && !isClimbing) return;
		
		if (Height == null)
			Height = jumpHeight;

		y -= 1;
		velocity.y = -Math.sqrt(Height * 2 * acceleration.y);
		isClimbing = false;
		
		playAnimation(EntityAnim.JUMP);
		Particles.add(new JumpParticle(), x + width/2, y + height+1);
		onJump.trigger(true);
	}
	public function jumpOffPlatform() {
		if (!getAllowMove()) return;
		
		var leftTile = Objects.worldTilemap.mainTilemap.getTileAt(x, y + height+1);
		var rightTile = Objects.worldTilemap.mainTilemap.getTileAt(x + width, y + height+1);
		if (!Objects.worldTilemap.getIsTilePlatform(leftTile) || !Objects.worldTilemap.getIsTilePlatform(rightTile)) return;

		allowCollideWithTilemap = false;
		y += 2;
	}
	public function applyKnockback(velocityX:Float, velocityY:Float, ?fromPos:FlxPoint):Int {
		var direction = FlxG.random.sign();
		
		if (fromPos != null)
			direction = GameUtils.getDirectionBetween(fromPos.x, getMidpoint().x);

		velocity.x += direction * Math.abs(velocityX);
		velocity.y -= Math.abs(velocityY);

		return direction;
	}
	public function weakPhysics() {
		movementDirection = 0;
        isRunning = false;
        acceleration.x = 0;
		drag.x = 160;
		maxVelocity.x = 10000;
		isWeakPhysics = true;
	}
	public function resetPhysics() {
		isWeakPhysics = false;
		updateMoveSpeed();
	}

	//
	function listen<T>(trigger:Trigger<T>, listener:TriggerListener<T>) {
        unlistens.push(trigger.listen(listener));
    }

	// On
	public function onFallOutScreen() {
		Entities.remove(this);
	}
	
	// Get
	public function getNearestEntities(?inDistance:Float):Array<Entity> {
		var center = getCenter();
		var entities = Entities.group.members.copy().filter(e-> (
			e != this &&
			FlxG.camera.containsPoint(e.getCenter()) &&
			(inDistance != null ? center.distanceTo(e.getCenter()) <= inDistance : true) 
		));
		entities.sort((a, b)-> Std.int(center.distanceTo(a.getCenter()) - center.distanceTo(b.getCenter())));
		return entities;
	}
	public function getAllowCollideWithTilemap():Bool {
		return allowCollideWithTilemap;
	}
	public function getColor():Int {
		var result = Palette.ABSOLUTE_WHITE;

		var modifiers = Lambda.array(modifiers.list);
		var modifier = modifiers[modifiers.length-1];
		if (modifier != null && modifier.type == COLOR)
			result = Std.int(modifier.value);

		return result;
	}
	public function getMoveSpeedMultiplier():Float {
		var result:Float = 1;

		for (modifier in modifiers.list) {
			if (modifier.type == MOVE_SPEED_SCALE)
				result *= modifier.value;
		}
		
		return result;
	}
	public function getIsDamageBoost():Bool {
		return opiate.getIsBoosted();
	}
	public function getOpiateLevel():Int {
		return opiate.level;
	}
	public function getAllowMove():Bool {
		return allowMove && getAllowActions();
	}
	public function getAllowActions() {
		var value:Float = 0;
		
		for (modifier in modifiers.list) {
			if (modifier.type == IS_DO_NOTHING)
				value += modifier.value;
		}
		
		return exists && alive && value < 1;
	}
	public function getFacePos(offsetX:Float=0, offsetY:Float=0):FlxPoint {
		var center = getMidpoint();
        var lookDir = getXLookDirection();
		return new FlxPoint(
			center.x + lookDir * (width/2 + offsetX),
            center.y + offsetY
		);
	}
}
