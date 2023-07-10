package;

import flixel.FlxState;
import managers.Game;

class PlayState extends FlxState {
	override public function update(elapsed:Float) {
		super.update(elapsed);

		Game.update(elapsed);
	}
	override function draw() {
		super.draw();

		Game.draw();
	}
}
