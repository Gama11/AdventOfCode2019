package days;

import sys.io.File;

class Day25 {
	public static function findMainAirlockPassword(program:String, solution:String):Null<Int> {
		var totalOutput = "";
		var droid = new IntCodeVM(program);
		for (code in solution) {
			droid.write(code);
		}
		function run() {
			droid.run();
			var output = "";
			while (droid.hasOutput()) {
				output += String.fromCharCode(droid.read().toInt());
			}
			totalOutput += output;
			Sys.println(output);
		}
		run();

		while (!droid.finished) {
			run();
			var input = "";
			do {
				var code = Sys.getChar(true);
				if (code == 0) {
					continue;
				}
				var char = String.fromCharCode(code);
				input += if (char == "\r") "\n" else char;
			} while (!input.endsWith("\n"));

			solution += input;
			File.saveContent("steps.txt", solution);
			for (code in input) {
				droid.write(code);
			}
		}
		var password = ~/\d\d+/;
		return if (password.match(totalOutput)) password.matchedInt(0) else null;
	}
}
