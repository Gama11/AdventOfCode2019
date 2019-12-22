import days.*;
import utest.ITest;
import utest.Assert;
import utest.UTest;
import haxe.Int64.parseString as int64;

class Tests implements ITest {
	static function main() {
		UTest.run([new Tests()]);
	}

	function new() {}

	function getData(name:String):String {
		return sys.io.File.getContent('data/$name.txt').replace("\r", "");
	}

	@Ignored
	function specDay01() {
		2 == Day01.calculateFuelRequirement(12);
		2 == Day01.calculateFuelRequirement(14);
		654 == Day01.calculateFuelRequirement(1969);
		33583 == Day01.calculateFuelRequirement(100756);
		3147032 == Day01.sumFuelRequirements(getData("day01"), Day01.calculateFuelRequirement);

		2 == Day01.calculateTotalFuelRequirement(14);
		966 == Day01.calculateTotalFuelRequirement(1969);
		50346 == Day01.calculateTotalFuelRequirement(100756);
		4717699 == Day01.sumFuelRequirements(getData("day01"), Day01.calculateTotalFuelRequirement);
	}

	@Ignored
	function specDay02() {
		var run = code -> new IntCodeVM(code).run().memory[0];
		3500 == run("1,9,10,3,2,3,11,0,99,30,40,50");
		2 == run("1,0,0,0,99");
		30 == run("1,1,1,4,99,5,6,0,99");

		5098658 == Day02.runGravityAssistProgram(getData("day02"));
		5064 == Day02.findInputForOutput(getData("day02"), 19690720);
	}

	@Ignored
	function specDay03() {
		var part1 = file -> Day03.getDistanceToClosestIntersection(getData(file), Manhattan);
		6 == part1("day03-0");
		159 == part1("day03-1");
		135 == part1("day03-2");
		1337 == part1("day03-3");

		var part2 = file -> Day03.getDistanceToClosestIntersection(getData(file), Steps);
		30 == part2("day03-0");
		610 == part2("day03-1");
		410 == part2("day03-2");
		65356 == part2("day03-3");
	}

	@Ignored
	function specDay04() {
		true == Day04.meetsCritera(111111);
		false == Day04.meetsCritera(223450);
		false == Day04.meetsCritera(123789);
		481 == Day04.countValidPasswords(372037, 905157);

		true == Day04.meetsCritera(112233, true);
		false == Day04.meetsCritera(123444, true);
		true == Day04.meetsCritera(111122, true);
		299 == Day04.countValidPasswords(372037, 905157, true);
	}

	@Ignored
	function specDay05() {
		false == new IntCodeVM("1002,4,3,4,33").run().hasOutput();
		var vm = new IntCodeVM(getData("day05-0")).write(1).run();
		var lastOutput:Int64 = 0;
		while (vm.hasOutput()) {
			lastOutput = vm.read();
		}
		14155342 == lastOutput;

		var equalsEightA = n -> Day05.runIntcode("3,9,8,9,10,9,4,9,99,-1,8", n);
		1 == equalsEightA(8);
		0 == equalsEightA(5);

		var lessThanEightA = n -> Day05.runIntcode("3,9,7,9,10,9,4,9,99,-1,8", n);
		0 == lessThanEightA(8);
		1 == lessThanEightA(5);

		var equalsEightB = n -> Day05.runIntcode("3,3,1108,-1,8,3,4,3,99", n);
		1 == equalsEightB(8);
		0 == equalsEightB(5);

		var lessThanEightB = n -> Day05.runIntcode("3,3,1107,-1,8,3,4,3,99", n);
		0 == lessThanEightB(8);
		1 == lessThanEightB(5);

		var isNonZeroA = n -> Day05.runIntcode("3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9", n);
		1 == isNonZeroA(1);
		0 == isNonZeroA(0);

		var isNonZeroB = n -> Day05.runIntcode("3,3,1105,-1,9,1101,0,0,12,4,12,99,1", n);
		1 == isNonZeroB(1);
		0 == isNonZeroB(0);

		var largerExample = n -> Day05.runIntcode(getData("day05-1"), n);
		999 == largerExample(7);
		1000 == largerExample(8);
		1001 == largerExample(9);

		8684145 == Day05.runIntcode(getData("day05-0"), 5);
	}

