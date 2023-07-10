package classes.components.entities;

import objects.entities.Entity;

class EntityComponent extends Component {
    public var parent:Entity;
    
    public function new(Parent:Entity, Name:String) {
        super(Name);

        parent = Parent;
    }
}