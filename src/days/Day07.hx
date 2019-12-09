package days;

import days.Day05;

using Std;

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

	public static function findMaxThrusterSignal(input:String):Int {
		var program = Day05.parseProgram(input);
		return getPermutations(0).max(computeThrusterSignal.bind(program)).value;
	}

	static function computeThrusterSignal(program:Program, settings:Array<Int>):Int {
		var signal = 0;
		for (setting in settings) {
			var result = Day05.runIntcode(program, [setting, signal]);
			signal = switch result {
				case Finished(output): output.int();
				case Blocked(_): throw 'not enough input';
			}
		}
		return signal;
	}

	static function computeThrusterSignalLooped(program:Program, settings:Array<Int>):Int {
		var state = [
			for (_ in 0...5)
				{
					i: 0,
					memory: program.copy()
				}
		];
		var amplifier = 0;
		var signal = 0;
		while (true) {
			var inputs:Array<Float> = [signal];
			if (settings.length > 0) {
				inputs.unshift(settings.shift());
			}
			var program = state[amplifier];
			var result = Day05.runIntcode(program.memory, inputs, program.i);
			switch result {
				case Blocked(i, output):
					program.i = i;
					signal = output.int();

				case Finished(output):
					if (amplifier == state.length - 1) {
						return output.int();
					} else {
						signal = output.int();
					}
			}
			amplifier++;
			if (amplifier >= state.length) {
				amplifier = 0;
			}
		}
	}

	public static function findMaxThrusterSignal2(input:String):Int {
		var program = Day05.parseProgram(input);
		return getPermutations(5).max(computeThrusterSignalLooped.bind(program)).value;
	}
}
