package days;

class Day01 {
	static function parse(input:String):Array<Int> {
		return input.split("\n").map(Std.parseInt);
	}

	public static function calculateFuelRequirement(mass:Int):Int {
		var fuel = Std.int(mass / 3) - 2;
		return if (fuel < 0) 0 else fuel;
	}

	public static function calculateTotalFuelRequirement(mass:Int):Int {
		var fuel = calculateFuelRequirement(mass);
		return if (fuel <= 0) fuel else fuel + calculateTotalFuelRequirement(fuel);
	}

	public static function sumFuelRequirements(input:String, calculate:(mass:Int) -> Int):Int {
		return parse(input).map(calculate).sum();
	}
}
