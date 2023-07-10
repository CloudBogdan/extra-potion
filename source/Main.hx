package;

import flixel.FlxGame;
import openfl.display.Sprite;
import stages.WelcomeStage;
import utils.Config;

class Main extends Sprite {
	public function new() {
		super();
		
		addChild(new FlxGame(Config.CANVAS_WIDTH, Config.CANVAS_HEIGHT, WelcomeStage));
	}
}
