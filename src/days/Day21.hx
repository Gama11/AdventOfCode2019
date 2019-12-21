package days;

import haxe.macro.Expr;

class Day21 {
	#if !macro
	public static function walk(program:String):Int {
		return findHullDamage(program, assemble({
			jump = !isGround(3);
			jump = jump && isGround(4);

			temp = !isGround(1);
			jump = jump || temp;

			walk();
		}));
	}

	public static function run(program:String):Int {
		return findHullDamage(program, assemble({
			jump = !isGround(3);
			jump = jump && isGround(4);

			temp = !isGround(1);
			jump = jump || temp;

			run();
		}));
	}

	public static function findHullDamage(program:String, springscript:String):Int {
		trace(springscript);
		var springdroid = new IntCodeVM(program);
		for (code in springscript) {
			springdroid.write(code);
		}
		var rendering = "";
		springdroid.run();
		while (springdroid.hasOutput()) {
			var output = springdroid.read();
			if (output <= 255) {
				rendering += String.fromCharCode(output.toInt());
			} else {
				return output.toInt();
			}
		}
		Sys.println("\n" + rendering);
		throw 'died after ${springdroid.executedInstructions} instructions';
	}
	#end

	static macro function assemble(input:Expr):Expr {
		var springscript = "";
		var registers = ["jump" => "J", "temp" => "T"];
		function getRegister(expr:Expr) {
			return switch expr.expr {
				case EConst(CIdent(ident)):
					var name = registers[ident];
					if (name == null) {
						throw "unknown register " + name;
					}
					return name;

				case ECall({expr: EConst(CIdent("isGround"))}, [{expr: EConst(CInt(i))}]):
					return String.fromCharCode("A".code + Std.parseInt(i) - 1);

				case _:
					throw "identifier expected";
			}
		}
		function processInstruction(expr:Expr) {
			switch expr.expr {
				case EBinop(OpAssign, lhs, rhs):
					var r2 = getRegister(lhs);
					if (r2 != "J" && r2 != "T") {
						throw 'register $r2 is not writable';
					}
					var op = null;
					var r1 = null;
					switch rhs.expr {
						case EBinop(OpBoolAnd, e1, e2):
							if (r2 != getRegister(e1)) {
								throw "Binop lhs must be same as assigned register";
							}
							op = "AND";
							r1 = getRegister(e2);

						case EBinop(OpBoolOr, e1, e2):
							if (r2 != getRegister(e1)) {
								throw "Binop lhs must be same as assigned register";
							}
							op = "OR";
							r1 = getRegister(e2);

						case EUnop(OpNot, false, e):
							op = "NOT";
							r1 = getRegister(e);

						case _:
							throw 'invalid rhs operator';
					}
					springscript += '$op $r1 $r2\n';

				case _:
					throw "assignment expected";
			}
		}
		switch input.expr {
			case EBlock(exprs):
				var last = exprs.pop();
				for (expr in exprs) {
					processInstruction(expr);
				}
				switch last.expr {
					case ECall({expr: EConst(CIdent(name))}, []) if (name == "walk" || name == "run"):
						springscript += name.toUpperCase() + "\n";
					case _:
						throw 'last expression must be walk() or run()';
				}
			case _:
				throw "block expected";
		}
		return macro $v{springscript};
	}
}
