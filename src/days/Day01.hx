package days;

class Day01 {
	static function parse(input:String):Array<Int> {
		return input.split("\n").map(Std.parseInt);
	}

	public static function calculateFuelRequirement(mass:Int):Int {
		return Std.int(mass / 3) - 2;
	}

	public static function calculateFuelRequirements(input:String):Int {
		return parse(input).map(calculateFuelRequirement).sum();
	}
}
