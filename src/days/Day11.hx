package days;

import Util.Point;
import Util.Direction.*;
import haxe.ds.HashMap;

class Day11 {
	static function paint(input:String, initialColor:Color):Hull {
		var hull = new Hull();
		var position = new Point(0, 0);
		hull.set(position, initialColor);
		var facing = Up;
		var memory = Day05.parseProgram(input);
		var pointer = 0;
		var relativeBase = 0;
		while (true) {
			var color = hull.get(position);
			if (color == null) {
				color = Black;
			}
			var result = Day05.runIntcode(memory, [color], pointer, relativeBase);
			switch result {
				case Blocked(i, outputs, base):
					if (outputs.length != 2) {
						throw 'two outputs expected, got ${outputs.length}';
					}
					pointer = i;
					relativeBase = base;

					var color = Std.int(outputs[0]);
					hull.set(position, color);

					var turn = Std.int(outputs[1]);
					facing = facing.rotate(if (turn == CounterClockwise) -1 else 1);
					position = position.add(facing);

				case Finished(_):
					return hull;
			}
		}
	}

	public static function countPaintedPanels(input:String):Int {
		return [for (panel in paint(input, Black).keys()) panel].length;
	}

	public static function renderRegistrationIdentifier(input:String):String {
		var hull = paint(input, White);
		return Util.renderPointGrid([for (p in hull.keys()) p], p -> if (hull.get(p) == White) "█" else " ");
	}
}

private enum abstract Color(Int) from Int to Int {
	var Black;
	var White;
}

private enum abstract Turn(Int) from Int {
	var CounterClockwise;
	var Clockwise;
}

private typedef Hull = HashMap<Point, Color>;
