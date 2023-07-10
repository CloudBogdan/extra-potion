package classes.components.player;

import classes.events.Trigger;
import classes.passives.PassiveItem;
import classes.passives.actions.ActionPassiveItem;
import classes.passives.actions.HealActionItem;
import classes.passives.actions.PushActionItem;
import classes.passives.actions.ShootBulletActionItem;
import classes.passives.actions.SpawnBackShieldActionItem;
import classes.passives.actions.TeleportActionItem;
import classes.passives.actions.ThrowFlameBallActionItem;
import classes.passives.actions.ThrowFreezingFlakeActionItem;
import classes.passives.conditions.ConditionPassiveItem;
import classes.passives.conditions.DeflectProjectileConditionItem;
import classes.passives.conditions.GotHitConditionItem;
import classes.passives.conditions.HitEntityConditionItem;
import classes.passives.conditions.JumpConditionItem;
import classes.passives.conditions.KillEntityConditionItem;
import classes.passives.modifiers.DoubleDamageModifierItem;
import classes.passives.modifiers.DoubleKnockbackModifierItem;
import classes.passives.modifiers.HalfActionCooldownModifierItem;
import classes.passives.modifiers.ModifierPassiveItem;
import objects.entities.Player;

class InventoryComponent extends PlayerComponent {
    public static final NAME:String = "inventory";
    
    public var items:Array<PassiveItem> = [
        new GotHitConditionItem(),
        new HitEntityConditionItem(),
        new KillEntityConditionItem(),
        new JumpConditionItem(),
        new DeflectProjectileConditionItem(),

        new DoubleDamageModifierItem(),
        new DoubleKnockbackModifierItem(),
        new HalfActionCooldownModifierItem(),

        new ThrowFreezingFlakeActionItem(),  
        new HealActionItem(),
        new SpawnBackShieldActionItem(),
        new PushActionItem(),
        new TeleportActionItem(),
        new ThrowFlameBallActionItem(),
        new ShootBulletActionItem()
    ];

    public final onAdded = new Trigger<PassiveItem>("inventory/on-added");
    public final onRemoved = new Trigger<PassiveItem>("inventory/on-removed");
    
    public function new(Parent:Player) {
        super(Parent, NAME);
    }

    public function add(item:PassiveItem, index:Int=1):Bool {
        if (index < 1)
            index = items.length;
        
        items.insert(index, item);
        onAdded.trigger(item);
        return true;
    }
    public function remove(item:PassiveItem):Bool {
        var index = items.indexOf(item);
        if (index < 0) return false;
        
        items.splice(index, 1);
        onRemoved.trigger(item);
        return true;
    }
    public function has(item:PassiveItem):Bool {
        return items.indexOf(item) >= 0;
    }

    public function equipItemToScarf(item:PassiveItem):Bool {
        var scarf = parent.scarves.equipped;
        if (scarf == null || !has(item)) return false;
        var anyItem:Dynamic = item;
        var result:Bool = false;

        for (list in scarf.passivesLists) {

            if (list.withCondition && Std.isOfType(anyItem, ConditionPassiveItem)) {
                if (!list.conditionSlot.getIsEquipped()) {
                    var success = list.equipConditionItem(anyItem);
                    if (success) {
                        result = true;
                        break;
                    }
                }
            }
            if (list.withModifier && Std.isOfType(anyItem, ModifierPassiveItem)) {
                if (!list.modifierSlot.getIsEquipped()) {
                    var success = list.equipModifierItem(anyItem);
                    if (success) {
                        result = true;
                        break;
                    }
                }
            }
            if (Std.isOfType(anyItem, ActionPassiveItem)) {
                if (!list.actionSlot.getIsEquipped()) {
                    var success = list.equipActionItem(anyItem);
                    if (success) {
                        result = true;
                        break;
                    }
                }
            }
            
        }

        if (result)
            remove(item);
        
        return result;
    }
}