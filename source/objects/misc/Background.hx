package objects.misc;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.tweens.FlxTween;
import flixel.tweens.misc.NumTween;
import managers.Game;
import managers.Objects;
import shaders.BackgroundShader;
import utils.Palette;

class Background extends FlxSprite {
    var time:Float = 0;
    var listenPlayer:Bool;
    
    public var bgShader:BackgroundShader;
    var tween:Null<NumTween> = null;
    
    public function new(ListenPlayer:Bool=true) {
        super();

        listenPlayer = ListenPlayer;

        makeGraphic(FlxG.width, FlxG.height, Palette.FULL_WHITE);
        scrollFactor.set(0, 0);

        bgShader = new BackgroundShader();
        shader = bgShader;

        if (ListenPlayer) {
            var player = Objects.player;
            player.opiate.onBoostStart.listen(a-> {
                flicker();
                bgShader.setHidden(false);
            });
            player.opiate.onBoostEnd.listen(forceStopped-> {
                if (forceStopped)
                    flicker();
                
                bgShader.setHidden(true);
            });
            player.onKillEntity.listen(entity-> {
                if (!player.opiate.getIsBoosted()) return;
                
                flicker(.2);
            });
        }
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        time ++;

        bgShader.setTime(time);

        if (listenPlayer) {
            bgShader.setPlayerScreenX(Objects.player.x + Objects.player.width/2 - FlxG.camera.scroll.x);
            bgShader.setPlayerScreenY(Objects.player.y + Objects.player.height/2 - FlxG.camera.scroll.y);

            bgShader.setIntensity(FlxMath.bound(Objects.player.opiate.boostFrameTime / 200, 0, 1));
        } else {
            bgShader.setPlayerScreenX(-300);
            bgShader.setPlayerScreenY(-300);
        }
    }

    //
    public function flicker(factor:Float=1) {
        if (tween != null) {
            tween.cancel();
        }

        tween = FlxTween.num(
            factor, 0, .4,
            { startDelay: .1, onUpdate: t-> time ++ },
            v-> bgShader.setLightnessFactor(v)
        );
    }
}