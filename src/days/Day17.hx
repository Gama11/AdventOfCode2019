package days;

import Util.Point;
import Util.Direction.*;
import haxe.ds.HashMap;

class Day17 {
	public static function calculateAlignmentParameterSum(output:String):Int {
		var image = outputToImage(output);
		var sum = 0;
		for (pos => tile in image) {
			function peek(direction) {
				return image[pos + direction];
			}
			if (tile == Scaffolding && peek(Left) == Scaffolding && peek(Right) == Scaffolding && peek(Up) == Scaffolding && peek(Down) == Scaffolding) {
				sum += pos.x * pos.y;
			}
		}
		return sum;
	}

	public static function calibrateCameras(program:String):Int {
		return calculateAlignmentParameterSum(getInitialCameraOutput(program));
	}

	static function outputToImage(output:String):Image {
		var grid = output.split("\n").map(line -> line.split(""));
		var image = new Image();
		for (y in 0...grid.length) {
			for (x in 0...grid[0].length) {
				image[new Point(x, y)] = grid[y][x];
			}
		}
		return image;
	}

	static function getInitialCameraOutput(program:String):String {
		return new IntCodeVM(program).run().readString();
	}

	static function findFullPath(image:Image):Array<Move> {
		var pos = null;
		var dir = null;
		for (p => tile in image) {
			dir = switch tile {
				case RobotLeft: Left;
				case RobotRight: Right;
				case RobotUp: Up;
				case RobotDown: Down;
				case _: null;
			}
			if (dir != null) {
				pos = p;
				break;
			}
		}
		var moves = [];
		var run = 0;
		while (true) {
			var nextTile = image[pos + dir];
			if (nextTile == Scaffolding) {
				run++;
				pos += dir;
			} else {
				if (run > 0) {
					moves.push(Forward(run));
					run = 0;
				}
				// try to turn
				var left = dir.rotate(-1);
				if (image[pos + left] == Scaffolding) {
					dir = left;
					moves.push(TurnLeft);
					continue;
				}
				var right = dir.rotate(1);
				if (image[pos + right] == Scaffolding) {
					dir = right;
					moves.push(TurnRight);
					continue;
				}
				// nowhere to go
				return moves;
			}
		}
	}

	public static function warnRobots(program:String):Int {
		/* var fullPath = findFullPath(outputToImage(getInitialCameraOutput(program)));
			var path = fullPath.map(move -> switch move {
				case Forward(units): Std.string(units);
				case TurnLeft: "L";
				case TurnRight: "R";
		}).join(",");*/

		var main = "A,B,A,C,B,C,A,C,B,C";
		var a = "L,8,R,10,L,10";
		var b = "R,10,L,8,L,8,L,10";
		var c = "L,4,L,6,L,8,L,8";
		var input = [main, a, b, c, "n"].join("\n") + "\n";

		var vm = new IntCodeVM(program);
		vm.memory[0] = 2;
		for (char in input) {
			vm.write(char);
		}
		vm.run();
		var output = 0;
		while (vm.hasOutput()) {
			output = vm.read().toInt();
		}
		return output;
	}
}

private typedef Image = HashMap<Point, Tile>;

private enum abstract Tile(String) from String {
	var Scaffolding = "#";
	var Space = ".";
	var RobotLeft = "<";
	var RobotRight = ">";
	var RobotUp = "^";
	var RobotDown = "v";
	var RobotDead = "X";
}

private enum Move {
	Forward(units:Int);
	TurnLeft;
	TurnRight;
}
