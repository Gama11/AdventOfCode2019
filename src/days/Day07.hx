package days;

class Day07 {
	public static function findMaxThrusterSignal(input:String):Int {
		var maxSignal = 0;
		for (a in 0...5) {
			for (b in 0...4) {
				for (c in 0...3) {
					for (d in 0...2) {
						var numbers = [0, 1, 2, 3, 4];
						var settings = [];
						function pick(i:Int) {
							settings.push(numbers.splice(i, 1)[0]);
						}
						pick(a);
						pick(b);
						pick(c);
						pick(d);
						pick(0);
						var signal = computeThrusterSignal(input, settings);
						if (signal > maxSignal) {
							maxSignal = signal;
						}
					}
				}
			}
		}
		return maxSignal;
	}

	static function computeThrusterSignal(input:String, phaseSettings:Array<Int>):Int {
		var signal = 0;
		for (setting in phaseSettings) {
			signal = Day05.runIntcode(input, [setting, signal]);
		}
		return signal;
	}
}
