package classes.components.player;

import objects.entities.Player;

class PlayerComponent extends Component {
    public var parent:Player;
    
    public function new(Parent:Player, Name:String) {
        super(Name);
        
        parent = Parent;
    }
}