import 'dart:async';
import 'ssh_bridge.dart';
import 'screen_buffer.dart';

class PtyBridge {
  final SshBridge ssh;
  final ScreenBuffer buffer;

  StreamSubscription? _sub;

  Function()? onRefresh;

  PtyBridge({
    required this.ssh,
    required this.buffer,
  });

  /// start listening SSH output → buffer
  void start() {
    ssh.onOutput = (data) {
      _handleOutput(data);
    };
  }

  void _handleOutput(String data) {
    buffer.write(data);
    onRefresh?.call();
  }

  /// send input to SSH
  void write(String input) {
    ssh.write(input);
  }

  void resize(int cols, int rows) {
    ssh.resize(cols, rows);
  }

  void kill() {
    _sub?.cancel();
    ssh.disconnect();
  }
}
