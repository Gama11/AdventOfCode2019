import haxe.ds.HashMap;
import polygonal.ds.PriorityQueue;
import Util.PrioritizedItem;

class AStar {
	public static function search<T:State>(start:T, score:T->Int, getMoves:T->Array<Move<T>>):Null<Int> {
		var scores = new HashMap<T, Score>();
		scores.set(start, {
			g: 0,
			f: score(start)
		});
		var closedSet = new HashMap<T, Bool>();
		var openSet = new PriorityQueue(1, true, [new PrioritizedItem(start, score(start))]);

		while (openSet.size > 0) {
			var current = openSet.dequeue().item;
			closedSet.set(current, true);

			var currentScore = scores.get(current).g;
			if (current.isGoal()) {
				return currentScore;
			}

			for (move in getMoves(current)) {
				if (closedSet.exists(move.state)) {
					continue;
				}
				var node = scores.get(move.state);
				var scoreAfterMove = currentScore + move.cost;
				if (node == null || node.g > scoreAfterMove) {
					var score = {
						g: scoreAfterMove,
						f: scoreAfterMove + score(move.state)
					};
					scores.set(move.state, score);
					openSet.enqueue(new PrioritizedItem(move.state, score.f));
				}
			}
		}

		return null;
	}
}

typedef Move<T> = {
	var cost:Int;
	var state:T;
}

typedef State = {
	function hashCode():Int;
	function isGoal():Bool;
}

private typedef Score = {
	var g:Int;
	var f:Int;
}
