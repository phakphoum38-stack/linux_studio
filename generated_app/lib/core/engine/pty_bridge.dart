import 'dart:async';

class PtyBridge {
  Function(String data)? onOutput;

  bool _connected = false;

  void start() {
    _connected = true;

    // mock shell output
    Timer.periodic(const Duration(seconds: 2), (t) {
      if (!_connected) {
        t.cancel();
        return;
      }
      onOutput?.call("terminal: heartbeat\n");
    });
  }

  void write(String input) {
    if (!_connected) return;

    onOutput?.call("\$ $input\n");
  }

  void kill() {
    _connected = false;
  }
}
