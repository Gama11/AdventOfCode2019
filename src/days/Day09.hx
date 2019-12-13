package days;

class Day09 {
	public static function run(program:String, ?input:Int):Float {
		return new IntCodeVM(program).write(input).run().read();
	}
}
