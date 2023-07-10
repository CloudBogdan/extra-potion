package classes.items.guns;

class WeakGunItem extends GunItem {
    public static final NAME:String = "weak-gun";
    
    public function new() {
        super(NAME);

        knockback = 80;
        recoil = 60;
    }
}