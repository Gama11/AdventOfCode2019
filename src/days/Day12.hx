package days;

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

	public static function computeTotalEnergy(input:String, steps:Int):Int {
		var moons = parse(input);
		for (_ in 0...steps) {
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
		function sum(p:Point3D):Int {
			return Std.int(Math.abs(p[0]) + Math.abs(p[1]) + Math.abs(p[2]));
		}
		return moons.map(m -> sum(m.position) * sum(m.velocity)).sum();
	}
}

private typedef Moon = {
	var position:Point3D;
	var velocity:Point3D;
}

private typedef Point3D = Array<Int>;
