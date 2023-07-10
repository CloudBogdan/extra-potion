package objects;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import openfl.display.BlendMode;
import utils.Config;
import utils.Palette;

class MyText extends FlxObject {
    public var text:String;
    public var color:Int = Palette.ABSOLUTE_WHITE;
    public var offset:FlxPoint = new FlxPoint();
    public var alpha:Float = 1;
    public var blend:BlendMode = NORMAL;

    var charSprite:FlxSprite;
    
    public function new(Text:String="", X:Float=0, Y:Float=0) {
        super(X, Y);
        
        text = Text;

        charSprite = new FlxSprite();
        charSprite.loadGraphic(AssetPaths.my_font__png, true, Config.CHAR_WIDTH, Config.CHAR_HEIGHT);
        charSprite.pixelPerfectPosition = true;

        updateSize();
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        updateSize();
    }
    public function updateSize() {
        setSize(text.length * Config.CHAR_WIDTH, Config.CHAR_HEIGHT);
    }
    
    override function draw() {
        super.draw();

        charSprite.color = color;
        charSprite.alpha = alpha;
        charSprite.blend = blend;
        
        for (charIndex in 0...text.length) {
            var char = text.charAt(charIndex);
            var charMapIndex = Config.FONT_MAP.indexOf(char.toLowerCase());
            if (charMapIndex < 0) continue;

            charSprite.setPosition(
                x - offset.x + charIndex*Config.CHAR_WIDTH,
                y - offset.y,
            );
            charSprite.animation.frameIndex = charMapIndex;
            charSprite.draw();
        }
    }
}