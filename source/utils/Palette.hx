package utils;

import flixel.util.FlxColor;

class Palette {
    public static inline final ABSOLUTE_WHITE:Int = 0xFFffffff;
    public static inline final FULL_WHITE:Int = 0xFFfcfcfc;
    public static inline final FULL_BLACK:Int = 0xFF000000;

    public static inline final WHITE:Int      = 0xFFf8d8f8;
    public static inline final GRAY:Int       = 0xFF787878;
    public static inline final LIGHT_GRAY:Int = 0xFFbcbcbc;

    public static inline final BLUE_1:Int = 0xFFb8b8f8;
    public static inline final BLUE_2:Int = 0xFF6888fc;
    public static inline final BLUE_3:Int = 0xFF0058f8;
    public static inline final BLUE_4:Int = 0xFF0000fc;

    public static inline final PURPLE_1:Int = 0xFFd8b8f8;
    public static inline final PURPLE_2:Int = 0xFF9878f8;
    public static inline final PURPLE_3:Int = 0xFF6844fc;
    public static inline final PURPLE_4:Int = 0xFF4428bc;

    public static inline final PINK_1:Int = 0xFFf8b8f8;
    public static inline final PINK_2:Int = 0xFFf878f8;
    public static inline final PINK_3:Int = 0xFFd800cc;
    public static inline final PINK_4:Int = 0xFF940084;

    public static inline final RED_1:Int = 0xFFf8a4c0;
    public static inline final RED_2:Int = 0xFFf85898;
    public static inline final RED_3:Int = 0xFFe40058;
    public static inline final RED_4:Int = 0xFFa80020;

    public static inline final ORANGE_1:Int = 0xFFfce0a8;
    public static inline final ORANGE_2:Int = 0xFFf87858;
    public static inline final ORANGE_3:Int = 0xFFf83800;
    public static inline final ORANGE_4:Int = 0xFFa81000;

    public static inline final BROWN_1:Int = 0xFFfce0a8;
    public static inline final BROWN_2:Int = 0xFFfca044;
    public static inline final BROWN_3:Int = 0xFFe45c10;
    public static inline final BROWN_4:Int = 0xFF881400;

    public static inline final YELLOW_1:Int = 0xFFf8d878;
    public static inline final YELLOW_2:Int = 0xFFf8b800;
    public static inline final YELLOW_3:Int = 0xFFac7c00;
    public static inline final YELLOW_4:Int = 0xFF503000;

    public static inline final LIME_1:Int = 0xFFd8f878;
    public static inline final LIME_2:Int = 0xFFb8f818;

    public static inline final GREEN_1:Int = 0xFFb8f8d8;
    public static inline final GREEN_2:Int = 0xFF58d854;
    public static inline final GREEN_3:Int = 0xFF00b800;
    public static inline final GREEN_4:Int = 0xFF006800;

    public static inline final CYAN_1:Int = 0xFF00fcfc;
    public static inline final CYAN_2:Int = 0xFF008888;
    public static inline final CYAN_3:Int = 0xFF004058;

    public static inline function getIntPaletteArray():Array<Int> {
        return [
            FULL_WHITE, FULL_BLACK,
            WHITE, GRAY, LIGHT_GRAY,
            BLUE_1, BLUE_2, BLUE_3, BLUE_4,
            PURPLE_1, PURPLE_2, PURPLE_3, PURPLE_4,
            PINK_1, PINK_2, PINK_3, PINK_4,
            RED_1, RED_2, RED_3, RED_4,
            ORANGE_1, ORANGE_2, ORANGE_3, ORANGE_4,
            BROWN_1, BROWN_2, BROWN_3, BROWN_4,
            YELLOW_1, YELLOW_2, YELLOW_3, YELLOW_4,
            LIME_1, LIME_2,
            GREEN_1, GREEN_2, GREEN_3, GREEN_4,
            CYAN_1, CYAN_2, CYAN_3,
        ];
    }
    public static inline function getRgbaPaletteArray():Array<RGBA> {
        return getIntPaletteArray().map(int-> {
            var color = new FlxColor(int);
            
            return [
                color.redFloat,
                color.greenFloat,
                color.blueFloat,
                1
            ];
        });
    }
}