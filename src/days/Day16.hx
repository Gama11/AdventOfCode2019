package days;

class Day16 {
	public static function performFFT(input:String, phases:Int):String {
		var basePattern = [0, 1, 0, -1];
		var signal = input.split("").map(Std.parseInt);
		for (_ in 0...phases) {
			var output = [];
			for (o in 0...signal.length) {
				var result = 0;
				for (i in 0...signal.length) {
					var offset = Std.int((i + 1) / (o + 1)) % basePattern.length;
					result += signal[i] * basePattern[offset];
				}
				output[o] = Std.int(Math.abs(result % 10));
			}
			signal = output;
		}
		return [for (i in 0...8) signal[i]].join("");
	}

	public static function performFFS(input:String) {
		var offset = Std.parseInt(input.substr(0, 7));
		var signal = input.split("").map(Std.parseInt);
		var relevantRange = signal.length * 10000 - offset;

		var input = [];
		for (i in 0...relevantRange) {
			input.push(signal[(offset + i) % signal.length]);
		}

		for (_ in 0...100) {
			var output = [];
			var acc = 0;
			var i = input.length;
			while (i-- > 0) {
				acc += input[i];
				output[i] = acc % 10;
			}
			input = output;
		}
		return [for (i in 0...8) input[i]].join("");
	}
}
