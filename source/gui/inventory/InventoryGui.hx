package gui.inventory;

import classes.passives.PassiveItem;
import classes.scarves.Scarf;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxFrame;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxRect;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.tweens.misc.VarTween;
import managers.Game;
import managers.Gamepad;
import managers.Objects;
import objects.MyText;
import objects.entities.Player;
import openfl.geom.Matrix;
import utils.Animations;
import utils.Config;
import utils.Palette;

class InventoryGui extends GuiScreen {
    var player:Player;
    var alpha:Float = 0;
    var tween:Null<VarTween> = null;
    
    var background:FlxSprite;
    var playerSprite:GuiSprite;
    var healthBar:GuiSprite;
    var healthBarProgress:GuiSprite;
    var opiateBar:GuiSprite;
    var opiateBarProgress:GuiSprite;
    var arrowButton:GuiSprite;
    var moveItemSprite:GuiSprite;
    var holdText:MyText;

    var scarfButtonsList:GuiList<ScarfButtonGui>;
    var inventoryList:InventoryListGui;

    var passivesButtonsLists:Map<String, Array<PassiveItemsSlotsGui>> = [];
    
    public function new() {
        super();

        player = Objects.player;
        
        isVisible = false;
        
        //
        background = new FlxSprite();
        background.makeGraphic(FlxG.width, FlxG.height, Palette.FULL_BLACK);

        playerSprite = new GuiSprite(8, 16);
        loadPlayerSprite(player.scarves.equipped.name);

        healthBar = new GuiSprite(20, FlxG.height - 24, AssetPaths.health_bar__png);
        healthBarProgress = new GuiSprite(healthBar.x+1, healthBar.y+1, AssetPaths.health_bar_progress__png, true, 39, 2);

        opiateBar = new GuiSprite(20, FlxG.height - 17, AssetPaths.opiate_bar__png);
        opiateBarProgress = new GuiSprite(opiateBar.x+1, opiateBar.y+1, AssetPaths.opiate_bar_progress__png, true, 39, 2);

        arrowButton = new GuiSprite(0, 0, AssetPaths.arrow__png);

        moveItemSprite = new GuiSprite(0, 0, AssetPaths.move_item__png, true, 16, 8);

        holdText = new MyText("hold down to take a drug", 1, 1);
        
        scarfButtonsList = new GuiList(HORIZONTAL, 18, 2);
        inventoryList = new InventoryListGui(player);
        
        //
        add(background);
        add(playerSprite);
        add(healthBar);
        add(healthBarProgress);
        add(opiateBar);
        add(opiateBarProgress);

        updateChildrenAlpha();

        //
        for (scarf in player.scarves.list) {
            addScarfButtonGui(scarf);
        }
        
        // Listen
        player.scarves.onEquipped.listen(scarf-> {
            loadPlayerSprite(scarf.name);
        });
        player.scarves.onAdded.listen(scarf-> {
            addScarfButtonGui(scarf);
        });
        player.onDeath.listen(e-> {
            hide();
        });
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (Gamepad.justStart.triggered) {
            toggle();
        }

        inventoryList.update(elapsed);
        var listsGui = passivesButtonsLists.get(player.scarves.equipped.name);
        for (listGui in listsGui) {
            listGui.update(elapsed);
        }

        if (player.opiate.getCanBoost())
            holdText.alpha = Game.time % 40 < 20 ? .6 : .2;
        else
            holdText.alpha = 0;
        
        updateControls();
        updateBars();
    }
    function updateBars() {
        healthBarProgress.setClipRectSize(Math.round(player.health / player.maxHealth * healthBarProgress.width));
        opiateBarProgress.setClipRectSize(Math.round(player.opiate.level / player.opiate.maxLevel * opiateBarProgress.width));
    }
    function updateControls() {
        if (!isVisible) return;

        if (Gamepad.justRight.triggered) 
            chooseScarf(1);
        else if (Gamepad.justLeft.triggered) 
            chooseScarf(-1);
    }

    override function draw() {
        if (!(tween != null ? (tween.active || isVisible) : isVisible)) return;
        
        super.draw();
        updateChildrenAlpha();

        opiateBarProgress.color = Animations.rainbowColor(Game.time);
        
        inventoryList.drawAt(79, 15);
        scarfButtonsList.drawAt(119, 15);

        // Draw arrows
        arrowButton.drawAt(scarfButtonsList.x-8, scarfButtonsList.y + 6, true); // Left
        arrowButton.drawAt(scarfButtonsList.x + scarfButtonsList.length*20, scarfButtonsList.y + 6); // Right
        // Draw decals
        moveItemSprite.animation.frameIndex = 0;
        moveItemSprite.drawAt(101, 53);
        moveItemSprite.animation.frameIndex = 1;
        moveItemSprite.drawAt(101, 69);

        var listsGui = passivesButtonsLists.get(player.scarves.equipped.name);
        for (listGuiIndex in 0...listsGui.length) {
            var listGui = listsGui[listGuiIndex];

            listGui.x = scarfButtonsList.x + listGuiIndex * (listGui.itemSize+2);
            listGui.y = scarfButtonsList.y + scarfButtonsList.itemSize + 14;
            listGui.alpha = alpha;
            listGui.draw();
        }

        holdText.draw();
    }
    function updateChildrenAlpha() {
        forEach(sprite-> sprite.alpha = alpha);
        scarfButtonsList.alpha = alpha;
        inventoryList.alpha = alpha;
        arrowButton.alpha = alpha;
        moveItemSprite.alpha = alpha;
    }

    //
    function addScarfButtonGui(scarf:Scarf) {
        var scarfButton = new ScarfButtonGui(scarf);
        scarfButtonsList.add(scarfButton);

        var result:Array<PassiveItemsSlotsGui> = [];
        for (list in scarf.passivesLists) {
            var slotsGui = new PassiveItemsSlotsGui(list);
            result.push(slotsGui);
        }
        passivesButtonsLists.set(scarf.name, result);
    }
    
    //
    function chooseScarf(direction:Int):Bool {
        var index = player.scarves.list.indexOf(player.scarves.equipped);
        if (index < 0) return false;
        index += direction;

        if (index < 0)
            index = player.scarves.list.length-1;
        else if (index >= player.scarves.list.length)
            index = 0;

        var scarf = player.scarves.list[index];
        player.scarves.equip(scarf);
        
        return true;
    }

    //
    override function show() {
        super.show();

        // Game.isPaused = true;
        tweenAlpha(1);
    }
    override function hide() {
        super.hide();

        // Game.isPaused = false;
        tweenAlpha(0);
    }
    function tweenAlpha(alpha:Float) {
        if (tween != null)
            tween.cancel();
            
        tween = FlxTween.tween(this, { alpha: alpha }, .2, { ease: FlxEase.linear });
    }

    //
    function loadPlayerSprite(scarfName:String) {
        playerSprite.loadGraphic('assets/images/scarves/${ scarfName }-scarf-player.png');
    }
}