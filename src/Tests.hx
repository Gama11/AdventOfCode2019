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

	function testDay04() {
		Assert.isTrue(Day04.meetsCritera(111111));
		Assert.isFalse(Day04.meetsCritera(223450));
		Assert.isFalse(Day04.meetsCritera(123789));
		Assert.equals(481, Day04.findValidPasswords(372037, 905157).length);
	}
}
