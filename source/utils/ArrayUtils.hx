package utils;

class ArrayUtils {
    public static function mergeMaps<K, V>(a:Map<K,V>, b:Map<K,V>):Map<K, V> {
        for (key in b.keys()) {
			a.set(key, b.get(key));
		}
        return a;
    }
}