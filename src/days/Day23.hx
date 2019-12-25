package days;

class Day23 {
	public static function simulateNetwork(program:String, result:ResultKind):Int64 {
		var computers = [for (addresss in 0...50) new IntCodeVM(program).write(addresss)];
		var nat:{x:Int64, y:Int64} = null;
		var prevNatDeliveryY:Null<Int64> = null;
		while (true) {
			var networkIdle = true;
			for (computer in computers) {
				if (computer.hasInput()) {
					networkIdle = false;
				} else {
					computer.write(-1);
				}
				computer.run();
				while (computer.hasOutput()) {
					var destination = computer.read();
					var x = computer.read();
					var y = computer.read();
					if (destination == 255) {
						nat = {x: x, y: y};
						if (result == FirstNatY) {
							return y;
						}
					} else {
						computers[destination.toInt()].write(x).write(y);
					}
				}
			}
			if (networkIdle) {
				if (nat == null) {
					throw "network idle but no NAT packet";
				} else {
					if (prevNatDeliveryY != null && nat.y == prevNatDeliveryY) {
						return nat.y;
					}
					computers[0].write(nat.x).write(nat.y);
					prevNatDeliveryY = nat.y;
				}
			}
		}
	}
}

enum ResultKind {
	FirstNatY;
	FirstConsecutivelyIdenticalNatY;
}
