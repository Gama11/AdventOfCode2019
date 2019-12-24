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
				biodiversity += Std.int(Math.pow(2, pos.x + GridSize * pos.y));
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

	public static function countBugsWithRecursiveSurfaces(input:String, minutes:Int):Int {
		var surfaces = new RecursiveSurface();
		function add(surfaces:RecursiveSurface, depth:Int, surface:Surface) {
			surface.set(new Point(Center, Center), Inner);
			surfaces[depth] = surface;
			return surface;
		}
		function emptySurface() {
			var surface = new Surface();
			for (x in 0...GridSize) {
				for (y in 0...GridSize) {
					surface.set(new Point(x, y), Empty);
				}
			}
			return surface;
		}
		add(surfaces, -1, emptySurface());
		add(surfaces, 0, parse(input));
		add(surfaces, 1, emptySurface());

		for (_ in 0...minutes) {
			var nextSurfaces = new RecursiveSurface();
			for (depth => surface in surfaces) {
				var next = new HashMap();
				for (pos in surface.keys()) {
					var tile = surface.get(pos);
					var adjacentBugs = Direction.directions.filter(dir -> surface.get(pos.add(dir)) == Bug).length;
					function expand(direction:Int):Null<Surface> {
						var level = depth + direction;
						if (surfaces.exists(level)) {
							return surfaces.get(level);
						}
						if (adjacentBugs > 0) {
							return add(nextSurfaces, level, emptySurface());
						}
						return null;
					}
					var recursiveBugs = 0;
					for (dir in Direction.directions) {
						var neighbour = pos.add(dir);
						function check(surface:Surface, x:Int, y:Int) {
							if (surface.get(new Point(x, y)) == Bug) {
								recursiveBugs++;
							}
						}
						switch surface.get(neighbour) {
							case null:
								var outer = expand(-1);
								if (outer != null) {
									check(outer, Center + dir.x, Center + dir.y);
								}
							case Inner:
								var inner = expand(1);
								if (inner != null) {
									switch dir {
										case Left:
											for (y in 0...GridSize) {
												check(inner, GridSize - 1, y);
											}
										case Right:
											for (y in 0...GridSize) {
												check(inner, 0, y);
											}
										case Up:
											for (x in 0...GridSize) {
												check(inner, x, GridSize - 1);
											}
										case Down:
											for (x in 0...GridSize) {
												check(inner, x, 0);
											}
									}
								}
							case _:
						}
					}
					adjacentBugs += recursiveBugs;
					next.set(pos, switch tile {
						case Bug if (adjacentBugs != 1): Empty;
						case Empty if (adjacentBugs == 1 || adjacentBugs == 2): Bug;
						case _: tile;
					});
				}
				nextSurfaces[depth] = next;
			}
			surfaces = nextSurfaces;
		}
		return surfaces.map(surface -> [for (tile in surface) if (tile == Bug) tile].length).sum();
	}
}

private enum abstract Tile(String) from String to String {
	var Bug = "#";
	var Empty = ".";
	var Inner = "?";
}

private typedef Surface = HashMap<Point, Tile>;
private typedef RecursiveSurface = Map<Int, Surface>;
