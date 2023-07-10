package gui.inventory;

import classes.passives.PassiveItem;
import flixel.FlxSprite;
import flixel.math.FlxRect;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.tweens.misc.NumTween;
import utils.Palette;

class PassiveItemButtonGui extends GuiSprite {
    public var item:PassiveItem;

    public var isSelected:Bool = false;
    public var isVisible:Bool = true;
    var wasVisible:Bool = true;
    var animatedAlpha:Float = 1;

    var alphaTween:Null<NumTween> = null;
    
    final cooldownSprite:FlxSprite;
    final selectedSprite:GuiSprite;
    
    public function new(Item:PassiveItem) {
        super();

        item = Item;

        cooldownSprite = new FlxSprite();
        cooldownSprite.makeGraphic(16, 1, Palette.WHITE);
        cooldownSprite.scrollFactor.set(0, 0);
        cooldownSprite.clipRect = new FlxRect(0, 0, cooldownSprite.width, cooldownSprite.height);

        selectedSprite = new GuiSprite(0, 0, AssetPaths.selected_18x18__png);
        
        //
        loadGraphic(item.pathToSprite);
    }

    override function draw() {
        super.draw();

        if (item.cooldownDuration > 0) {
            cooldownSprite.setPosition(x+1, y+height-2);
            cooldownSprite.alpha = alpha;
            
            var clipRectWidth = 0;
            if (!item.isUsing)
                clipRectWidth = Math.floor(item.getCooldownProgress() * cooldownSprite.width);
            
            cooldownSprite.clipRect.width = clipRectWidth;
            cooldownSprite.resetFrame();
            cooldownSprite.draw();
        }
        
        selectedSprite.alpha = alpha;
        selectedSprite.setPosition(x-2, y-2);
        if (isSelected) {
            selectedSprite.draw();
        }
    }

    //
    public function setIsVisible(value:Bool, animate:Bool=false) {
        isVisible = value;
        if (wasVisible != isVisible) {
            if (animate)
                tweenAlpha(isVisible ? 1 : 0);
            else 
                animatedAlpha = isVisible ? 1 : 0;
            
            wasVisible = isVisible;
        }
    }
    public function tweenAlpha(value:Float) {
        if (alphaTween != null) {
            alphaTween.cancel();
        }
        
        alphaTween = FlxTween.num(animatedAlpha, value, .1, { ease: FlxEase.linear }, v-> animatedAlpha = v);
    }
    override function setAlpha(value:Float) {
        alpha = value - (1 - animatedAlpha);
    }
}