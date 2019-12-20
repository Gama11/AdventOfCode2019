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
				grid.set(pos, switch char {
					case ".": Passage;
					case "#": Wall;
					case letter: Letter(letter);
				});
			}
		}
		var start = null;
		var end = null;
		var portals = new Map<String, Point>();
		// process labels
		for (pos in grid.keys()) {
			var tile = grid.get(pos);
			switch tile {
				case Letter(l1):
					var adjacentPositions = [Up, Down, Left, Right].map(dir -> pos.add(dir));
					var adjacentTiles = adjacentPositions.map(pos -> grid.get(pos));
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
								grid.set(a, Portal(label, b));
								grid.set(b, Portal(label, a));
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

	public static function findShortestPath(input:String):Int {
		var maze = parse(input);
		return AStar.search(new State(maze.start), s -> s.pos.equals(maze.end), s -> 0, function(state) {
			var moves = [];
			function explore(dir:Direction) {
				var pos = state.pos.add(dir);
				switch maze.grid.get(pos) {
					case null | Wall | Letter(_):
					case Passage:
						moves.push({
							cost: 1,
							state: new State(pos)
						});
					case Portal(_, target):
						moves.push({
							cost: 2,
							state: new State(target)
						});
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
	Portal(label:String, target:Point);
}

private class State {
	public final pos:Point;

	public function new(pos:Point) {
		this.pos = pos;
	}

	public function hashCode():String {
		return pos.toString();
	}
}
