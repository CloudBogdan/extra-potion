package gui.inventory;

import classes.scarves.Scarf;

class ScarfButtonGui extends GuiSprite {
    public var scarf:Scarf;

    final selectedSprite:GuiSprite;
    
    public function new(Scarf:Scarf) {
        super();

        scarf = Scarf;

        //
        loadGraphic('assets/images/scarves/${ scarf.name }-scarf.png');
        selectedSprite = new GuiSprite(0, 0, AssetPaths.selected_18x18__png);
    }

    override function draw() {
        super.draw();

        selectedSprite.alpha = alpha;
        selectedSprite.setPosition(x-2, y-2);
        if (getIsSelected())
            selectedSprite.draw();
    }

    public function getIsSelected():Bool {
        if (scarf.owner == null) return false;
        return scarf.owner.scarves.equipped == scarf;
    }
}