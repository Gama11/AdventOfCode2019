package days;

import Util.Point;
import Util.Direction;
import Util.Direction.*;
import haxe.ds.HashMap;

class Day24 {
	inline static final GridSize = 5;
	inline static final Center = Std.int(GridSize / 2);

	static function parse(input:String):Surface {
		var surface = new Surface();
		var grid = input.split("\n").map(line -> line.split(""));
		for (y in 0...grid.length) {
			for (x in 0...grid[y].length) {
				surface[new Point(x, y)] = grid[y][x];
			}
		}
		return surface;
	}

	static function render(surface:Surface):String {
		return Util.renderPointHash(surface, t -> t);
	}

	static function calculateBiodiversity(surface:Surface):Int {
		var biodiversity = 0;
		for (pos => tile in surface) {
			if (tile == Bug) {
				biodiversity += Std.int(Math.pow(2, pos.x + GridSize * pos.y));
			}
		}
		return biodiversity;
	}

	static function countAdjacentBugs(surface:Surface, pos:Point):Int {
		return Direction.directions.count(dir -> surface[pos + dir] == Bug);
	}

	static function nextTile(current:Tile, adjacentBugs:Int):Tile {
		return switch current {
			case Bug if (adjacentBugs != 1): Empty;
			case Empty if (adjacentBugs == 1 || adjacentBugs == 2): Bug;
			case _: current;
		}
	}

	public static function findBiodiversityOfFirstDuplicate(input:String):Int {
		var surface = parse(input);
		var seen = new Map<String, Bool>();
		while (!seen.exists(render(surface))) {
			seen[render(surface)] = true;
			var next = new Surface();
			for (pos => tile in surface) {
				var adjacentBugs = countAdjacentBugs(surface, pos);
				next[pos] = nextTile(tile, adjacentBugs);
			}
			surface = next;
		}
		return calculateBiodiversity(surface);
	}

	public static function countBugsWithRecursiveSurfaces(input:String, minutes:Int):Int {
		var surfaces = new RecursiveSurface();
		function addLevel(surfaces:RecursiveSurface, depth:Int, surface:Surface) {
			surface[new Point(Center, Center)] = Inner;
			surfaces[depth] = surface;
			return surface;
		}
		function emptySurface() {
			var surface = new Surface();
			for (x in 0...GridSize) {
				for (y in 0...GridSize) {
					surface[new Point(x, y)] = Empty;
				}
			}
			return surface;
		}
		addLevel(surfaces, -1, emptySurface());
		addLevel(surfaces, 0, parse(input));
		addLevel(surfaces, 1, emptySurface());

		function processTile(nextSurfaces, depth, surface, pos) {
			var adjacentBugs = countAdjacentBugs(surface, pos);
			function expand(direction:Int):Null<Surface> {
				var level = depth + direction;
				if (surfaces.exists(level)) {
					return surfaces[level];
				}
				if (adjacentBugs > 0) {
					return addLevel(nextSurfaces, level, emptySurface());
				}
				return null;
			}
			var recursiveBugs = 0;
			function check(surface:Surface, pos:Point) {
				if (surface[pos] == Bug) {
					recursiveBugs++;
				}
			}
			for (dir in Direction.directions) {
				switch surface[pos + dir] {
					case Inner:
						var inner = expand(1);
						if (inner == null) {
							break;
						}
						function walk(pos:Point, dir:Direction) {
							for (_ in 0...GridSize) {
								check(inner, pos);
								pos += dir;
							}
						}
						switch dir {
							case Left: walk(new Point(GridSize - 1, 0), Down);
							case Right: walk(new Point(0, 0), Down);
							case Up: walk(new Point(0, GridSize - 1), Right);
							case Down: walk(new Point(0, 0), Right);
						}
					case Outer:
						var outer = expand(-1);
						if (outer != null) {
							check(outer, new Point(Center, Center) + dir);
						}
					case _:
				}
			}
			return nextTile(surface[pos], adjacentBugs + recursiveBugs);
		}
		for (_ in 0...minutes) {
			var nextSurfaces = new RecursiveSurface();
			for (depth => surface in surfaces) {
				var next = new Surface();
				for (pos in surface.keys()) {
					next[pos] = processTile(nextSurfaces, depth, surface, pos);
				}
				nextSurfaces[depth] = next;
			}
			surfaces = nextSurfaces;
		}
		return surfaces.map(surface -> [for (tile in surface) tile].count(tile -> tile == Bug)).sum();
	}
}

private enum abstract Tile(String) from String to String {
	var Bug = "#";
	var Empty = ".";
	var Inner = "?";
	var Outer = null;
}

private typedef Surface = HashMap<Point, Tile>;
private typedef RecursiveSurface = Map<Int, Surface>;
