package classes.misc;

class PressProgress {
    public var duration:Float = 0;
    public var time:Float = 0;
    
    public function new(Duration:Float) {
        duration = Duration;
    }

    public function press(elapsed:Float) {
        time += elapsed;
    }
    public function cancel() {
        time = 0;
    }
    
    // Get
    public function getIsFinished():Bool {
        return getProgress() >= 1;
    }
    public function getProgress():Float {
        return time / duration;
    }
}