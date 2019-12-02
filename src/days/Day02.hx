package days;

class Day02 {
	public static function parse(input:String):Program {
		return input.trim().split(",").map(Std.parseInt);
	}

	public static function runIntcode(program:Program):Int {
		var i = 0;
		while (true) {
			function next() {
				return ++i;
			}
			var opcode:Opcode = program[i];
			switch opcode {
				case Add | Multiply:
					var a = program[program[next()]];
					var b = program[program[next()]];
					var c = program[next()];
					program[c] = if (opcode == Add) a + b else a * b;
					next();

				case Finish:
					return program[0];

				case code:
					throw 'unknown opcode $code';
			}
		}
	}

	public static function runGravityAssistProgram(input:String):Int {
		var program = parse(input);
		program[1] = 12;
		program[2] = 2;
		return runIntcode(program);
	}
}

private enum abstract Opcode(Int) from Int {
	var Add = 1;
	var Multiply = 2;
	var Finish = 99;
}

private typedef Program = Array<Int>;
