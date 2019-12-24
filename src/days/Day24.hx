package days;

import Util.Point;
import Util.Direction;
import haxe.ds.HashMap;

class Day24 {
	static function parse(input:String):Surface {
		var surface = new Surface();
		var grid = input.split("\n").map(line -> line.split(""));
		for (y in 0...grid.length) {
			for (x in 0...grid[y].length) {
				surface.set(new Point(x, y), grid[y][x]);
			}
		}
		return surface;
	}

	static function render(surface:Surface):String {
		return Util.renderPointHash(surface, t -> t);
	}

	static function calculateBiodiversity(surface:Surface):Int {
		var biodiversity = 0;
		for (pos in surface.keys()) {
			if (surface.get(pos) == Bug) {
				biodiversity += Std.int(Math.pow(2, pos.x + 5 * pos.y));
			}
		}
		return biodiversity;
	}

	public static function findBiodiversityOfFirstDuplicate(input:String):Int {
		var surface = parse(input);
		var seen = new Map<String, Bool>();
		while (!seen.exists(render(surface))) {
			seen.set(render(surface), true);
			var next = new Surface();
			for (pos in surface.keys()) {
				var adjacentBugs = Direction.directions.map(dir -> surface.get(pos.add(dir))).filter(t -> t == Bug).length;
				var tile = surface.get(pos);
				next.set(pos, switch tile {
					case Bug if (adjacentBugs != 1): Empty;
					case Empty if (adjacentBugs == 1 || adjacentBugs == 2): Bug;
					case _: tile;
				});
			}
			surface = next;
		}
		return calculateBiodiversity(surface);
	}
}

private enum abstract Tile(String) from String to String {
	var Bug = "#";
	var Empty = ".";
}

private typedef Surface = HashMap<Point, Tile>;
