package days;

import Util.Direction;
import Util.Direction.*;
import Util.Point;
import haxe.ds.HashMap;

class Day15 {
	static function explore(input:String, isGoal:State->Bool) {
		var ship = new Ship();
		var start = new State(new Point(0, 0), Empty, new IntCodeVM(input));
		var shortestDistance = AStar.search(start, isGoal, s -> 0, function(state) {
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
		}).score;
		return {
			shortestDistance: shortestDistance,
			ship: ship
		};
	}

	static function render(ship:Ship):String {
		return Util.renderPointHash(ship, s -> switch s {
			case Empty: " ";
			case Wall: "#";
			case OxygenSystem: "O";
		});
	}

	public static function findShortestPath(input:String):Int {
		return explore(input, s -> s.status == OxygenSystem).shortestDistance;
	}

	public static function fillWithOxygen(input:String):Int {
		var oxygenSystem:Point;
		var ship = explore(input, function(state) {
			if (state.status == OxygenSystem) {
				oxygenSystem = state.pos;
			}
			return false;
		}).ship;
		function fill(pos:Point, time:Int):Int {
			var status = ship.get(pos);
			if (status == Wall) {
				return time;
			}
			ship.set(pos, Wall);
			return Direction.directions.max(direction -> fill(pos.add(direction), time + 1)).value;
		}
		return fill(oxygenSystem, -1);
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

	public function hashCode():String {
		return pos.toString();
	}
}

private typedef Ship = HashMap<Point, Status>;
