import polygonal.ds.PriorityQueue;
import Util.PrioritizedItem;

class AStar {
	public static function search<T:State>(start:T, isGoal:T->Bool, score:T->Int, getMoves:T->Array<Move<T>>):Null<Int> {
		var scores = new Map<String, Score>();
		scores.set(start.hashCode(), {
			g: 0,
			f: score(start)
		});
		var closedSet = new Map<String, Bool>();
		var openSet = new PriorityQueue(1, true, [new PrioritizedItem(start, score(start))]);

		while (openSet.size > 0) {
			var current = openSet.dequeue().item;
			closedSet.set(current.hashCode(), true);

			var currentScore = scores.get(current.hashCode()).g;
			if (isGoal(current)) {
				return currentScore;
			}

			for (move in getMoves(current)) {
				if (closedSet.exists(move.state.hashCode())) {
					continue;
				}
				var node = scores.get(move.state.hashCode());
				var scoreAfterMove = currentScore + move.cost;
				if (node == null || node.g > scoreAfterMove) {
					var score = {
						g: scoreAfterMove,
						f: scoreAfterMove + score(move.state)
					};
					scores.set(move.state.hashCode(), score);
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
	function hashCode():String;
}

private typedef Score = {
	var g:Int;
	var f:Int;
}
