package stages;

import flixel.FlxG;
import flixel.FlxSprite;
import managers.Gamepad;
import objects.MyText;
import objects.misc.Background;
import utils.Animations;
import utils.Palette;

class WelcomeStage extends SampleStage {
    var time:Float = 0;
    
    var background:Background;
    var logoSprite:FlxSprite;
    var byBogdanovSprite:FlxSprite;
    var pressText:MyText;
    
    override function create() {
        super.create();

        background = new Background(false);
        background.flicker();
        background.bgShader.setHidden(false);

        logoSprite = new FlxSprite();
        logoSprite.loadGraphic(AssetPaths.logo__png, true, 80, 58); // 9
        logoSprite.offset.set(logoSprite.width/2, logoSprite.height/2);
        logoSprite.setPosition(FlxG.width/2, FlxG.height/2 - 16);
        logoSprite.animation.add("default", [0,0,0,0,0,0,0,1,2,3,4,5,6,7,8], 14, true);
        logoSprite.animation.play("default");

        byBogdanovSprite = new FlxSprite();
        byBogdanovSprite.loadGraphic(AssetPaths.by_bogdanov__png);
        byBogdanovSprite.offset.set(byBogdanovSprite.width/2, byBogdanovSprite.height);
        byBogdanovSprite.setPosition(FlxG.width/2, FlxG.height - 4);
        byBogdanovSprite.alpha = .6;

        pressText = new MyText("press start");
        pressText.offset.set(pressText.width/2, pressText.height/2);
        pressText.setPosition(FlxG.width/2, FlxG.height/2 + 24);
        pressText.alpha = .8;
        
        add(background);
        add(logoSprite);
        add(byBogdanovSprite);
        add(pressText);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        time ++;

        if (Gamepad.justStart.triggered) {
            FlxG.switchState(new RandomStage());
        }
    }
}