package classes.components.player;

import classes.events.Trigger;
import classes.scarves.CyanScarf;
import classes.scarves.GreenScarf;
import classes.scarves.OrangeScarf;
import classes.scarves.Scarf;
import flixel.FlxSprite;
import objects.entities.Player;

class ScarvesComponent extends PlayerComponent {
    public static final NAME:String = "scarves";
    
    public var equipped:Scarf;
    public var list:Array<Scarf> = [];

    public final scarfOverlay:FlxSprite;

    public final onEquipped = new Trigger<Scarf>("scarves-component/on-equipped");
    public final onAdded = new Trigger<Scarf>("scarves-component/on-added");
    
    public function new(Parent:Player) {
        super(Parent, NAME);

        list = [
            new CyanScarf(parent),
            new OrangeScarf(parent),
            new GreenScarf(parent),
        ];

        scarfOverlay = new FlxSprite();
        scarfOverlay.pixelPerfectPosition = true;

        equip(list[0]);
    }

    public function add(scarf:Scarf):Bool {
        if (has(scarf.name)) return false;

        list.push(scarf);
        onAdded.trigger(scarf);
        return true;
    }
    public function equip(scarf:Scarf):Bool {
        if (scarf == null) return false;
        if (equipped != null && equipped.name == scarf.name) return false;
        if (equipped != null)
            equipped.onUnequip();
        equipped = scarf;
        equipped.onEquip();

        onEquipped.trigger(scarf);
        loadScarfOverlay();
        return true;
    }
    public function has(name:String):Bool {
        return list.filter(s-> s.name == name).length > 0;
    }

    //
    public function update(elapsed:Float) {
        equipped.update(elapsed);
        
        scarfOverlay.update(elapsed);
    }
    public function draw() {
        scarfOverlay.setPosition(parent.x, parent.y);
        scarfOverlay.flipX = parent.flipX;
        scarfOverlay.flipY = parent.flipY;
        scarfOverlay.animation.frameIndex = parent.animation.frameIndex;
        scarfOverlay.setSize(parent.width, parent.height);
        scarfOverlay.offset.copyFrom(parent.offset);
        scarfOverlay.draw();
    }
    public function loadScarfOverlay() {
        scarfOverlay.loadGraphic('assets/images/entities/player-${ equipped.name }-scarf-overlay.png', true, parent.frameWidth, parent.frameHeight);
    }
}