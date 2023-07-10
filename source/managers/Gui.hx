package managers;

import gui.inventory.InventoryGui;

class Gui {
    public static var inventory:InventoryGui;

    public static function init() {
        inventory = new InventoryGui();
        inventory.setup();
    }
    
    public static function update(elapsed:Float) {
        inventory.update(elapsed);
    }
    public static function draw() {
        inventory.draw();
    }
}