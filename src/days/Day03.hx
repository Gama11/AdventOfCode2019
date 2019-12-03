package days;

import haxe.ds.HashMap;
import Util.Movement.*;
import Util.Point;

class Day03 {
	static function parse(input:String):WirePaths {
		function parsePath(line:String):Path {
			return line.split(",").map(function(instruction) {
				var direction = instruction.charAt(0);
				var length = Std.parseInt(instruction.substr(1));
				return {
					direction: (switch direction {
						case "L": Left;
						case "R": Right;
						case "U": Up;
						case "D": Down;
						case letter:
							throw 'unknown direction $letter';
					}),
					length: length
				};
			});
		}
		var lines = input.split("\n");
		return {
			first: parsePath(lines[0]),
			second: parsePath(lines[1])
		};
	}

	public static function getDistanceToClosestIntersection(input:String, distanceMetric:DistanceMetric):Int {
		var paths = parse(input);
		var centralPort = new Point(0, 0);
		var grid = new Grid();
		var intersections = [];
		function walkPath(path:Path, wire:Wire) {
			var otherWire = if (wire == First) Second else First;
			var p = centralPort;
			var steps = 0;
			for (line in path) {
				for (_ in 0...line.length) {
					p = p.add(line.direction);
					steps++;

					var cell = grid.get(p);
					if (cell == null) {
						cell = {steps: 0, wire: None};
					}
					var newSteps = steps;
					var newWire = switch cell.wire {
						case Both:
							Both;
						case wire if (wire == otherWire):
							intersections.push(p);
							newSteps += cell.steps;
							Both;
						case _:
							wire;
					};
					grid.set(p, {steps: newSteps, wire: newWire});
				}
			}
		}
		walkPath(paths.first, First);
		walkPath(paths.second, Second);
		if (intersections.length == 0) {
			throw 'no intersections';
		}
		var getDistance = if (distanceMetric == Manhattan) p -> p.distanceTo(centralPort) else p -> grid.get(p).steps;
		return intersections.min(getDistance).value;
	}
}

private typedef Line = {
	final direction:Point;
	final length:Int;
}

private typedef Path = Array<Line>;

private typedef WirePaths = {
	final first:Path;
	final second:Path;
}

private typedef Cell = {
	final steps:Int;
	final wire:Wire;
}

private enum Wire {
	First;
	Second;
	Both;
	None;
}

private typedef Grid = HashMap<Point, Cell>;

private enum DistanceMetric {
	Manhattan;
	Steps;
}
