import 'dart:async';

import 'screen_buffer.dart';
import 'ssh_bridge.dart';

typedef VoidCallback = void Function();

class PtyBridge {
  final ScreenBuffer buffer;
  final SshBridge? ssh;

  StreamSubscription<String>? _subscription;

  VoidCallback? onRefresh;

  bool _running = false;

  bool get running => _running;

  PtyBridge({
    required this.buffer,
    this.ssh,
  });

  void start() {
    _running = true;

    if (ssh != null) {
      _subscription = ssh!.outputStream.listen(_handleOutput);
    }
  }

  void _handleOutput(String data) {
    buffer.writeText(data);
    onRefresh?.call();
  }

  void write(String text) {
    if (!_running) return;

    if (ssh != null && ssh!.connected) {
      ssh!.write("$text\n");
    } else {
      buffer.writeText("$text\n");
      onRefresh?.call();
    }
  }

  void print(String text) {
    buffer.writeText(text);
    onRefresh?.call();
  }

  void clear() {
    buffer.clear();
    onRefresh?.call();
  }

  void resize(int cols, int rows) {
    ssh?.resize(cols, rows);
  }

  void kill() {
    _running = false;

    _subscription?.cancel();
    _subscription = null;

    ssh?.disconnect();
  }
}
