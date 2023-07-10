package classes.passives.conditions;

import flixel.FlxG;
import objects.entities.Entity;


class ConditionPassiveItem extends PassiveItem {
    public function new(Name:String) {
        super(Name);

        pathToSprite = 'assets/images/passives/conditions/$name-condition.png';
    }

    override function execute(targetEntity:Null<Entity>):Bool {
        var result = super.execute(targetEntity);
        if (!result) return false;
        
        return parent.executeAction(targetEntity);
    }
}