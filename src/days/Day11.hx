package days;

import Util.Point;
import Util.Direction.*;
import haxe.ds.HashMap;

class Day11 {
	static function paint(program:String, initialColor:Color):Hull {
		var hull = new Hull();
		var position = new Point(0, 0);
		hull.set(position, initialColor);
		var facing = Up;
		var robot = new IntCodeVM(program);
		while (true) {
			var color = hull.get(position);
			if (color == null) {
				color = Black;
			}
			robot.write(color).run();
			if (robot.finished) {
				return hull;
			}
			var color = robot.read().toInt();
			hull.set(position, color);

			var turn = robot.read().toInt();
			facing = facing.rotate(if (turn == CounterClockwise) -1 else 1);
			position = position.add(facing);
		}
	}

	public static function countPaintedPanels(program:String):Int {
		return [for (panel in paint(program, Black).keys()) panel].length;
	}

	public static function renderRegistrationIdentifier(program:String):String {
		var hull = paint(program, White);
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