	@Ignored
	function specDay06() {
		42 == Day06.countOrbits(getData("day06-0"));
		119831 == Day06.countOrbits(getData("day06-1"));

		4 == Day06.countOrbitalTransfers(getData("day06-2"));
		322 == Day06.countOrbitalTransfers(getData("day06-1"));
	}

	@Ignored
	function specDay07() {
		43210 == Day07.findMaxThrusterSignal(getData("day07-0"));
		54321 == Day07.findMaxThrusterSignal(getData("day07-1"));
		65210 == Day07.findMaxThrusterSignal(getData("day07-2"));
		101490 == Day07.findMaxThrusterSignal(getData("day07-3"));

		139629729 == Day07.findMaxThrusterSignal2(getData("day07-4"));
		18216 == Day07.findMaxThrusterSignal2(getData("day07-5"));
		61019896 == Day07.findMaxThrusterSignal2(getData("day07-3"));
	}

	@Ignored
	function specDay08() {
		1 == Day08.validateImage("123456789012", 3, 2);
		1485 == Day08.validateImage(getData("day08"), 25, 6);

		Sys.println(Day08.decodeImage("0222112222120000", 2, 2) + "\n");
		Sys.println(Day08.decodeImage(getData("day08"), 25, 6) + "\n");
	}

	@Ignored
	function specDay09() {
		109 == Day09.run("109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99");
		16 == Std.string(Day09.run("1102,34915192,34915192,7,4,7,99,0")).length;
		int64("1125899906842624") == Day09.run("104,1125899906842624,99");
		int64("2682107844") == Day09.run(getData("day09"), 1);

		34738 == Day09.run(getData("day09"), 2);
	}

	@Ignored
	function specDay10() {
		var part1 = file -> Day10.findMonitoringStation(Day10.parse(getData(file))).value;
		8 == part1("day10-0");
		33 == part1("day10-1");
		35 == part1("day10-2");
		41 == part1("day10-3");
		210 == part1("day10-4");
		344 == part1("day10-5");

		802 == Day10.findByVaporizationRank(getData("day10-4"));
		2732 == Day10.findByVaporizationRank(getData("day10-5"));
	}

	@Ignored
	function specDay11() {
		2255 == Day11.countPaintedPanels(getData("day11"));
		Sys.println(Day11.renderRegistrationIdentifier(getData("day11")) + "\n");
	}

	@Ignored
	function specDay12() {
		179 == Day12.computeTotalEnergy(getData("day12-0"), 10);
		1940 == Day12.computeTotalEnergy(getData("day12-1"), 100);
		7013 == Day12.computeTotalEnergy(getData("day12-2"), 1000);

		int64("2772") == Day12.findCycle(getData("day12-0"));
		int64("4686774924") == Day12.findCycle(getData("day12-1"));
		int64("324618307124784") == Day12.findCycle(getData("day12-2"));
	}

	@Ignored
	function specDay13() {
		324 == Day13.countBlocks(getData("day13"));
		15957 == Day13.beatGame(getData("day13"));
	}

	@Ignored
	function specDay14() {
		31 == Day14.calculateFuelCost(getData("day14-0"));
		165 == Day14.calculateFuelCost(getData("day14-1"));
		13312 == Day14.calculateFuelCost(getData("day14-2"));
		180697 == Day14.calculateFuelCost(getData("day14-3"));
		2210736 == Day14.calculateFuelCost(getData("day14-4"));
		431448 == Day14.calculateFuelCost(getData("day14-5"));

		3279311 == Day14.findMaxFuelProduction(getData("day14-5"));
	}

	@Ignored
	function specDay15() {
		294 == Day15.findShortestPath(getData("day15"));
		388 == Day15.fillWithOxygen(getData("day15"));
	}

	@Ignored
	function specDay16() {
		"01029498" == Day16.performFFT("12345678", 4);
		"24176176" == Day16.performFFT("80871224585914546619083218645595", 100);
		"73745418" == Day16.performFFT("19617804207202209144916044189917", 100);
		"52432133" == Day16.performFFT("69317163492948606335995924319873", 100);
		"61149209" == Day16.performFFT(getData("day16"), 100);

		"84462026" == Day16.performFFS("03036732577212944063491565474664");
		"78725270" == Day16.performFFS("02935109699940807407585447034323");
		"53553731" == Day16.performFFS("03081770884921959731165446850517");
		"16178430" == Day16.performFFS(getData("day16"));
	}

