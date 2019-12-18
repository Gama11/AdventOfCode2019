package days;

import haxe.ds.HashMap;
import Util.Direction;
import Util.Point;

class Day18 {
	public static function findShortestPath(input:String):Int {
		var entrances = [];
		var keyCount = 0;
		var keyData = new Map<Tile, {index:Int, pos:Point}>();
		var grid = input.split("\n").map(line -> line.split(""));
		var maze = new HashMap<Point, Tile>();
		for (y in 0...grid.length) {
			for (x in 0...grid[0].length) {
				var pos = new Point(x, y);
				var tile:Tile = grid[y][x];
				if (tile == Entrance) {
					entrances.push(pos);
					tile = Empty;
				}
				if (tile.isKey()) {
					keyData.set(tile, {index: keyCount++, pos: pos});
				}
				maze.set(pos, tile);
			}
		}

		function isBlocked(doors:Int, keys:Int):Bool {
			return (doors & keys) != doors;
		}
		function setBit(field:Int, key:Tile):Int {
			return field | 1 << keyData[key].index;
		}
		final maxKeys = Std.int(Math.pow(2, keyCount) - 1);

		function findPath(from:Tile, to:Tile) {
			var start = null;
			var key = keyData[from];
			if (key == null) {
				start = entrances[Std.parseInt(from)];
			} else {
				start = key.pos;
			}
			var goal = keyData[to].pos;
			return AStar.search(new PruneState(start, 0), s -> s.pos.equals(goal), s -> s.pos.distanceTo(goal), function(state) {
				var moves = [];
				function explore(direction:Direction) {
					var newPos = state.pos.add(direction);
					var tile = maze.get(newPos);
					if (tile == Wall || (tile.isKey() && tile != to)) {
						return;
					}
					var doors = state.doors;
					if (tile.isDoor()) {
						doors = setBit(doors, tile.toLowerCase());
					}
					moves.push({
						cost: 1,
						state: new PruneState(newPos, doors)
					});
				}
				for (direction in Direction.directions) {
					explore(direction);
				}
				return moves;
			});
		}

		var paths = new Map<Tile, Map<Tile, {distance:Int, doors:Int}>>();
		var entranceIDs = [for (i in 0...entrances.length) Std.string(i)];
		var origins = entranceIDs.concat([for (key in keyData.keys()) key]);
		for (a in origins) {
			paths[a] = new Map();
			for (b in keyData.keys()) {
				if (a == b) {
					continue;
				}
				var path = findPath(a, b);
				if (path != null) {
					paths[a][b] = {distance: path.score, doors: path.state.doors};
				}
			}
		}

		return AStar.search(new SearchState(entranceIDs, 0), s -> s.keys == maxKeys, s -> (keyCount - Util.bitCount(s.keys)), function(state) {
			var moves = [];
			for (i in 0...state.positions.length) {
				var pos = state.positions[i];
				for (key in paths[pos].keys()) {
					var target = paths[pos][key];
					if (isBlocked(target.doors, state.keys)) {
						continue;
					}
					var positions = state.positions.copy();
					positions[i] = key;
					var keys = setBit(state.keys, key);
					moves.push({
						cost: target.distance,
						state: new SearchState(positions, keys)
					});
				}
			}
			return moves;
		}).score;
	}
}

private class PruneState {
	public final pos:Point;
	public final doors:Int;

	public function new(pos:Point, doors:Int) {
		this.pos = pos;
		this.doors = doors;
	}

	public function hashCode():String {
		return pos.toString();
	}
}

private class SearchState {
	public final positions:Array<String>;
	public final keys:Int;

	final hash:String;

	public function new(positions:Array<String>, keys:Int) {
		this.positions = positions;
		this.keys = keys;
		hash = keys + " " + positions;
	}

	public function hashCode():String {
		return hash;
	}
}

@:forward
private enum abstract Tile(String) from String to String {
	var Entrance = "@";
	var Wall = "#";
	var Empty = ".";

	public function isKey():Bool {
		var code = this.fastCodeAt(0);
		return code >= "a".code && code <= "z".code;
	}

	public function isDoor():Bool {
		var code = this.fastCodeAt(0);
		return code >= "A".code && code <= "Z".code;
	}
}
