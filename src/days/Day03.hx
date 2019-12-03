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

	public static function getDistanceToClosestIntersection(input:String):Int {
		var paths = parse(input);
		var centralPort = new Point(0, 0);
		var grid = new Grid();
		var intersections = [];
		function walkPath(path:Path, wire:Wire) {
			var otherWire = if (wire == First) Second else First;
			var p = centralPort;
			for (line in path) {
				for (_ in 0...line.length) {
					p = p.add(line.direction);
					var previous = grid.get(p);
					grid.set(p, switch previous {
						case Both:
							Both;
						case wire if (wire == otherWire):
							intersections.push(p);
							Both;
						case _:
							wire;
					});
				}
			}
		}
		walkPath(paths.first, First);
		walkPath(paths.second, Second);
		if (intersections.length == 0) {
			throw 'no intersections';
		}
		return intersections.min(p -> p.distanceTo(centralPort)).value;
	}

	static function debug(grid:Grid) {
		trace("\n" + Util.renderPointGrid([
			for (point in grid.keys()) {
				point;
			}
		], point -> switch grid.get(point) {
			case First: "A";
			case Second: "B";
			case Both: "X";
		}));
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

private enum Wire {
	First;
	Second;
	Both;
}

private typedef Grid = HashMap<Point, Wire>;
