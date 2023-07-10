package shaders;

import flixel.system.FlxAssets.FlxShader;
import utils.Config;

class BackgroundShader extends FlxShader {
    @:glFragmentSource("
        #pragma header

        uniform bool uHidden = true;
        uniform float uTime = 0.0;
        uniform float uLightnessFactor = 0.0;
        uniform float uIntensity = 1.0;
        uniform float uPlayerScreenX = 0.0;
        uniform float uPlayerScreenY = 0.0;
        uniform float uScreenWidth = 128.0;
        uniform float uScreenHeight = 128.0;
    
        //
        float hue2rgb(float f1, float f2, float hue) {
            if (hue < 0.0)
                hue += 1.0;
            else if (hue > 1.0)
                hue -= 1.0;
            float res = 0.0;
            if ((6.0 * hue) < 1.0)
                res = f1 + (f2 - f1) * 6.0 * hue;
            else if ((2.0 * hue) < 1.0)
                res = f2;
            else if ((3.0 * hue) < 2.0)
                res = f1 + (f2 - f1) * ((2.0 / 3.0) - hue) * 6.0;
            else
                res = f1;
            return res;
        }
        
        vec3 hsl2rgb(vec3 hsl) {
            vec3 rgb = vec3(0.0, 0.0, 0.0);
            
            if (hsl.y == 0.0) {
                rgb = vec3(hsl.z);
            } else {
                float f2;
                
                if (hsl.z < 0.5)
                    f2 = hsl.z * (1.0 + hsl.y);
                else
                    f2 = hsl.z + hsl.y - hsl.y * hsl.z;
                    
                float f1 = 2.0 * hsl.z - f2;
                
                rgb.r = hue2rgb(f1, f2, hsl.x + (1.0/3.0));
                rgb.g = hue2rgb(f1, f2, hsl.x);
                rgb.b = hue2rgb(f1, f2, hsl.x - (1.0/3.0));
            }   
            return rgb;
        }
        
        void main() {
            vec2 coords = vec2(openfl_TextureCoordv);
            
            vec4 rgba = vec4(0.0,0.0,0.0, 0.0);
            
            if (!uHidden) {
                float aspect = uScreenHeight / uScreenWidth;
                vec2 playerPos = vec2(uPlayerScreenX/uScreenWidth, uPlayerScreenY/uScreenHeight);

                float a = (sin(coords.x / aspect) + 1) / 2;
                float b = (cos(coords.y) + 1) / 2;
                float hue = (a + b) * 360;
                vec3 rgb = hsl2rgb(vec3(mod(hue + uTime / 3.0, 360)/360, 1.0, 0.5));

                rgb *= vec3(smoothstep(0.5, 1.0, distance(playerPos / vec2(aspect, 1.0), coords / vec2(aspect, 1.0)) * 4.0));
                rgb *= uIntensity;

                rgba = vec4(rgb, 1.0);
            }
            
            gl_FragColor = vec4(rgba.r+uLightnessFactor, rgba.g+uLightnessFactor, rgba.b+uLightnessFactor, rgba.a);
        }
    ")

    public function new() {
        super();

        uScreenWidth.value = [Config.CANVAS_WIDTH];
        uScreenHeight.value = [Config.CANVAS_HEIGHT];
    }

    public function setTime(value:Float) {
        uTime.value = [value];
    }
    public function setPlayerScreenX(value:Float) {
        uPlayerScreenX.value = [value];
    }
    public function setPlayerScreenY(value:Float) {
        uPlayerScreenY.value = [value];
    }
    public function setLightnessFactor(value:Float) {
        uLightnessFactor.value = [value];
    }
    public function setHidden(value:Bool) {
        uHidden.value = [value];
    }
    public function setIntensity(value:Float) {
        uIntensity.value = [value];
    }
}