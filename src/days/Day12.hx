package days;

import haxe.Int64;

class Day12 {
	static function parse(input:String):Array<Moon> {
		var regex = ~/<x=(-?\d+), y=(-?\d+), z=(-?\d+)>/;
		return input.split("\n").map(function(line) {
			if (!regex.match(line)) {
				throw '$line doesn\'t match';
			}
			return {
				position: [regex.matchedInt(1), regex.matchedInt(2), regex.matchedInt(3)],
				velocity: [0, 0, 0]
			};
		});
	}

	static function simulate(moons:Array<Moon>) {
		function updateVelocities(a:Moon, b:Moon) {
			function updateAxis(i:Int) {
				if (a.position[i] > b.position[i]) {
					a.velocity[i]--;
					b.velocity[i]++;
				} else if (a.position[i] < b.position[i]) {
					a.velocity[i]++;
					b.velocity[i]--;
				}
			}
			for (i in 0...3) {
				updateAxis(i);
			}
		}
		updateVelocities(moons[0], moons[1]);
		updateVelocities(moons[0], moons[2]);
		updateVelocities(moons[0], moons[3]);
		updateVelocities(moons[1], moons[2]);
		updateVelocities(moons[1], moons[3]);
		updateVelocities(moons[2], moons[3]);

		for (moon in moons) {
			function updateAxis(i:Int) {
				moon.position[i] += moon.velocity[i];
			}
			for (i in 0...3) {
				updateAxis(i);
			}
		}
	}

	public static function computeTotalEnergy(input:String, steps:Int):Int {
		var moons = parse(input);
		for (_ in 0...steps) {
			simulate(moons);
		}
		function sum(p:Point3D):Int {
			return Std.int(Math.abs(p[0]) + Math.abs(p[1]) + Math.abs(p[2]));
		}
		return moons.map(m -> sum(m.position) * sum(m.velocity)).sum();
	}

	static function greatestCommonDivisor(a:Int64, b:Int64):Int64 {
		return if (b == 0) a else greatestCommonDivisor(b, Util.mod64(a, b));
	}

	static function leastCommonMultiple(a:Int64, b:Int64):Int64 {
		var product = a * b;
		if (product < 0) {
			product *= -1;
		}
		return product / greatestCommonDivisor(a, b);
	}

	public static function findCycle(input:String):Int64 {
		var moons = parse(input);
		var step = 0;
		var states = [for (_ in 0...3) new Map<String, Bool>()];
		var startingPoints = [];
		var loops = [];
		while (true) {
			function checkAxis(axis:Int) {
				var state = states[axis];
				var startingPoint = startingPoints[axis];
				var key = Std.string([for (moon in moons) moon.position[axis] + "," + moon.velocity[axis]]);
				if (state.exists(key)) {
					if (startingPoint == null) {
						startingPoint = {step: step, key: key};
					} else if (startingPoint.key == key) {
						loops[axis] = {start: startingPoint.step, end: step, range: step - startingPoint.step};
					}
				} else {
					startingPoint = null;
				}
				state[key] = true;
				startingPoints[axis] = startingPoint;
			}
			for (i in 0...3) {
				checkAxis(i);
			}
			if (loops[0] != null && loops[1] != null && loops[2] != null) {
				break;
			}

			simulate(moons);
			step++;
		}
		return leastCommonMultiple(loops[0].start, leastCommonMultiple(loops[1].start, loops[2].start));
	}
}

private typedef Moon = {
	var position:Point3D;
	var velocity:Point3D;
}

private typedef Point3D = Array<Int>;
