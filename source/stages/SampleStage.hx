package stages;

import flixel.FlxG;
import flixel.FlxState;
import managers.Game;
import managers.Gamepad;
import openfl.filters.ShaderFilter;
import shaders.ColorClampScreenShader;
import utils.Config;

class SampleStage extends FlxState {
    override function create() {
        super.create();

        Game.initMusic();
        
        var shader = new ColorClampScreenShader();
		FlxG.camera.setFilters([new ShaderFilter(cast shader)]);

		FlxG.mouse.useSystemCursor = true;
		FlxG.worldBounds.set(0, 0, Config.CANVAS_WIDTH, Config.CANVAS_HEIGHT);

        FlxG.inputs.remove(Gamepad.actions);
        Gamepad.init();
        FlxG.inputs.add(Gamepad.actions);
    }
}