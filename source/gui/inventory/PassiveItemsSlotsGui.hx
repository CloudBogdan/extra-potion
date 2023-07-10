package gui.inventory;

import classes.passives.actions.ActionPassiveItem;
import classes.passives.conditions.ConditionPassiveItem;
import classes.passives.modifiers.ModifierPassiveItem;
import classes.scarves.ScarfPassivesList;
import flixel.FlxSprite;
import flixel.math.FlxRect;
import utils.Palette;

class PassiveItemsSlotsGui extends GuiList<PassiveItemButtonGui> {
    public var passivesList:ScarfPassivesList;

    final itemSlotSprite:GuiSprite;
    final cooldownBarSprite:GuiSprite;
    final cooldownBarProgressSprite:GuiSprite;
    
    public function new(PassivesList:ScarfPassivesList) {
        super(VERTICAL, 18, 0);

        passivesList = PassivesList;
        updateOrderInDraw = false;

        //
        itemSlotSprite = new GuiSprite(0, 0, AssetPaths.passive_items_slots__png, true, 18, 18);
        cooldownBarSprite = new GuiSprite(0, 0, AssetPaths.passives_list_cooldown_bar__png);
        cooldownBarProgressSprite = new GuiSprite();
        cooldownBarProgressSprite.makeGraphic(16, 2, Palette.CYAN_2);
        cooldownBarProgressSprite.clipRect = new FlxRect(0, 0, cooldownBarProgressSprite.width, cooldownBarProgressSprite.height);
        
        //
        if (passivesList.conditionSlot.equippedItem != null)
            add(new PassiveItemButtonGui(passivesList.conditionSlot.equippedItem));
        if (passivesList.modifierSlot.equippedItem != null)
            add(new PassiveItemButtonGui(passivesList.modifierSlot.equippedItem));
        if (passivesList.actionSlot.equippedItem != null)
            add(new PassiveItemButtonGui(passivesList.actionSlot.equippedItem));
        
        passivesList.onEquipped.listen(item-> {
            add(new PassiveItemButtonGui(item));
        });
        passivesList.onUnequipped.listen(item-> {
            remove(members.filter(b-> b.item == item)[0], true);
        });
    }

    override function draw() {
        drawSlots();
        
        super.draw();
    }
    override function updateOrder() {
        if (passivesList.withCondition && passivesList.withModifier) {
            for (button in members) {
                if (Std.isOfType(button.item, ConditionPassiveItem))
                    button.setPosition(x, y);
                else if (Std.isOfType(button.item, ModifierPassiveItem))
                    button.setPosition(x, y + itemSize);
                else if (Std.isOfType(button.item, ActionPassiveItem))
                    button.setPosition(x, y + itemSize*2);
            }
        } else if (passivesList.withCondition) {
            for (button in members) {
                if (Std.isOfType(button.item, ConditionPassiveItem))
                    button.setPosition(x, y);
                else if (Std.isOfType(button.item, ActionPassiveItem))
                    button.setPosition(x, y + itemSize);
            }
        } else if (passivesList.withModifier) {
            for (button in members) {
                if (Std.isOfType(button.item, ModifierPassiveItem))
                    button.setPosition(x, y);
                else if (Std.isOfType(button.item, ActionPassiveItem))
                    button.setPosition(x, y + itemSize);
            }
        } else {
            for (button in members) {
                if (Std.isOfType(button.item, ActionPassiveItem))
                    button.setPosition(x, y);
            }
        }
    }
    function drawSlots() {
        cooldownBarProgressSprite.setClipRectSize(
            Math.floor(passivesList.cooldownTimer.progress * cooldownBarProgressSprite.width)
        );
        
        if (passivesList.withCondition && passivesList.withModifier) {
            drawSlot(0, 0);
            drawSlot(1, itemSize);
            drawSlot(2, itemSize*2);
        } else if (passivesList.withCondition && !passivesList.withModifier) {
            drawSlot(0, 0);
            drawSlot(2, itemSize);
        } else if (passivesList.withModifier && !passivesList.withCondition) {
            drawSlot(1, 0);
            drawSlot(2, itemSize);
            cooldownBarSprite.drawAt(x, y + itemSize*2);
            cooldownBarProgressSprite.drawAt(x+1, y + itemSize*2+1);
        } else {
            drawSlot(2, 0);
            cooldownBarSprite.drawAt(x, y + itemSize);
            cooldownBarProgressSprite.drawAt(x+1, y + itemSize+1);
        }
    }

    function drawSlot(frame:Int, offsetY:Float=0) {
        if (frame == 0)
            if (passivesList.conditionSlot.getIsEquipped()) return;
        if (frame == 1)
            if (passivesList.modifierSlot.getIsEquipped()) return;
        if (frame == 2)
            if (passivesList.actionSlot.getIsEquipped()) return;
        
        itemSlotSprite.alpha = alpha;
        itemSlotSprite.animation.frameIndex = frame;
        itemSlotSprite.drawAt(x, y+offsetY);
    }
}