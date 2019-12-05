package days;

class Day05 {
	public static function parseProgram(input:String):Program {
		return input.trim().split(",").map(Std.parseInt);
	}

	static function parseOperation(input:Int):Operation {
		var digits = Std.string(input).lpad("0", 5).split("").map(Std.parseInt);
		return {
			modes: {
				a: digits[2],
				b: digits[1],
				c: digits[0]
			},
			code: digits[3] * 10 + digits[4]
		};
	}

	public static function runIntcode(program:Program, inputs:Array<Int>):Array<Int> {
		var outputs = [];
		var memory = program.copy();
		var i = 0;
		function read(value:Int, mode:ParameterMode):Int {
			var value = memory[value];
			return if (mode == Position) memory[value] else value;
		}
		function write(pos:Int, value:Int) {
			memory[memory[pos]] = value;
		}
		while (true) {
			var op:Operation = parseOperation(memory[i++]);
			switch op.code {
				case Add | Multiply:
					var a = read(i++, op.modes.a);
					var b = read(i++, op.modes.b);
					write(i++, if (op.code == Add) a + b else a * b);

				case Input:
					write(i++, inputs.shift());

				case Output:
					outputs.push(read(i++, op.modes.a));

				case Finish:
					return outputs;

				case code:
					throw 'unknown opcode $code';
			}
		}
	}

	public static function runTEST(input:String):Int {
		return runIntcode(parseProgram(input), [1]).pop();
	}
}

private enum abstract ParameterMode(Int) from Int {
	var Position;
	var Immediate;
}

private enum abstract Opcode(Int) from Int {
	var Add = 1;
	var Multiply;
	var Input;
	var Output;
	var Finish = 99;
}

private typedef Operation = {
	var modes:{
		a:ParameterMode,
		b:ParameterMode,
		c:ParameterMode
	};
	var code:Opcode;
}

private typedef Program = Array<Int>;
