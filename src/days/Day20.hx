package days;

import Util.Point;
import Util.Direction;
import Util.Direction.*;
import haxe.ds.HashMap;

class Day20 {
	static function parse(input:String):Maze {
		var gridArray = input.split("\n").map(line -> line.split(""));
		var grid = new Grid();
		// char array -> enum map
		for (y in 0...gridArray.length) {
			for (x in 0...gridArray[y].length) {
				var pos = new Point(x, y);
				var char = gridArray[y][x];
				if (char == " ") {
					continue;
				}
				grid[pos] = switch char {
					case ".": Passage;
					case "#": Wall;
					case letter: Letter(letter);
				};
			}
		}
		var max = new Point(gridArray[0].length, gridArray.length);
		var start = null;
		var end = null;
		var portals = new Map<String, Point>();
		// process labels
		for (pos => tile in grid) {
			switch tile {
				case Letter(l1):
					var adjacentPositions = [Up, Down, Left, Right].map(dir -> pos + dir);
					var adjacentTiles = adjacentPositions.map(pos -> grid[pos]);
					var label = null;
					var labelledPos = null;
					switch adjacentTiles {
						case [Letter(l2), Passage, _, _]:
							label = l2 + l1;
							labelledPos = adjacentPositions[1];
						case [Passage, Letter(l2), _, _]:
							label = l1 + l2;
							labelledPos = adjacentPositions[0];
						case [_, _, Letter(l2), Passage]:
							label = l2 + l1;
							labelledPos = adjacentPositions[3];
						case [_, _, Passage, Letter(l2)]:
							label = l1 + l2;
							labelledPos = adjacentPositions[2];
						case _:
					}
					if (label == null || labelledPos == null) {
						continue;
					}
					switch label {
						case "AA": start = labelledPos;
						case "ZZ": end = labelledPos;
						case _:
							var a = labelledPos;
							var b = portals[label];
							if (b == null) {
								portals[label] = a;
							} else {
								// connect the portal
								var d = 3;
								var outer = pos.x < d || pos.x > max.x - d || pos.y < d || pos.y > max.y - d;
								grid[a] = Portal(label, b, outer);
								grid[b] = Portal(label, a, !outer); 
							}
					}

				case _:
			}
		}
		if (start == null || end == null) {
			throw "no start or end found";
		}
		return {
			start: start,
			end: end,
			grid: grid
		};
	}

	public static function findShortestPath(input:String, recursive:Bool):Int {
		var maze = parse(input);
		var start = new State(0, maze.start);
		var end = new State(0, maze.end);
		return AStar.search(start, s -> s.hashCode() == end.hashCode(), s -> s.level, function(state) {
			var moves = [];
			function explore(dir:Direction) {
				var pos = state.pos + dir;
				switch maze.grid[pos] {
					case null | Wall | Letter(_):
					case Passage:
						moves.push({
							cost: 1,
							state: new State(state.level, pos)
						});
					case Portal(_, target, outer):
						var level = state.level;
						if (recursive) {
							level += if (outer) -1 else 1;
						}
						if (level >= 0) {
							moves.push({
								cost: 2,
								state: new State(level, target)
							});
						}
				}
			}
			for (direction in Direction.directions) {
				explore(direction);
			}
			return moves;
		}).score;
	}
}

private typedef Maze = {
	final start:Point;
	final end:Point;
	final grid:Grid;
}

private typedef Grid = HashMap<Point, Tile>;

private enum Tile {
	Wall;
	Passage;
	Letter(letter:String);
	Portal(label:String, target:Point, outer:Bool);
}

private class State {
	public final level:Int;
	public final pos:Point;

	public function new(level:Int, pos:Point) {
		this.level = level;
		this.pos = pos;
	}

	public function hashCode():String {
		return level + " " + pos.toString();
	}
}
