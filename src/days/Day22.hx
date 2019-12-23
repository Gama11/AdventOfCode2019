package days;

#if python
import StdTypes.Int as Int64;
#else
import haxe.Int64;
#end

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
					pos = Util.mod64(pos * -1 - 1, size);

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
					pos = Util.mod64(pos * -1 - 1, size);

				case Cut(n):
					pos = Util.mod64(pos + n, size);

				case DealWithIncrement(n):
					pos = Util.mod64(pos * Util.modInv64(n, size), size);
			}
			if (pos < 0 || pos >= size) {
				throw 'invalid position $pos during $instruction';
			}
		}
		return pos;
	}

	public static function mergeInstructions(instructions:Array<Instruction>, size:Int64):MergedInstructions {
		var increment:Int64 = 1;
		var offset:Int64 = 0;
		for (instruction in instructions) {
			switch instruction {
				case DealIntoNewStack:
					increment *= -1;
					offset += increment;

				case Cut(n):
					offset += increment * n;

				case DealWithIncrement(n):
					increment *= Util.modInv64(n, size);
			}
			increment = Util.mod64(increment, size);
			offset = Util.mod64(offset, size);
		}
		return {
			increment: increment,
			offset: offset
		};
	}

	public static function fastNumberOfCardInPosition(instructions:Array<Instruction>, size:Int64, pos:Int64, shuffles:Int64):Int64 {
		var i = mergeInstructions(instructions, size);
		var mod = n -> Util.mod64(n, size);
		var pow = (b, e) -> Util.modPow64(b, e, size);
		var inv = n -> Util.modInv64(n, size);
		return mod(pow(i.increment, shuffles) * pos + mod(i.offset * (pow(i.increment, shuffles) - 1)) * inv(i.increment - 1));
	}
}

enum Instruction {
	DealIntoNewStack;
	Cut(cards:Int);
	DealWithIncrement(increment:Int);
}

typedef MergedInstructions = {
	final increment:Int64;
	final offset:Int64;
}
