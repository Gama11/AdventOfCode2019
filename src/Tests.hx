import days.*;
import utest.ITest;
import utest.Assert;
import utest.UTest;

class Tests implements ITest {
	static function main() {
		UTest.run([new Tests()]);
	}

	function new() {}

	function getData(name:String):String {
		return sys.io.File.getContent('data/$name.txt').replace("\r", "");
	}

	@Ignored
	function testDay01() {
		Assert.equals(2, Day01.calculateFuelRequirement(12));
		Assert.equals(2, Day01.calculateFuelRequirement(14));
		Assert.equals(654, Day01.calculateFuelRequirement(1969));
		Assert.equals(33583, Day01.calculateFuelRequirement(100756));
		Assert.equals(3147032, Day01.sumFuelRequirements(getData("day01"), Day01.calculateFuelRequirement));

		Assert.equals(2, Day01.calculateTotalFuelRequirement(14));
		Assert.equals(966, Day01.calculateTotalFuelRequirement(1969));
		Assert.equals(50346, Day01.calculateTotalFuelRequirement(100756));
		Assert.equals(4717699, Day01.sumFuelRequirements(getData("day01"), Day01.calculateTotalFuelRequirement));
	}

	@Ignored
	function testDay02() {
		Assert.equals(3500, Day02.runIntcode([1, 9, 10, 3, 2, 3, 11, 0, 99, 30, 40, 50]));
		Assert.equals(2, Day02.runIntcode([1, 0, 0, 0, 99]));
		Assert.equals(30, Day02.runIntcode([1, 1, 1, 4, 99, 5, 6, 0, 99]));

		var data = Day02.parse(getData("day02"));
		Assert.equals(5098658, Day02.runGravityAssistProgram(data));
		Assert.equals(5064, Day02.findInputForOutput(data, 19690720));
	}

	@Ignored
	function testDay03() {
		var part1 = file -> Day03.getDistanceToClosestIntersection(getData(file), Manhattan);
		Assert.equals(6, part1("day03-0"));
		Assert.equals(159, part1("day03-1"));
		Assert.equals(135, part1("day03-2"));
		Assert.equals(1337, part1("day03-3"));

		var part2 = file -> Day03.getDistanceToClosestIntersection(getData(file), Steps);
		Assert.equals(30, part2("day03-0"));
		Assert.equals(610, part2("day03-1"));
		Assert.equals(410, part2("day03-2"));
		Assert.equals(65356, part2("day03-3"));
	}

	@Ignored
	function testDay04() {
		Assert.isTrue(Day04.meetsCritera(111111));
		Assert.isFalse(Day04.meetsCritera(223450));
		Assert.isFalse(Day04.meetsCritera(123789));
		Assert.equals(481, Day04.countValidPasswords(372037, 905157));

		Assert.isTrue(Day04.meetsCritera(112233, true));
		Assert.isFalse(Day04.meetsCritera(123444, true));
		Assert.isTrue(Day04.meetsCritera(111122, true));
		Assert.equals(299, Day04.countValidPasswords(372037, 905157, true));
	}

