import polygonal.ds.Hashable;

class Util {
	public static function mod(a:Int, b:Int) {
		var r = a % b;
		return r < 0 ? r + b : r;
	}

	public static function findBounds(points:Array<Point>) {
		final n = 9999999;
		var maxX = -n;
		var maxY = -n;
		var minX = n;
		var minY = n;
		for (pos in points) {
			maxX = Std.int(Math.max(maxX, pos.x));
			maxY = Std.int(Math.max(maxY, pos.y));
			minX = Std.int(Math.min(minX, pos.x));
			minY = Std.int(Math.min(minY, pos.y));
		}
		return {
			min: new Point(minX, minY),
			max: new Point(maxX, maxY)
		};
	}

	public static function renderPointGrid(points:Array<Point>, render:Point->String, empty = " "):String {
		var bounds = findBounds(points);
		var min = bounds.min;
		var max = bounds.max;

		var grid = [for (_ in 0...max.y - min.y + 1) [for (_ in 0...max.x - min.x + 1) empty]];
		for (pos in points) {
			grid[pos.y - min.y][pos.x - min.x] = render(pos);
		}
		return grid.map(row -> row.join("")).join("\n") + "\n";
	}
}

class StaticExtensions {
	public static function matchedInt(reg:EReg, n:Int):Null<Int> {
		return Std.parseInt(reg.matched(n));
	}

	public static function sum(a:Array<Int>):Int {
		return a.fold((a, b) -> a + b, 0);
	}

	public static function max<T>(a:Array<T>, f:T->Int) {
		var maxValue:Null<Int> = null;
		var list = [];
		for (e in a) {
			var value = f(e);
			if (maxValue == null || value > maxValue) {
				maxValue = value;
				list = [e];
			} else if (value == maxValue) {
				list.push(e);
			}
		}
		return {list: list, value: maxValue};
	}

	public static function min<T>(a:Array<T>, f:T->Int) {
		var minValue:Null<Int> = null;
		var list = [];
		for (e in a) {
			var value = f(e);
			if (minValue == null || value < minValue) {
				minValue = value;
				list = [e];
			} else if (value == minValue) {
				list.push(e);
			}
		}
		return {list: list, value: minValue};
	}

	public static function count<T>(a:Array<T>, f:T->Bool):Int {
		var count = 0;
		for (e in a) {
			if (f(e)) {
				count++;
			}
		}
		return count;
	}

	public static function tuples<T>(a:Array<T>):Array<{a:T, b:T}> {
		var result = [];
		for (e1 in a) {
			for (e2 in a) {
				if (e1 != e2) {
					result.push({a: e1, b: e2});
				}
			}
		}
		return result;
	}
}

class Point implements Hashable {
	public final x:Int;
	public final y:Int;

	public var key(default, null):Int;

	public inline function new(x, y) {
		this.x = x;
		this.y = y;
		key = hashCode();
	}

	public function hashCode():Int {
		return x + 10000 * y;
	}

	public inline function add(point:Point):Point {
		return new Point(x + point.x, y + point.y);
	}

	public inline function scale(n:Int):Point {
		return new Point(x * n, y * n);
	}

	public inline function invert():Point {
		return new Point(-x, -y);
	}

	public function distanceTo(point:Point):Int {
		return Std.int(Math.abs(x - point.x) + Math.abs(y - point.y));
	}

	public function angleBetween(point:Point):Float {
		// from FlxPoint
		var x:Float = point.x - x;
		var y:Float = point.y - y;
		var angle:Float = 0;
		if (x != 0 || y != 0) {
			var c1:Float = Math.PI * 0.25;
			var c2:Float = 3 * c1;
			var ay:Float = (y < 0) ? -y : y;

			if (x >= 0) {
				angle = c1 - c1 * ((x - ay) / (x + ay));
			} else {
				angle = c2 - c1 * ((x + ay) / (ay - x));
			}
			angle = ((y < 0) ? -angle : angle) * (180 / Math.PI);

			if (angle > 90) {
				angle = angle - 270;
			} else {
				angle += 90;
			}
		}
		return angle;
	}

	public inline function equals(point:Point):Bool {
		return x == point.x && y == point.y;
	}

	public function shortString():String {
		return '$x,$y';
	}

	function toString():String {
		return '($x, $y)';
	}
}

abstract Direction(Point) to Point {
	public static final Left = new Direction(-1, 0);
	public static final Up = new Direction(0, -1);
	public static final Down = new Direction(0, 1);
	public static final Right = new Direction(1, 0);

	private function new(x:Int, y:Int) {
		this = new Point(x, y);
	}

	private static final directions = [Left, Up, Right, Down];

	public function rotate(by:Int):Direction {
		var i = directions.indexOf((cast this : Direction)) + by;
		return directions[Util.mod(i, directions.length)];
	}

	public function toString() {
		return switch (this) {
			case Left: "Left";
			case Up: "Up";
			case Down: "Down";
			case Right: "Right";
			case _: "unknown direction";
		}
	}
}
