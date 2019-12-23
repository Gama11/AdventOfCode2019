package days;

class Day23 {
	public static function simulateNetwork(program:String):Int64 {
		var computers = [for (addresss in 0...50) new IntCodeVM(program).write(addresss).write(-1)];
		while (true) {
			for (computer in computers) {
				if (!computer.hasInput()) {
					computer.write(-1);
				}
				computer.run();
				while (computer.hasOutput()) {
					var destination = computer.read();
					var x = computer.read();
					var y = computer.read();
					if (destination == 255) {
						return y;
					}
					computers[destination.toInt()].write(x).write(y);
				}
			}
		}
	}
}
