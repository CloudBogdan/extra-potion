package utils;

class ValueUtils {
    public static function safeValue<T>(value:Null<T>, safe:T):T {
        if (value == null) return safe;
        return value;
    }
}