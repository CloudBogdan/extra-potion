package gui;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import gui.GuiSprite;

class GuiList<T : GuiSprite> extends FlxTypedGroup<T> {
    public var itemSize:Int;
    public var margin:Int;
    public var direction:Direction;
    public var updateOrderInDraw:Bool = true;
    
    public var x:Float = 0;
    public var y:Float = 0;
    public var offset = new FlxPoint();
    public var alpha:Float = 1;

    public function new(Direction:Direction=HORIZONTAL, ItemsSize:Int=8, Margin:Int=2) {
        super();
        
        direction = Direction;
        itemSize = ItemsSize;
        margin = Margin;
    }

    public function drawAt(X:Float, Y:Float) {
        x = X;
        y = Y;
        draw();
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (!updateOrderInDraw)
            updateOrder();
    }
    override function draw() {
        super.draw();
        
        updateAlpha();
        if (updateOrderInDraw)
            updateOrder();
    }
    function updateOrder() {
        var filteredItems = members.filter(item-> item.visible);
        for (i in 0...filteredItems.length) {
            var item = filteredItems[i];

            if (direction == HORIZONTAL) {
                item.setPosition(x + i*(itemSize + margin) + offset.x, y + offset.y);
            } else if (direction == VERTICAL) {
                item.setPosition(x + offset.x, y + i*(itemSize + margin) + offset.y);
            }
        }
    }
    function updateAlpha() {
        forEach(c-> c.setAlpha(alpha));
    }
}