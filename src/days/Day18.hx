package days;

import haxe.ds.HashMap;
import Util.Direction;
import Util.Point;

class Day18 {
	public static function findShortestPath(input:String):Int {
		var startingPos = null;
		var keyCount = 0;
		var keyIndices = new Map<Tile, Int>();
		var grid = input.split("\n").map(line -> line.split(""));
		var maze = new HashMap<Point, Tile>();
		for (y in 0...grid.length) {
			for (x in 0...grid[0].length) {
				var pos = new Point(x, y);
				var tile:Tile = grid[y][x];
				if (tile == Entrance) {
					startingPos = pos;
					tile = Empty;
				}
				if (tile.isKey()) {
					keyIndices.set(tile, keyCount++);
				}
				maze.set(pos, tile);
			}
		}

		function isLocked(keys:Int, door:Tile):Bool {
			return (keys & (1 << keyIndices[door.toLowerCase()])) == 0;
		}
		function unlock(keys:Int, key:Tile):Int {
			return keys | 1 << keyIndices[key];
		}
		final maxKeys = Std.int(Math.pow(2, keyCount) - 1);

		return AStar.search(new State(startingPos, 0), s -> s.keys == maxKeys, s -> keyCount - Util.bitCount(s.keys), function(state) {
			var moves = [];
			function explore(direction:Direction) {
				var pos = state.pos.add(direction);
				var tile = maze.get(pos);
				if (tile == Wall) {
					return;
				}
				var keys = state.keys;
				if (tile != Empty) {
					if (tile.isDoor() && isLocked(keys, tile)) {
						return;
					} else if (tile.isKey()) {
						keys = unlock(keys, tile);
					}
				}
				moves.push({
					cost: 1,
					state: new State(pos, keys)
				});
			}
			for (direction in Direction.directions) {
				explore(direction);
			}
			return moves;
		});
	}
}

private class State {
	public final pos:Point;
	public final keys:Int;

	public function new(pos:Point, keys:Int) {
		this.pos = pos;
		this.keys = keys;
	}

	public function hashCode():String {
		return keys + " " + pos;
	}
}

@:forward
private enum abstract Tile(String) from String {
	var Entrance = "@";
	var Wall = "#";
	var Empty = ".";

	public function isKey():Bool {
		return ~/[a-z]/.match(this);
	}

	public function isDoor():Bool {
		return ~/[A-Z]/.match(this);
	}
}
