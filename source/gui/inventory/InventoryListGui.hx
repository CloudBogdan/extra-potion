package gui.inventory;

import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.tweens.misc.NumTween;
import managers.Gamepad;
import managers.Gui;
import objects.entities.Player;

class InventoryListGui extends GuiList<PassiveItemButtonGui> {
    public var player:Player;

    var selectedButtonIndex:Int = 0;
    var queryOffsetTween:Bool = false;
    var offsetTween:Null<NumTween> = null;
    
    public function new(Player:Player) {
        super(VERTICAL, 18, 3);

        player = Player;

        //
        for (item in player.inventory.items) {
            add(new PassiveItemButtonGui(item));
        }

        player.inventory.onAdded.listen(item-> {
            add(new PassiveItemButtonGui(item));
        });
        player.inventory.onRemoved.listen(item-> {
            remove(members.filter(b-> b.item.name == item.name)[0], true);
            queryOffsetTween = true;
        });

        //
        tweenOffset();
    }

    function tweenOffset() {
        if (offsetTween != null) {
            offsetTween.cancel();
        }
        
        var targetValue = -selectedButtonIndex * (itemSize+margin) + (itemSize+margin)*2;
        offsetTween = FlxTween.num(offset.y, targetValue, .1, { ease: FlxEase.linear }, v-> offset.y = v);
    }
    
    //
    override function update(elapsed:Float) {
        super.update(elapsed);

        updateEquipping();
        updateSelectingButton();
        updateButtons();

        updateOrder();

        if (queryOffsetTween)
            tweenOffset();
        queryOffsetTween = false;
    }

    function updateEquipping() {
        if (!Gui.inventory.isVisible) return;

        // Equip passive item
        if (Gamepad.justA.triggered) {
            var button = members[selectedButtonIndex];
            if (button == null) return;
            var item = button.item;

            player.inventory.equipItemToScarf(item);
        }
        // Unequip passive item
        if (Gamepad.justB.triggered) {
            var scarf = player.scarves.equipped;
            if (scarf == null) return;

            scarf.unequipPassiveItem();
        }
    }
    function updateSelectingButton() {
        if (!Gui.inventory.isVisible) return;
        
        if (Gamepad.justUp.triggered) {
            selectedButtonIndex --;
            tweenOffset();
        } else if (Gamepad.justDown.triggered) {
            selectedButtonIndex ++;
        }
        
        selectedButtonIndex = Std.int(FlxMath.bound(selectedButtonIndex, 0, length-1));

        if (Gamepad.justDown.triggered || Gamepad.justUp.triggered) {
            queryOffsetTween = true;
        }
    }
    function updateButtons() {
        for (buttonIndex in 0...members.length) {
            var button = members[buttonIndex];
            if (button != null)
                button.isSelected = selectedButtonIndex == buttonIndex;
        }
    }
}