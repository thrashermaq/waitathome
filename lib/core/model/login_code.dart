import 'dart:math';

class LoginCode {
  static String generate() {
    var random = new Random();
    return random.nextInt(999999).toString().padLeft(6, '0');
  }
}
