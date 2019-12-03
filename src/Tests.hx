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

	function testDay03() {
		Assert.equals(6, Day03.getDistanceToClosestIntersection(getData("day03-0")));
		Assert.equals(159, Day03.getDistanceToClosestIntersection(getData("day03-1")));
		Assert.equals(135, Day03.getDistanceToClosestIntersection(getData("day03-2")));
		Assert.equals(1337, Day03.getDistanceToClosestIntersection(getData("day03-3")));
	}
}
