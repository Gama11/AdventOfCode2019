package days;

class Day19 {
	public static function countPointsAffectedByBeam(program:String) {
		var count = 0;
		for (x in 0...50) {
			for (y in 0...50) {
				if (new IntCodeVM(program).write(x).write(y).run().read().toInt() == BeingPulled) {
					count++;
				}
			}
		}
		return count;
	}
}

private enum abstract DroneStatus(Int) from Int {
	var Stationary;
	var BeingPulled;
}
