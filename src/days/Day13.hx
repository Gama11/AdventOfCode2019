package days;

import Util.Point;
import haxe.ds.HashMap;

class Day13 {
	static function update(screen:Screen, game:IntCodeVM) {
		game.run();
		while (game.hasOutput()) {
			var x = game.read().toInt();
			var y = game.read().toInt();
			var tile = game.read().toInt();
			screen.set(new Point(x, y), tile);
		}
	}

	static function render(screen:Screen) {
		return Util.renderPointHash(screen, tile -> switch tile {
			case Empty: " ";
			case Wall: "█";
			case Block: "▄";
			case Paddle: "_";
			case Ball: "o";
		});
	}

	public static function countBlocks(program:String):Int {
		var screen = new Screen();
		var game = new IntCodeVM(program).run();
		update(screen, game);
		return [for (tile in screen) tile].count(t -> t == Block);
	}

	public static function beatGame(program:String):Int {
		var screen = new Screen();
		var game = new IntCodeVM(program);
		game.memory[0] = 2;
		update(screen, game);

		var prevBallPos = new Point(0, 0);
		while (!game.finished) {
			// Sys.println(render(screen));
			// Sys.sleep(1 / 60);

			var paddlePos = new Point(0, 0);
			var ballPos = new Point(0, 0);
			for (pos in screen.keys()) {
				switch screen.get(pos) {
					case Paddle:
						paddlePos = pos;
					case Ball:
						ballPos = pos;
					case _:
				}
			}
			var ballVelocity = ballPos.subtract(prevBallPos);
			var targetPos = if (ballVelocity.y > 0 && ballPos.y > 20) {
				ballPos.add(ballVelocity.scale(paddlePos.y - ballPos.y));
			} else {
				ballPos;
			}
			game.write(if (targetPos.x < paddlePos.x) {
				TiltLeft;
			} else if (targetPos.x > paddlePos.x) {
				TiltRight;
			} else {
				Neutral;
			});

			update(screen, game);
			prevBallPos = ballPos;
		}
		return screen.get(new Point(-1, 0));
	}
}

private typedef Screen = HashMap<Point, Tile>;

private enum abstract Tile(Int) from Int to Int {
	var Empty;
	var Wall;
	var Block;
	var Paddle;
	var Ball;
}

private enum abstract JoystickInput(Int) to Int {
	var Neutral = 0;
	var TiltLeft = -1;
	var TiltRight = 1;
}
