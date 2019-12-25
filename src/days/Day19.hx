package days;

import haxe.ds.HashMap;
import Util.Point;

class Day19 {
	static function drawTractorBeam(program:String, size:Int):TractorBeam {
		var droneSystem = new IntCodeVM(program);
		var beam = new TractorBeam();
		for (x in 0...size) {
			for (y in 0...size) {
				if (isBeingPulled(droneSystem, x, y)) {
					beam[new Point(x, y)] = true;
				}
			}
		}
		return beam;
	}

	public static function countPointsAffectedByBeam(program:String):Int {
		return [for (_ in drawTractorBeam(program, 50)) _].length;
	}

	static function isBeingPulled(droneSystem:IntCodeVM, x:Int, y:Int):Bool {
		return droneSystem.copy().write(x).write(y).run().read().toInt() == BeingPulled;
	}

	public static function findClosestPossibleShipLocation(program:String):Int {
		var shipSize = 100;
		var droneSystem = new IntCodeVM(program);
		function inBeam(x, y) {
			return isBeingPulled(droneSystem, x, y);
		}
		var prevLowest = 4;
		var x = 5;
		while (true) {
			var lowest:Null<Int> = null;
			for (i in -1...2) {
				var y = prevLowest + i;
				if (inBeam(x, y) && (lowest == null || y < lowest)) {
					lowest = y;
				}
			}
			var upperLeft = new Point(x - (shipSize - 1), lowest);
			if (inBeam(upperLeft.x, upperLeft.y + (shipSize - 1))) {
				return upperLeft.x * 10000 + upperLeft.y;
			}
			prevLowest = lowest;
			x++;
		}
	}
}

private enum abstract DroneStatus(Int) from Int {
	var Stationary;
	var BeingPulled;
}

private typedef TractorBeam = HashMap<Point, Bool>;
