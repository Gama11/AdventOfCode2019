package days;

class Day09 {
	public static function run(program:String, ?input:Int):Int64 {
		return new IntCodeVM(program).write(input).run().read();
	}
}
