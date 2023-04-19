class Log {
  static void d(dynamic text) {
    DateTime _now = DateTime.now();
    text = "${_now.day}/${_now.month}/${_now.year} ${_now.hour}:${_now.minute}:${_now.second}.${_now.millisecond}: ${text.toString()}";
    print('\x1B[0m$text\x1B[0m');
  }

  static void i(dynamic text) {
    DateTime _now = DateTime.now();
    text = "${_now.day}/${_now.month}/${_now.year} ${_now.hour}:${_now.minute}:${_now.second}.${_now.millisecond}: ${text.toString()}";
    print('\x1B[34m$text\x1B[0m');
  }

  static void e(dynamic text) {
    DateTime _now = DateTime.now();
    text = "${_now.day}/${_now.month}/${_now.year} ${_now.hour}:${_now.minute}:${_now.second}.${_now.millisecond}: ${text.toString()}";
    print('\x1B[31m$text\x1B[0m');
  }

  static void w(dynamic text) {
    DateTime _now = DateTime.now();
    text = "${_now.day}/${_now.month}/${_now.year} ${_now.hour}:${_now.minute}:${_now.second}.${_now.millisecond}: ${text.toString()}";
    print('\x1B[33m$text\x1B[0m');
  }
}