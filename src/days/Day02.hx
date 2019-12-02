package days;

class Day02 {
	public static function parse(input:String):Program {
		return input.trim().split(",").map(Std.parseInt);
	}

	public static function runIntcode(program:Program):Int {
		var memory = program.copy();
		var i = 0;
		while (true) {
			function next() {
				return ++i;
			}
			var opcode:Opcode = memory[i];
			switch opcode {
				case Add | Multiply:
					var a = memory[memory[next()]];
					var b = memory[memory[next()]];
					var c = memory[next()];
					memory[c] = if (opcode == Add) a + b else a * b;
					next();

				case Finish:
					return memory[0];

				case code:
					throw 'unknown opcode $code';
			}
		}
	}

	public static function runGravityAssistProgram(program:Program, noun = 12, verb = 2):Int {
		program[1] = noun;
		program[2] = verb;
		return runIntcode(program);
	}

	public static function findInputForOutput(program:Program, output:Int):Int {
		for (noun in 0...100) {
			for (verb in 0...100) {
				try {
					if (output == runGravityAssistProgram(program, noun, verb)) {
						return 100 * noun + verb;
					}
				} catch (e:Any) {}
			}
		}
		throw "not found";
	}
}

private enum abstract Opcode(Int) from Int {
	var Add = 1;
	var Multiply = 2;
	var Finish = 99;
}

private typedef Program = Array<Int>;
