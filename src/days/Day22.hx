package days;

class Day22 {
	static function parse(input:String):Array<Instruction> {
		return input.split("\n").map(function(line) {
			return switch line.split(" ") {
				case ["deal", "into", "new", "stack"]: DealIntoNewStack;
				case ["cut", n]: Cut(Std.parseInt(n));
				case ["deal", "with", "increment", n]: DealWithIncrement(Std.parseInt(n));
				case other: throw "unknown instruction " + other;
			}
		});
	}

	public static function shuffle(input:String, size:Int = 10):Array<Int> {
		var instructions = parse(input);
		var deck = [for (i in 0...size) i];
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

	public static function positionOf(input:String, size:Int64, card:Int):Int64 {
		var instructions = parse(input);
		var pos:Int64 = card;
		for (instruction in instructions) {
			switch instruction {
				case DealIntoNewStack:
					pos = size - pos - 1;

				case Cut(cards):
					if (cards >= 0) {
						if (pos < cards) {
							pos += size - cards;
						} else {
							pos -= cards;
						}
					} else {
						var shift = size + cards;
						if (pos > shift) {
							pos -= shift;
						} else {
							pos -= cards;
						}
					}

				case DealWithIncrement(increment):
					pos = (pos * increment) % size;
			}
		}
		return pos;
	}
}

enum Instruction {
	DealIntoNewStack;
	Cut(cards:Int);
	DealWithIncrement(increment:Int);
}
