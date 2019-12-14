package days;

class Day14 {
	static function parse(input:String):Map<String, Reaction> {
		var reactions = new Map();
		for (line in input.split("\n")) {
			var parts = line.split(" => ");
			function parseChemical(s:String):Chemical {
				var parts = s.split(" ");
				return {
					name: parts[1],
					quantity: Std.parseInt(parts[0])
				}
			}
			var inputs = parts[0].split(", ").map(parseChemical);
			var output = parseChemical(parts[1]);
			reactions[output.name] = {
				inputs: inputs,
				output: output
			};
		}
		return reactions;
	}

	public static function calculateFuelCost(input:String):Int {
		var reactions = parse(input);
		var leftovers = new Map<String, Int>();
		function produce(required:Chemical):Int {
			var quantity = leftovers[required.name];
			if (quantity == null) {
				quantity = 0;
			}
			if (quantity >= required.quantity) {
				leftovers[required.name] -= required.quantity;
				return 0;
			}

			var reaction = reactions[required.name];
			function apply() {
				if (reaction.inputs[0].name == "ORE") {
					return reaction.inputs[0].quantity;
				}
				return reaction.inputs.map(required -> produce(required)).sum();
			}
			var cost = 0;
			while (quantity < required.quantity) {
				cost += apply();
				quantity += reaction.output.quantity;
			}
			leftovers[required.name] = quantity - required.quantity;
			return cost;
		}
		return produce({name: "FUEL", quantity: 1});
	}
}

private typedef Reaction = {
	final inputs:Array<Chemical>;
	final output:Chemical;
}

private typedef Chemical = {
	final name:String;
	final quantity:Int;
}
