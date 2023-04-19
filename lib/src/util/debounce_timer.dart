import 'dart:async';

import 'package:flutter/foundation.dart';

class TimerDebounce {
  final int milliseconds;
  Timer? _timer;

  TimerDebounce({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(
      Duration(milliseconds: milliseconds),
      action,
    );
  }

  void close() {
    _timer?.cancel();
  }
}
