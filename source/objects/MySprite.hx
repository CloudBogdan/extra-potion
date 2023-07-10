package objects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import haxe.Json;
import utils.ArrayUtils;
import utils.Config;
import utils.ValueUtils;

typedef SpriteAnimsPriority = Map<String, ()->Int>;
typedef SpriteAnimParams = {
	row:Int,
	frames:Array<Int>,
	?flags:Array<Dynamic>,
	?frameRate:Int,
	?looped:Bool
}

class MySprite extends FlxSprite {
	public var framesSheetWidth:Int = 5;
	public var animationsPriorities:SpriteAnimsPriority = [];
	public var animationsFlags:Map<String, Array<Dynamic>> = [];

	public function new() {
		super(0, 0);

		pixelPerfectPosition = true;
		animation.callback = (name, frameNumber, frameIndex)-> {
			onAnimPlaying(name, frameIndex, frameNumber);
		}
	}

	//
	public function loadSprite(Graphic:FlxGraphicAsset, FramesSheetWidth:Int=5, Width:Int=Config.SPRITE_SIZE, Height:Int=Config.SPRITE_SIZE, Animated:Bool=true) {
		framesSheetWidth = FramesSheetWidth;
		loadGraphic(Graphic, Animated, Width, Height);
	} 

	//
	override function update(elapsed:Float) {
		super.update(elapsed);
	}

	// Movement
	public function lookAtDirection(direction:Float) {
		flipX = direction < 0;
	}

	// Animations
	public function setAnimationsPriorities(priorities:SpriteAnimsPriority) {
		ArrayUtils.mergeMaps(animationsPriorities, priorities);
	}
	public function addAnimation(name:String, params:SpriteAnimParams) {
		var row = params.row;
		var frames = ValueUtils.safeValue(params.frames, []);
		var frameRate = ValueUtils.safeValue(params.frameRate, 12);
		var looped = ValueUtils.safeValue(params.looped, true);

		if (params.flags != null) {
			animationsFlags.set(name, params.flags);
		}

		if (frames.length <= 1) {
			looped = false;
			frameRate = 0;
		}

		animation.add(name, [for (i in frames) row * framesSheetWidth + i], frameRate, looped);
	}
	public function playAnimation(name:Null<String>, force:Bool=false):Bool {
		if (name == null || animation.getByName(name) == null)
			return false;

		var curPriority = animationsPriorities.get(animation.name);
		var priority = animationsPriorities.get(name);
		
		if (!force && priority != null && curPriority != null) {
			if (!animation.finished && priority() < curPriority())
				return false;
		}

		animation.play(name);
		onAnimStart(name);
		
		return true;
	}
	public function getIsAnimPlaying(name:String):Bool {
		return animation.name == name && !animation.finished;
	}
	public function getIsAnyAnimPlaying(names:Array<String>):Bool {
		return names.contains(animation.name) && !animation.finished;
	}
	public function onAnimPlaying(name:String, curFrame:Int, frameIndex:Int) {
		var flags = animationsFlags.get(name);
		if (flags == null) return;
		
		var flag = flags[frameIndex];
		if (flag != null) {
			onAnimFlagReached(name, flag);
		}
	}
	public function onAnimFlagReached(name:String, flag:Dynamic) {}
	public function onAnimStart(name:String) {}

	// Get
	public function getXLookDirection():Int {
		if (flipX)
			return -1;
		return 1;
	}
	public function getCenter():FlxPoint {
		return new FlxPoint(x + width/2, y + height/2);
	}
}
