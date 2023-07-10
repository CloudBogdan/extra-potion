package stages;

import flixel.FlxG;
import managers.Gamepad;
import managers.Score;
import objects.MyText;
import utils.Palette;

class GameOverStage extends SampleStage {
    var gameOverText:MyText;
    var scoreText:MyText;
    var pressText:MyText;
    
    override function create() {
        super.create();

        gameOverText = new MyText("game over");
        gameOverText.offset.x = gameOverText.width/2;
        gameOverText.setPosition(FlxG.width/2, FlxG.height/2 - 14);
        
        scoreText = new MyText("score " + Score.score);
        scoreText.offset.x = scoreText.width/2;
        scoreText.setPosition(FlxG.width/2, FlxG.height/2 - 5);

        pressText = new MyText("press start");
        pressText.color = Palette.GRAY;
        pressText.offset.x = pressText.width/2;
        pressText.setPosition(FlxG.width/2, FlxG.height/2 + 8);

        add(gameOverText);
        add(scoreText);
        add(pressText);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (Gamepad.justStart.triggered) {
            Score.reset();
            FlxG.switchState(new RandomStage());
        }
    }
}