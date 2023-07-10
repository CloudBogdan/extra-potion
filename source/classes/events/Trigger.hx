package classes.events;

typedef TriggerListener<T> = (args:T)-> Void;

class Trigger<T> {
    static var _listenerKey:Int = 0;
    
    public var name:String;
    
    public var listeners:Map<String, TriggerListener<T>> = [];

    public function new(Name:String) {
        name = Name;
    }
    
    public function listen(listener:TriggerListener<T>, ?key:String):()->Void {
        if (key == null) {
            _listenerKey ++;
            key = Std.string(_listenerKey);
        }
        
        listeners.set(key, listener);

        return ()-> unlisten(key);
    }
    public function unlisten(key:String) {
        listeners.remove(key);
    }
    public function unlistenAll() {
        listeners = [];
    }

    public function trigger(args:T) {
        for (listener in listeners) {
            listener(args);
        }
    }
}