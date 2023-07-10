package classes.scarves;

import objects.entities.Player;

class OrangeScarf extends Scarf {
    public static final NAME:String = "orange";
    
    public function new(Owner:Player) {
        super(Owner, NAME);

        passivesLists = [
            new ScarfPassivesList(this, true, false),
            new ScarfPassivesList(this, true, false),
            new ScarfPassivesList(this, false, false),
        ];
    }
}