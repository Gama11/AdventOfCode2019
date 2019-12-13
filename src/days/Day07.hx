package days;

class Day07 {
	static function getPermutations(min:Int):Array<Array<Int>> {
		var permutations = [];
		for (a in 0...5) {
			for (b in 0...4) {
				for (c in 0...3) {
					for (d in 0...2) {
						var numbers = [for (i in 0...5) i + min];
						var settings = [];
						function pick(i:Int) {
							settings.push(numbers.splice(i, 1)[0]);
						}
						pick(a);
						pick(b);
						pick(c);
						pick(d);
						pick(0);
						permutations.push(settings);
					}
				}
			}
		}
		return permutations;
	}

	public static function findMaxThrusterSignal(program:String):Int {
		return getPermutations(0).max(computeThrusterSignal.bind(program)).value;
	}

	static function computeThrusterSignal(program:String, settings:Array<Int>):Int {
		var signal = 0;
		for (setting in settings) {
			signal = new IntCodeVM(program).write(setting).write(signal).run().read().toInt();
		}
		return signal;
	}

	static function computeThrusterSignalLooped(program:String, settings:Array<Int>):Int {
		var amplifiers = [for (_ in 0...5) new IntCodeVM(program)];
		var i = 0;
		var signal = 0;
		while (true) {
			var amplifier = amplifiers[i];
			if (settings.length > 0) {
				amplifier.write(settings.shift());
			}
			signal = amplifier.write(signal).run().read().toInt();
			if (amplifier.finished && i == amplifiers.length - 1) {
				return signal;
			}

			i++;
			if (i >= amplifiers.length) {
				i = 0;
			}
		}
	}

	public static function findMaxThrusterSignal2(program:String):Int {
		return getPermutations(5).max(computeThrusterSignalLooped.bind(program)).value;
	}
}
