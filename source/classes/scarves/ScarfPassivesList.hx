package classes.scarves;

import classes.events.Trigger;
import classes.passives.PassiveItem;
import classes.passives.actions.ActionPassiveItem;
import classes.passives.conditions.ConditionPassiveItem;
import classes.passives.modifiers.ModifierPassiveItem;
import classes.slots.Slot;
import flixel.FlxG;
import flixel.util.FlxTimer;
import objects.entities.Entity;

class ScarfPassivesList {
    public static final COOLDOWN_DURATION:Float = 2;
    
    public var parent:Scarf;
    
    public final withCondition:Bool;
    public final withModifier:Bool;

    public var conditionSlot:Slot<ConditionPassiveItem>;
    public var modifierSlot:Slot<ModifierPassiveItem>;
    public var actionSlot:Slot<ActionPassiveItem>;

    public final cooldownTimer = new FlxTimer();

    public final onEquipped = new Trigger<PassiveItem>("scarf-passives-list/on-equipped");
    public final onUnequipped = new Trigger<PassiveItem>("scarf-passives-list/on-unequipped");
    
    public function new(Parent:Scarf, WithCondition:Bool, WithModifier:Bool) {
        parent = Parent;
        withCondition = WithCondition;
        withModifier = WithModifier;

        conditionSlot = new Slot(parent.owner, "condition-slot");
        modifierSlot = new Slot(parent.owner, "modifiers-slot");
        actionSlot = new Slot(parent.owner, "action-slot");

        cooldownTimer.finished = true;

        onEquipped.listen(item-> {
            FlxG.sound.play(AssetPaths.equip__wav);
        });
        onUnequipped.listen(item-> {
            parent.owner.inventory.add(item);
        });
    }

    public function update() {
        if (conditionSlot.equippedItem != null)
            conditionSlot.equippedItem.update();
        if (modifierSlot.equippedItem != null)
            modifierSlot.equippedItem.update();
        if (actionSlot.equippedItem != null)
            actionSlot.equippedItem.update();

        if (actionSlot.getIsEquipped() && !withCondition) {
            cooldownTimer.active = actionSlot.equippedItem.getAllowUse();

            if (cooldownTimer.finished) {
                executeAction(null);
                cooldownTimer.start(COOLDOWN_DURATION);
            }
        }
    }

    //
    public function executeAction(targetEntity:Null<Entity>):Bool {
        if (!parent.isEquipped) return false;
        var actionItem = actionSlot.equippedItem;
        if (actionItem == null) return false;
        
        if (withModifier) {
            var modifierItem = modifierSlot.equippedItem;
            if (modifierItem != null)
                modifierItem.apply(actionItem);
        }
        
        actionItem.execute(targetEntity);
        actionItem.resetScales();
        return true;
    }

    //
    public function equipConditionItem(item:ConditionPassiveItem):Bool {
        if (!withCondition || !Std.isOfType(item, ConditionPassiveItem)) return false;
        var result = conditionSlot.equip(item);
        if (result)
            item.parent = this;

        onEquipped.trigger(item);
        return result;
    }
    public function unequipConditionItem():Bool {
        if (!withCondition) return false;
        if (conditionSlot.equippedItem != null)
            conditionSlot.equippedItem.parent = null;

        onUnequipped.trigger(conditionSlot.equippedItem);
        return conditionSlot.unequip();
    }
    
    public function equipModifierItem(item:ModifierPassiveItem):Bool {
        if (!withModifier || !Std.isOfType(item, ModifierPassiveItem)) return false;
        var result = modifierSlot.equip(item);
        if (result)
            item.parent = this;

        onEquipped.trigger(item);
        return result;
    }
    public function unequipModifierItem():Bool {
        if (!withModifier) return false;
        if (modifierSlot.equippedItem != null)
            modifierSlot.equippedItem.parent = null;

        onUnequipped.trigger(modifierSlot.equippedItem);
        return modifierSlot.unequip();
    }

    public function equipActionItem(item:ActionPassiveItem):Bool {
        if (!Std.isOfType(item, ActionPassiveItem)) return false;
        var result = actionSlot.equip(item);
        if (result)
            item.parent = this;

        onEquipped.trigger(item);
        return result;
    }
    public function unequipActionItem():Bool {
        if (actionSlot.equippedItem != null)
            actionSlot.equippedItem.parent = null;
        
        onUnequipped.trigger(actionSlot.equippedItem);
        return actionSlot.unequip();
    }
}