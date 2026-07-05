import 'dart:async';

class CursorBlink {
  bool visible = true;

  Timer? _timer;

  void start(Function(bool visible) onTick) {
    _timer = Timer.periodic(Duration(milliseconds: 500), (_) {
      visible = !visible;
      onTick(visible);
    });
  }

  void stop() {
    _timer?.cancel();
  }
}
