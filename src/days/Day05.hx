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

	public static function runIntcode(program:String, inputs:Array<Int>):Int {
		var outputs = [];
		var memory = parseProgram(program);
		var i = 0;
		function read(mode:ParameterMode):Int {
			var value = memory[i++];
			return if (mode == Position) memory[value] else value;
		}
		function write(value:Int) {
			memory[memory[i++]] = value;
		}
		while (true) {
			var op:Operation = parseOperation(memory[i++]);
			switch op.code {
				case Add | Multiply:
					var a = read(op.modes.a);
					var b = read(op.modes.b);
					write(if (op.code == Add) a + b else a * b);

				case Input:
					write(inputs.shift());

				case Output:
					outputs.push(read(op.modes.a));

				case JumpIfTrue:
					var a = read(op.modes.a);
					var b = read(op.modes.b);
					if (a != 0) {
						i = b;
					}

				case JumpIfFalse:
					var a = read(op.modes.a);
					var b = read(op.modes.b);
					if (a == 0) {
						i = b;
					}

				case LessThan:
					write(if (read(op.modes.a) < read(op.modes.b)) 1 else 0);

				case Equals:
					write(if (read(op.modes.a) == read(op.modes.b)) 1 else 0);

				case Finish:
					return outputs.pop();

				case code:
					throw 'unknown opcode $code';
			}
		}
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
	var JumpIfTrue;
	var JumpIfFalse;
	var LessThan;
	var Equals;
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
