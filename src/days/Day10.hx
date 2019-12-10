package days;

import Util.Point;

class Day10 {
	static function parse(input:String):Array<Point> {
		var grid = input.split("\n").map(line -> line.split(""));
		var asteroids = [];
		for (y in 0...grid.length) {
			var row = grid[y];
			for (x in 0...row.length) {
				if (row[x] == "#") {
					asteroids.push(new Point(x, y));
				}
			}
		}
		return asteroids;
	}

	static function findSightLines(asteroid:Point, asteroids:Array<Point>) {
		var sightLines = new Map<Int, Array<Point>>();
		for (other in asteroids) {
			if (other == asteroid) {
				continue;
			}
			var direction = asteroid.angleBetween(other);
			function hash(angle:Float):Int {
				return Std.int(angle * 100000);
			}
			var sightLine = sightLines[hash(direction)];
			if (sightLine == null) {
				sightLine = [];
				sightLines[hash(direction)] = sightLine;
			}
			sightLine.push(other);
		}
		return [for (line in sightLines.keys()) line].length;
	}

	public static function findMostAsteroidDetections(input:String):Int {
		var asteroids = parse(input);
		return asteroids.max(findSightLines.bind(_, asteroids)).value;
	}
}
