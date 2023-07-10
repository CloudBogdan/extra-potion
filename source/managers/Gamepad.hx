package managers;

import flixel.FlxG;
import flixel.input.actions.FlxAction.FlxActionDigital;
import flixel.input.actions.FlxActionManager;
import utils.BoolUtils;

class Gamepad {
	public static var isRight:FlxActionDigital;
	public static var isLeft:FlxActionDigital;
	public static var isUp:FlxActionDigital;
	public static var isDown:FlxActionDigital;
    public static var justRight:FlxActionDigital;
	public static var justLeft:FlxActionDigital;
	public static var justUp:FlxActionDigital;
	public static var justDown:FlxActionDigital;
	public static var justDownReleased:FlxActionDigital;
    
	public static var justStart:FlxActionDigital;
	public static var isA:FlxActionDigital;
	public static var isB:FlxActionDigital;
	public static var justA:FlxActionDigital;
	public static var justB:FlxActionDigital;
	public static var justBReleased:FlxActionDigital;

	public static var actions:FlxActionManager;

    static var inited:Bool = false;

    //
    public static function getHorizontal():Int {
        return BoolUtils.boolToInt(isRight.triggered) - BoolUtils.boolToInt(isLeft.triggered);
    }
    public static function getVertical():Int {
        return BoolUtils.boolToInt(isDown.triggered) - BoolUtils.boolToInt(isUp.triggered);
    }

    //
	public static function init() {
        // if (inited) return;
        
		isRight = new FlxActionDigital("is-right")
            .addKey(D, PRESSED)
            .addKey(RIGHT, PRESSED)
            .addGamepad(DPAD_RIGHT, PRESSED)
            .addGamepad(LEFT_STICK_DIGITAL_RIGHT, PRESSED);
		isLeft = new FlxActionDigital("is-left")
            .addKey(A, PRESSED)
            .addKey(LEFT, PRESSED)
			.addGamepad(DPAD_LEFT, PRESSED)
            .addGamepad(LEFT_STICK_DIGITAL_LEFT, PRESSED);
		isUp = new FlxActionDigital("is-up")
            .addKey(W, PRESSED)
            .addKey(UP, PRESSED)
			.addGamepad(DPAD_UP, PRESSED)
            .addGamepad(LEFT_STICK_DIGITAL_UP, PRESSED);
		isDown = new FlxActionDigital("is-down")
            .addKey(S, PRESSED)
            .addKey(DOWN, PRESSED)
			.addGamepad(DPAD_DOWN, PRESSED)
            .addGamepad(LEFT_STICK_DIGITAL_DOWN, PRESSED);

        justRight = new FlxActionDigital("just-right")
            .addKey(D, JUST_PRESSED)
            .addKey(RIGHT, JUST_PRESSED)
			.addGamepad(DPAD_RIGHT, JUST_PRESSED)
            .addGamepad(LEFT_STICK_DIGITAL_RIGHT, JUST_PRESSED);
		justLeft = new FlxActionDigital("just-left")
            .addKey(A, JUST_PRESSED)
            .addKey(LEFT, JUST_PRESSED)
			.addGamepad(DPAD_LEFT, JUST_PRESSED)
            .addGamepad(LEFT_STICK_DIGITAL_LEFT, JUST_PRESSED);
		justUp = new FlxActionDigital("just-up")
            .addKey(W, JUST_PRESSED)
            .addKey(UP, JUST_PRESSED)
			.addGamepad(DPAD_UP, JUST_PRESSED)
            .addGamepad(LEFT_STICK_DIGITAL_UP, JUST_PRESSED);
        justDown = new FlxActionDigital("just-down")
            .addKey(S, JUST_PRESSED)
            .addKey(DOWN, JUST_PRESSED)
			.addGamepad(DPAD_DOWN, JUST_PRESSED)
            .addGamepad(LEFT_STICK_DIGITAL_DOWN, JUST_PRESSED);
        justDownReleased = new FlxActionDigital("just-down-released")
            .addKey(S, JUST_RELEASED)
            .addKey(DOWN, JUST_RELEASED)
			.addGamepad(DPAD_DOWN, JUST_RELEASED)
            .addGamepad(LEFT_STICK_DIGITAL_DOWN, JUST_RELEASED);
            
		justStart = new FlxActionDigital("just-start")
            .addKey(ENTER, JUST_PRESSED)
            .addKey(SPACE, JUST_PRESSED)
			.addGamepad(START, JUST_PRESSED);
		justA = new FlxActionDigital("just-a")
            .addKey(Z, JUST_PRESSED)
            .addKey(C, JUST_PRESSED)
            .addKey(K, JUST_PRESSED)
            .addMouse(LEFT, JUST_PRESSED)
			.addGamepad(A, JUST_PRESSED)
			.addGamepad(Y, JUST_PRESSED);
		justB = new FlxActionDigital("just-b")
            .addKey(X, JUST_PRESSED)
            .addKey(J, JUST_PRESSED)
            .addKey(L, JUST_PRESSED)
            .addMouse(RIGHT, JUST_PRESSED)
			.addGamepad(B, JUST_PRESSED)
			.addGamepad(X, JUST_PRESSED);
		isA = new FlxActionDigital("is-a")
            .addKey(Z, PRESSED)
            .addKey(C, PRESSED)
            .addKey(K, PRESSED)
			.addMouse(LEFT, PRESSED)
			.addGamepad(A, PRESSED)
			.addGamepad(Y, PRESSED);
		isB = new FlxActionDigital("is-b")
            .addKey(X, PRESSED)
            .addKey(J, PRESSED)
            .addKey(L, PRESSED)
			.addMouse(RIGHT, PRESSED)
			.addGamepad(B, PRESSED)
			.addGamepad(X, PRESSED);
        justBReleased = new FlxActionDigital("just-b-released")
            .addKey(X, JUST_RELEASED)
            .addKey(J, JUST_RELEASED)
            .addKey(L, JUST_RELEASED)
            .addMouse(RIGHT, JUST_RELEASED)
			.addGamepad(B, JUST_RELEASED)
			.addGamepad(X, JUST_RELEASED);

		//
		actions = new FlxActionManager();
		actions.addActions([
			isRight, isLeft, isUp, isDown,
            justRight, justLeft, justUp, justDown, justDownReleased,
			justStart, justA, justB, isA, isB, justBReleased
		]);

        inited = true;
	}
}
