package days;

import Util.Point;
import haxe.ds.HashMap;

class Day13 {
	public static function countBlocks(program:String):Int {
		var screen = new HashMap<Point, Tile>();
		var game = new IntCodeVM(program).run();
		while (game.hasOutput()) {
			var tile = game.read().int();
			var y = game.read().int();
			var x = game.read().int();
			screen.set(new Point(x, y), tile);
		}	
		return [for (tile in screen) tile].count(t -> t == Block);
	}
}

private enum abstract Tile(Int) from Int {
	var Empty;
	var Wall;
	var Block;
	var Padle;
	var Ball;
}
