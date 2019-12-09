package days;

class Day09 {
	public static function part1(input:String, ?inputs:Array<Float>):Float {
		return switch Day05.runIntcode(Day05.parseProgram(input), inputs) {
			case Blocked(_): throw 'blocked';
			case Finished(output): output;
		};
	}
}
