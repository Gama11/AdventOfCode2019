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

	public static function calculateFuelCost(input:String, quantity:Int = 1, ?leftovers:Map<String, Int>):Int {
		var reactions = parse(input);
		if (leftovers == null) {
			leftovers = new Map<String, Int>();
		}
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
			function apply(times:Int) {
				if (reaction.inputs[0].name == "ORE") {
					return reaction.inputs[0].quantity * times;
				}
				return reaction.inputs.map(required -> produce({
					name: required.name,
					quantity: required.quantity * times
				})).sum();
			}
			var cost = 0;
			var requiredApplications = Std.int(Math.ceil((required.quantity - quantity) / reaction.output.quantity));
			cost += apply(requiredApplications);
			quantity += reaction.output.quantity * requiredApplications;
			leftovers[required.name] = quantity - required.quantity;
			return cost;
		}
		return produce({name: "FUEL", quantity: quantity});
	}

	public static function findMaxFuelProduction(input:String):Int {
		var singleCost = calculateFuelCost(input);
		var ore = 1000000000000;
		var fuel = 0;
		var leftovers = new Map<String, Int>();
		while (true) {
			var producableFuel = Std.int(Math.max(1, Std.int(ore / singleCost)));
			var cost = calculateFuelCost(input, producableFuel, leftovers);
			ore -= cost;
			if (ore < 0) {
				return fuel;
			}
			fuel += producableFuel;
		}
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
