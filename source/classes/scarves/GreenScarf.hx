package classes.scarves;

import objects.entities.Player;

class GreenScarf extends Scarf {
    public static final NAME:String = "green";
    
    public function new(Owner:Player) {
        super(Owner, NAME);

        passivesLists = [
            new ScarfPassivesList(this, true, false),
            new ScarfPassivesList(this, false, true),
            new ScarfPassivesList(this, false, false),
        ];
    }
}