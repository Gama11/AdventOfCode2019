package days;

import Util.Direction;
import Util.Direction.*;
import Util.Point;
import haxe.ds.HashMap;

class Day15 {
	public static function findShortestPath(input:String):Int {
		var ship = new HashMap<Point, Status>();
		var start = new State(new Point(0, 0), Empty, new IntCodeVM(input));
		return AStar.search(start, s -> 0, function(state) {
			var moves = [];
			function explore(direction:Direction) {
				var pos = state.pos.add(direction);
				if (ship.get(pos) == Wall) {
					return;
				}
				var vm = state.vm.copy();
				var status = vm.write(switch direction {
					case Left: West;
					case Right: East;
					case Up: North;
					case Down: South;
					case _: throw 'unknown direction';
				}).run().read().toInt();
				ship.set(pos, status);
				if (status == Wall) {
					return;
				}
				moves.push({
					cost: 1,
					state: new State(pos, status, vm)
				});
			}
			for (direction in Direction.directions) {
				explore(direction);
			}
			return moves;
		});
	}
}

private enum abstract Movement(Int) to Int {
	var North = 1;
	var South;
	var West;
	var East;
}

private enum abstract Status(Int) from Int {
	var Wall;
	var Empty;
	var OxygenSystem;
}

private class State {
	public final pos:Point;
	public final status:Status;
	public final vm:IntCodeVM;

	public function new(pos:Point, status:Status, vm:IntCodeVM) {
		this.pos = pos;
		this.status = status;
		this.vm = vm;
	}

	public function hashCode():Int {
		return pos.hashCode();
	}

	public function isGoal():Bool {
		return status == OxygenSystem;
	}
}
