package days;

class Day02 {
	public static function runGravityAssistProgram(program:String, noun = 12, verb = 2):Int64 {
		var vm = new IntCodeVM(program);
		vm.memory[1] = noun;
		vm.memory[2] = verb;
		return vm.run().memory[0];
	}

	public static function findInputForOutput(program:String, output:Int):Int {
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
