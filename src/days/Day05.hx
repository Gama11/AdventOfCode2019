package days;

class Day05 {
	public static function runIntcode(program:String, ?input:Int) {
		return new IntCodeVM(program).write(input).run().read();
	}
}
