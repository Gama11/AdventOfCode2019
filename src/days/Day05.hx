package days;

using Std;

class Day05 {
	public static function parseProgram(input:String):Program {
		return input.trim().split(",").map(Std.parseFloat);
	}

	static function parseOperation(input:Float):Operation {
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

	public static function runIntcode(program:Program, ?inputs:Array<Float>, i = 0):Result {
		if (inputs == null) {
			inputs = [];
		}
		var outputs = [];
		var memory = program;
		var relativeBase = 0;
		function read(mode:ParameterMode):Float {
			var value = memory[i++];
			var result = switch mode {
				case Position: memory[value.int()];
				case Immediate: value;
				case Relative: memory[(value + relativeBase).int()];
			}
			return if (result == null) 0 else result;
		}
		function write(value:Float, mode:ParameterMode) {
			var offset = if (mode == Relative) relativeBase else 0;
			memory[memory[i++].int() + offset] = value;
		}
		while (true) {
			var op:Operation = parseOperation(memory[i++]);
			switch op.code {
				case Add | Multiply:
					var a = read(op.modes.a);
					var b = read(op.modes.b);
					write(if (op.code == Add) a + b else a * b, op.modes.c);

				case Input:
					var input = if (inputs.length == 0) {
						if (outputs.length > 1) {
							throw 'only one output expected, got $outputs';
						}
						return Blocked(i - 1, outputs[0]);
					} else {
						inputs.shift();
					}
					write(input, op.modes.a);

				case Output:
					outputs.push(read(op.modes.a));

				case JumpIfTrue:
					var a = read(op.modes.a);
					var b = read(op.modes.b);
					if (a != 0) {
						i = b.int();
					}

				case JumpIfFalse:
					var a = read(op.modes.a);
					var b = read(op.modes.b);
					if (a == 0) {
						i = b.int();
					}

				case LessThan:
					write(if (read(op.modes.a) < read(op.modes.b)) 1 else 0, op.modes.c);

				case Equals:
					write(if (read(op.modes.a) == read(op.modes.b)) 1 else 0, op.modes.c);

				case OffsetRelativeBase:
					relativeBase += read(op.modes.a).int();

				case Finish:
					return Finished(outputs.pop());

				case code:
					throw 'unknown opcode $code';
			}
		}
	}
}

private enum abstract ParameterMode(Int) from Int {
	var Position;
	var Immediate;
	var Relative;
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
	var OffsetRelativeBase;
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

typedef Program = Array<Float>;

enum Result {
	Blocked(i:Int, output:Float);
	Finished(output:Float);
}
