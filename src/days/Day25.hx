package days;

import sys.io.File;

class Day25 {
	public static function findMainAirlockPassword(program:String, solution:String):Null<Int> {
		var totalOutput = "";
		var droid = new IntCodeVM(program);
		droid.writeString(solution);

		function run() {
			droid.run();
			var output = droid.readString();
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

			droid.writeString(input);
			solution += input;
			File.saveContent("steps.txt", solution);
		}
		var password = ~/\d\d+/;
		return if (password.match(totalOutput)) password.matchedInt(0) else null;
	}
}
