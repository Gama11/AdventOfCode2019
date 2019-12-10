package days;

import Util.Point;

class Day10 {
	public static function parse(input:String):Array<Point> {
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
		return [for (line in sightLines) line];
	}

	public static function findMonitoringStation(asteroids:Array<Point>) {
		return asteroids.max(asteroid -> findSightLines(asteroid, asteroids).length);
	}

	public static function findByVaporizationRank(input:String, rank:Int = 200):Int {
		var asteroids = parse(input);
		var station = findMonitoringStation(asteroids).list[0];
		var sightLines = findSightLines(station, asteroids);

		sightLines.sort(function(a, b) {
			function getAngle(to) {
				var angle = station.angleBetween(to);
				if (angle < 0) {
					angle += 360;
				}
				return angle;
			}
			var angleA = getAngle(a[0]);
			var angleB = getAngle(b[0]);
			return Reflect.compare(angleA, angleB);
		});

		for (line in sightLines) {
			line.sort(function(a, b) {
				return a.distanceTo(station) - b.distanceTo(station);
			});
		}

		var vaporized = 0;
		var asteroid = null;
		var i = 0;
		while (vaporized < rank) {
			asteroid = sightLines[i++].shift();
			if (asteroid != null) {
				vaporized++;
			}
			if (i >= sightLines.length) {
				i = 0;
			}
		}
		return asteroid.x * 100 + asteroid.y;
	}
}
