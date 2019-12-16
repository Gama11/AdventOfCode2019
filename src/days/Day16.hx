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
}
