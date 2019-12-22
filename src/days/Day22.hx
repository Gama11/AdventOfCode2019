package days;

class Day22 {
	public static function parse(input:String):Array<Instruction> {
		return input.split("\n").map(function(line) {
			return switch line.split(" ") {
				case ["deal", "into", "new", "stack"]: DealIntoNewStack;
				case ["cut", n]: Cut(Std.parseInt(n));
				case ["deal", "with", "increment", n]: DealWithIncrement(Std.parseInt(n));
				case other: throw "unknown instruction " + other;
			}
		});
	}

	public static function shuffle(input:String, size:Int = 10, ?deck:Array<Int>):Array<Int> {
		var instructions = parse(input);
		if (deck == null) {
			deck = [for (i in 0...size) i];
		}
		for (instruction in instructions) {
			switch instruction {
				case DealIntoNewStack:
					deck.reverse();

				case Cut(cards):
					deck = deck.slice(cards, deck.length).concat(deck.slice(0, cards));

				case DealWithIncrement(increment):
					var table = [];
					var i = 0;
					for (card in deck) {
						table[i] = card;
						i = (i + increment) % deck.length;
					}
					deck = table;
			}
		}
		return deck;
	}

	public static function positionOfCardWithNumber(instructions:Array<Instruction>, size:Int64, number:Int64):Int64 {
		var pos = number;
		for (instruction in instructions) {
			switch instruction {
				case DealIntoNewStack:
					pos = size - pos - 1;

				case Cut(n):
					pos = Util.mod64(pos - n, size);

				case DealWithIncrement(n):
					pos = Util.mod64(pos * n, size);
			}
			if (pos < 0 || pos >= size) {
				throw 'invalid position $pos during $instruction';
			}
		}
		return pos;
	}

	public static function numberOfCardInPosition(instructions:Array<Instruction>, size:Int64, pos:Int64) {
		var i = instructions.length;
		while (i-- > 0) {
			var instruction = instructions[i];
			switch instruction {
				case DealIntoNewStack:
					pos = size - pos - 1;

				case Cut(n):
					pos = Util.mod64(size + pos + n, size);

				case DealWithIncrement(n):
					pos = Util.mod64(pos * Util.modInverse64(n, size), size);
			}
			if (pos < 0 || pos >= size) {
				throw 'invalid position $pos during $instruction';
			}
		}
		return pos;
	}

	public static function fastNumberOfCardInPosition(instructions:Array<Instruction>, pos:Int64, size:Int64, shuffles:Int64, cycle:Int64):Int64 {
		var shufflesLeft = shuffles % cycle;
		while (shufflesLeft-- > 0) {
			pos = numberOfCardInPosition(instructions, size, pos);
		}
		return pos;
	}

	public static function findCycle(instructions:Array<Instruction>, size:Int64, ?limit:Int64):Null<Int> {
		if (limit == null) {
			limit = size;
		}
		var pos:Int64 = 0;
		var seen = [Std.string(pos) => 0];
		var i = 0;
		while (true) {
			pos = positionOfCardWithNumber(instructions, size, pos);
			var s = Std.string(pos);
			i++;
			if (seen.exists(s)) {
				return i - seen[s];
			}
			seen[s] = i;
			if (i > limit) {
				return null;
			}
		}
	}

	public static function isValidDeckSize(instructions:Array<Instruction>, size:Int64):Bool {
		return !instructions.exists(i -> switch i {
			case Cut(cards): size < Std.int(Math.abs(cards));
			case DealWithIncrement(increment): increment != 0 && size % increment == 0;
			case _: false;
		});
	}
}

enum Instruction {
	DealIntoNewStack;
	Cut(cards:Int);
	DealWithIncrement(increment:Int);
}