	@Ignored
	function testDay05() {
		function runIntcode(program:String, inputs:Array<Float>):Float {
			return switch Day05.runIntcode(Day05.parseProgram(program), inputs) {
				case Finished(outputs): outputs[0];
				case Blocked(_): throw 'not enough input';
			}
		}

		Assert.isNull(runIntcode("1002,4,3,4,33", []));
		Assert.equals(14155342, runIntcode(getData("day05-0"), [1]));

		var equalsEightA = n -> runIntcode("3,9,8,9,10,9,4,9,99,-1,8", [n]);
		Assert.equals(1, equalsEightA(8));
		Assert.equals(0, equalsEightA(5));

		var lessThanEightA = n -> runIntcode("3,9,7,9,10,9,4,9,99,-1,8", [n]);
		Assert.equals(0, lessThanEightA(8));
		Assert.equals(1, lessThanEightA(5));

		var equalsEightB = n -> runIntcode("3,3,1108,-1,8,3,4,3,99", [n]);
		Assert.equals(1, equalsEightB(8));
		Assert.equals(0, equalsEightB(5));

		var lessThanEightB = n -> runIntcode("3,3,1107,-1,8,3,4,3,99", [n]);
		Assert.equals(0, lessThanEightB(8));
		Assert.equals(1, lessThanEightB(5));

		var isNonZeroA = n -> runIntcode("3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9", [n]);
		Assert.equals(1, isNonZeroA(1));
		Assert.equals(0, isNonZeroA(0));

		var isNonZeroB = n -> runIntcode("3,3,1105,-1,9,1101,0,0,12,4,12,99,1", [n]);
		Assert.equals(1, isNonZeroB(1));
		Assert.equals(0, isNonZeroB(0));

		var largerExample = n -> runIntcode(getData("day05-1"), [n]);
		Assert.equals(999, largerExample(7));
		Assert.equals(1000, largerExample(8));
		Assert.equals(1001, largerExample(9));

		Assert.equals(8684145, runIntcode(getData("day05-0"), [5]));
	}

	@Ignored
	function testDay06() {
		Assert.equals(42, Day06.countOrbits(getData("day06-0")));
		Assert.equals(119831, Day06.countOrbits(getData("day06-1")));

		Assert.equals(4, Day06.countOrbitalTransfers(getData("day06-2")));
		Assert.equals(322, Day06.countOrbitalTransfers(getData("day06-1")));
	}

	@Ignored
	function testDay07() {
		Assert.equals(43210, Day07.findMaxThrusterSignal(getData("day07-0")));
		Assert.equals(54321, Day07.findMaxThrusterSignal(getData("day07-1")));
		Assert.equals(65210, Day07.findMaxThrusterSignal(getData("day07-2")));
		Assert.equals(101490, Day07.findMaxThrusterSignal(getData("day07-3")));

		Assert.equals(139629729, Day07.findMaxThrusterSignal2(getData("day07-4")));
		Assert.equals(18216, Day07.findMaxThrusterSignal2(getData("day07-5")));
		Assert.equals(61019896, Day07.findMaxThrusterSignal2(getData("day07-3")));
	}

	@Ignored
	function testDay08() {
		Assert.equals(1, Day08.validateImage("123456789012", 3, 2));
		Assert.equals(1485, Day08.validateImage(getData("day08"), 25, 6));

		Sys.println(Day08.decodeImage("0222112222120000", 2, 2) + "\n");
		Sys.println(Day08.decodeImage(getData("day08"), 25, 6) + "\n");
	}

	@Ignored
	function testDay09() {
		Assert.equals(99, Day09.run("109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99"));
		Assert.equals(16, Std.string(Day09.run("1102,34915192,34915192,7,4,7,99,0")).length);
		Assert.equals(1125899906842624, Day09.run("104,1125899906842624,99"));
		Assert.equals(2682107844, Day09.run(getData("day09"), [1]));

		Assert.equals(34738, Day09.run(getData("day09"), [2]));
	}

	function testDay10() {
		var part1 = file -> Day10.findMonitoringStation(Day10.parse(getData(file))).value;
		Assert.equals(8, part1("day10-0"));
		Assert.equals(33, part1("day10-1"));
		Assert.equals(35, part1("day10-2"));
		Assert.equals(41, part1("day10-3"));
		Assert.equals(210, part1("day10-4"));
		Assert.equals(344, part1("day10-5"));

		Assert.equals(802, Day10.findByVaporizationRank(getData("day10-4")));
		Assert.equals(2732, Day10.findByVaporizationRank(getData("day10-5")));
	}

	function testDay11() {
		Assert.equals(2255, Day11.countPaintedPanels(getData("day11")));
	}
}
