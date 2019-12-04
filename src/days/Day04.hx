package days;

class Day04 {
	public static function meetsCritera(password:Int) {
		var password = Std.string(password);
		if (password.length != 6) {
			return false;
		}
		var hasDouble = false;
		var prev = password.charAt(0);
		for (i in 1...password.length) {
			var digit = password.charAt(i);
			if (digit < prev) {
				return false;
			}
			if (digit == prev) {
				hasDouble = true;
			}
			prev = digit;
		}
		return hasDouble;
	}

	public static function findValidPasswords(min:Int, max:Int):Array<Int> {
		var validPasswords = [];
		for (password in min...max + 1) {
			if (meetsCritera(password)) {
				validPasswords.push(password);
			}
		}
		return validPasswords;
	}
}
