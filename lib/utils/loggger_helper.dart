import 'dart:developer' as developer;

class ColorfulLogger {
  static void _log(String s) {
    developer.log(s);
  }

  /// printCustom
  static void printCustom(String text, {String color = LogColor.white}) {
    _log('$color$text\x1B[0m');
  }

  static void printGreen(String text) {
    printCustom(text, color: LogColor.green);
  }

  static void simpleLog(String s) {
    _log(s);
  }
}

class LogColor {
  static const String black = '\x1B[30m';
  static const String red = '\x1B[31m';
  static const String green = '\x1B[32m';
  static const String yellow = '\x1B[33m';
  static const String blue = '\x1B[34m';
  static const String magenta = '\x1B[35m';
  static const String cyan = '\x1B[36m';
  static const String white = '\x1B[37m';
}
