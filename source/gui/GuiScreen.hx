package gui;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

class GuiScreen extends FlxTypedGroup<FlxSprite> {
    public var isVisible:Bool = true;
    
    public function new() {
        super();
    }

    public function setup() {
        forEach(sprite-> sprite.scrollFactor.set(0, 0));
    }

    public function toggle() {
        if (isVisible)
            hide();
        else
            show();
    }
    public function show() {
        isVisible = true;
    }
    public function hide() {
        isVisible = false;
    }
}