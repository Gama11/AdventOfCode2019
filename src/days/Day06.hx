package days;

class Day06 {
	static function parse(input:String):Map<String, Array<String>> {
		var map = new Map<String, Array<String>>();
		for (line in input.split("\n")) {
			var s = line.split(")");
			var object = s[0];
			var children = map[object];
			if (children == null) {
				children = [];
			}
			children.push(s[1]);
			map[object] = children;
		}
		return map;
	}

	public static function countOrbits(input:String):Int {
		var map = parse(input);
		function loop(object:String, depth:Int):Int {
			var children = map[object];
			if (children == null) {
				children = [];
			}
			return depth + children.map(loop.bind(_, depth + 1)).sum();
		}
		return loop("COM", 0);
	}
}
