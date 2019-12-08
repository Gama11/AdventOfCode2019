package days;

class Day08 {
	static function parse(input:String, width:Int, height:Int) {
		var layers = [[[]]];
		var layer = 0;
		var row = 0;
		var column = 0;
		for (digit in input.split("").map(Std.parseInt)) {
			if (layers[layer] == null) {
				layers[layer] = [];
			}
			if (layers[layer][column] == null) {
				layers[layer][column] = [];
			}
			layers[layer][column][row] = digit;

			row++;
			if (row >= width) {
				row = 0;
				column++;
			}
			if (column >= height) {
				column = 0;
				layer++;
			}
		}
		return layers;
	}

	public static function validateImage(input:String, width:Int, height:Int):Int {
		var layers = parse(input, width, height);
		var layer = layers.min(layer -> layer.flatten().count(i -> i == 0)).list[0];
		var layer = layer.flatten();
		return layer.count(i -> i == 1) * layer.count(i -> i == 2);
	}

	public static function decodeImage(input:String, width:Int, height:Int):String {
		var layers = parse(input, width, height);
		var image = [for (_ in 0...height) [for (_ in 0...width) Transparent]];
		for (layer in layers) {
			for (y in 0...height) {
				for (x in 0...width) {
					if (image[y][x] == Transparent) {
						image[y][x] = layer[y][x];
					}
				}
			}
		}
		return image.map(row -> row.map(p -> if (p == White) "■" else " ").join("")).join("\n");
	}
}

private enum abstract Pixel(Int) from Int {
	var Black;
	var White;
	var Transparent;
}
