package shaders;

import flixel.system.FlxAssets.FlxShader;

class DarkenShader extends FlxShader {
    @:glFragmentSource("
        #pragma header

        uniform float uFactor = 0.0;

        void main() {
            vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);

            gl_FragColor = mix(color, vec4(0.0, 0.0, 0.0, color.a), uFactor);
        }
    ")

    public function new() {
        super();

        uFactor.value = [0];
    }

    public function setFactor(value:Float) {
        uFactor.value = [value];
    }
}