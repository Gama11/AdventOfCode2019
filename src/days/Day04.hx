package days;

class Day04 {
	public static function meetsCritera(password:Int, exactDouble:Bool = false) {
		var password = Std.string(password);
		if (password.length != 6) {
			return false;
		}
		var hasDouble = false;
		var prev = password.charAt(0);
		var lastChange = 0;
		for (i in 1...password.length + 1) {
			var digit = password.charAt(i);
			if (digit != "" && digit < prev) {
				return false;
			}
			if (digit != prev) {
				var lastSequenceLength = i - lastChange;
				if (exactDouble && lastSequenceLength == 2) {
					hasDouble = true;
				} else if (!exactDouble && lastSequenceLength >= 2) {
					hasDouble = true;
				}
				lastChange = i;
			}
			prev = digit;
		}
		return hasDouble;
	}

	public static function countValidPasswords(min:Int, max:Int, exactDouble:Bool = false):Int {
		var count = 0;
		for (password in min...max + 1) {
			if (meetsCritera(password, exactDouble)) {
				count++;
			}
		}
		return count;
	}
}