	@Ignored
	function specDay17() {
		76 == Day17.calculateAlignmentParameterSum(getData("day17-0"));
		5940 == Day17.calibrateCameras(getData("day17-1"));

		923795 == Day17.warnRobots(getData("day17-1"));
	}

	@Ignored
	function specDay18() {
		8 == Day18.findShortestPath(getData("day18-0"));
		86 == Day18.findShortestPath(getData("day18-1"));
		132 == Day18.findShortestPath(getData("day18-2"));
		136 == Day18.findShortestPath(getData("day18-3"));
		81 == Day18.findShortestPath(getData("day18-4"));
		4192 == Day18.findShortestPath(getData("day18-5"));

		8 == Day18.findShortestPath(getData("day18-6"));
		24 == Day18.findShortestPath(getData("day18-7"));
		32 == Day18.findShortestPath(getData("day18-8"));
		72 == Day18.findShortestPath(getData("day18-9"));
		1790 == Day18.findShortestPath(getData("day18-10"));
	}

	@Ignored
	function specDay19() {
		162 == Day19.countPointsAffectedByBeam(getData("day19"));
		13021056 == Day19.findClosestPossibleShipLocation(getData("day19"));
	}

	@Ignored
	function specDay20() {
		23 == Day20.findShortestPath(getData("day20-0"), false);
		58 == Day20.findShortestPath(getData("day20-1"), false);
		548 == Day20.findShortestPath(getData("day20-2"), false);

		26 == Day20.findShortestPath(getData("day20-0"), true);
		396 == Day20.findShortestPath(getData("day20-3"), true);
		6452 == Day20.findShortestPath(getData("day20-2"), true);
	}

	@Ignored
	function specDay21() {
		19347995 == Day21.walk(getData("day21"));
		1141826552 == Day21.run(getData("day21"));
	}

	function specDay22() {
		Assert.same([0, 3, 6, 9, 2, 5, 8, 1, 4, 7], Day22.shuffle(getData("day22-0")));
		Assert.same([3, 0, 7, 4, 1, 8, 5, 2, 9, 6], Day22.shuffle(getData("day22-1")));
		Assert.same([6, 3, 0, 7, 4, 1, 8, 5, 2, 9], Day22.shuffle(getData("day22-2")));
		Assert.same([9, 2, 5, 8, 1, 4, 7, 0, 3, 6], Day22.shuffle(getData("day22-3")));

		var input = getData("day22-4");
		var instructions = Day22.parse(input);
		var part2Size = Int64.parseString("119315717514047");
		var part2Shuffles = Int64.parseString("101741582076661");

		3074 == Day22.shuffle(input, 10007).indexOf(2019);
		3074 == Day22.positionOfCardWithNumber(instructions, 10007, 2019);
		5003 == Day22.findCycle(instructions, 10007);
		true == Day22.isValidDeckSize(instructions, 10007);
		true == Day22.isValidDeckSize(instructions, part2Size);
		2019 == Day22.numberOfCardInPosition(instructions, 10007, 3074);

		var shuffles = 20000;
		var initialPos:Int64 = 5698;
		var finalPos = initialPos;
		for (_ in 0...shuffles) {
			finalPos = Day22.positionOfCardWithNumber(instructions, 10007, finalPos);
		}
		9365 == finalPos;
		initialPos == Day22.fastNumberOfCardInPosition(instructions, finalPos, 10007, shuffles, 5003);

		// trace(Day22.fastNumberOfCardInPosition(instructions, 2020, part2Size, part2Shuffles, Int64.parseString("59657858757023")));

		/* var size = 50000;
			while (true) {
				if (Day22.isValidDeckSize(instructions, size)) {
					var cycle = Day22.findCycle(instructions, size);
					trace(size, cycle, Std.int(size / cycle), size % cycle);
				}
				size++;
		}*/
		/* var o = [];
			for (i in 0...10007) {
				o.push(Std.string(i).lpad(" ", 6) + " -> " + Day22.positionOf(Day22.parse(input), 10007, i));
			}
			sys.io.File.saveContent("movements.txt", o.join("\n")); */

		// trace(Day22.findCycle(input, 10021));
		// trace(Day22.shuffle(input, 10349).exists(i -> i == null) ? "invalid shuffle" : "valid shuffle");
	}
}
