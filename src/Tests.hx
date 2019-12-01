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
}
