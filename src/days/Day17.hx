package days;

class Day17 {
	public static function calculateAlignmentParameterSum(image:String):Int {
		var grid:Array<Array<Tile>> = image.split("\n").map(line -> line.split(""));
		var sum = 0;
		for (y in 0...grid.length) {
			var row = grid[y];
			for (x in 0...row.length) {
				if (grid[y][x] == Scaffolding && grid[y - 1] != null && grid[y - 1][x] == Scaffolding && grid[y + 1] != null
					&& grid[y + 1][x] == Scaffolding && grid[y][x - 1] == Scaffolding && grid[y][x + 1] == Scaffolding) {
					sum += x * y;
				}
			}
		}
		return sum;
	}

	public static function calibrateCameras(program:String):Int {
		var vm = new IntCodeVM(program).run();
		var image = "";
		while (vm.hasOutput()) {
			image += String.fromCharCode(vm.read().toInt());
		}
		return calculateAlignmentParameterSum(image);
	}
}

private enum abstract Tile(String) from String {
	var Scaffolding = "#";
	var Space = ".";
}
