package gui;

import flixel.FlxSprite;
import flixel.math.FlxRect;
import flixel.system.FlxAssets.FlxGraphicAsset;

class GuiSprite extends FlxSprite {
    public function new(X:Float=0, Y:Float=0, ?Graphic:FlxGraphicAsset, Animated:Bool=false, ?Width:Int, ?Height:Int) {
        super(X, Y);

        if (Graphic != null) {
            loadGraphic(Graphic, Animated, Width, Height);
            clipRect = new FlxRect(0, 0, width, height);
        }

        scrollFactor.set(0, 0);
        pixelPerfectPosition = true;
    }

    public function setClipRectSize(?Width:Int, ?Height:Int) {
        if (clipRect == null) return;
        
        if (Width != null)
            clipRect.width = Width;
        if (Height != null)
            clipRect.height = Height;

        resetFrame();
    }
    public function drawAt(X:Float, Y:Float, FlipX:Bool=false, FlipY:Bool=false) {
        flipX = FlipX;
        flipY = FlipY;
        setPosition(X, Y);
        draw();
    }

    //
    public function setAlpha(value:Float) {
        alpha = value;
    }
}