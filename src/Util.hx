class StaticExtensions {
	public static function sum(a:Array<Int>):Int {
		return a.fold((a, b) -> a + b, 0);
	}
}
