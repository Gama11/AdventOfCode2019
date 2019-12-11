package days;

import Util.Point;
import Util.Direction.*;
import haxe.ds.HashMap;

class Day11 {
	public static function countPaintedPanels(input:String):Int {
		var panels = new HashMap<Point, Color>();
		var position = new Point(0, 0);
		var facing = Up;
		var memory = Day05.parseProgram(input);
		var pointer = 0;
		while (true) {
			var color = panels.get(position);
			if (color == null) {
				color = Black;
			}
			var result = Day05.runIntcode(memory, [color], pointer);
			switch result {
				case Blocked(i, outputs):
					if (outputs.length != 2) {
						throw 'two outputs expected, got ${outputs.length}';
					}
					pointer = i;

					var color = Std.int(outputs[0]);
					panels.set(position, color);

					var turn = Std.int(outputs[1]);
					facing = facing.rotate(if (turn == CounterClockwise) -1 else 1);
					position = position.add(facing);

				case Finished(_):
					return [for (panel in panels.keys()) panel].length;
			}
		}
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
