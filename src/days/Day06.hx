package days;

class Day06 {
	static function parse(input:String):Map<String, Object> {
		var objects = new Map<String, Object>();
		function get(name:String):Object {
			var object = objects[name];
			if (object == null) {
				object = {
					name: name,
					parent: null,
					children: []
				}
			}
			return objects[name] = object;
		}
		for (line in input.split("\n")) {
			var s = line.split(")");
			var object = get(s[0]);
			var child = get(s[1]);
			child.parent = object;
			object.children.push(child);
		}
		return objects;
	}

	public static function countOrbits(input:String):Int {
		var objects = parse(input);
		function loop(object:Object, depth:Int):Int {
			return depth + object.children.map(loop.bind(_, depth + 1)).sum();
		}
		return loop(objects["COM"], 0);
	}

	public static function countOrbitalTransfers(input:String):Int {
		var objects = parse(input);
		var transfersNeeded = 0;
		var visited = new Map<String, Bool>();
		function search(object:Object, distance:Int) {
			if (visited[object.name]) {
				return;
			}
			visited[object.name] = true;
			if (object.parent != null) {
				search(object.parent, distance + 1);
			}
			for (child in object.children) {
				if (child.name == "SAN") {
					transfersNeeded = distance - 1;
					break;
				}
				search(child, distance + 1);
			}
		}
		search(objects["YOU"], 0);
		return transfersNeeded;
	}
}

typedef Object = {
	var name:String;
	var ?parent:Object;
	var children:Array<Object>;
}
