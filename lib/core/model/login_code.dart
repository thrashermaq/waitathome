import 'dart:math';

class LoginCode {
  static int generate() {
    var random = new Random();
    return random.nextInt(999999);
  }
}
