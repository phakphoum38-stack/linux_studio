import 'screen_buffer.dart';
import 'terminal_state_machine.dart';
import 'ssh_bridge.dart';

class PtyBridge {
  late ScreenBuffer screen;
  late TerminalStateMachine sm;
  final SshBridge ssh = SshBridge();

  Function(String)? onOutput;

  void start([int rows = 24, int cols = 80]) {
    screen = ScreenBuffer(rows: rows, cols: cols);
    sm = TerminalStateMachine(screen);
  }

  void write(String data) {
    if (ssh.connected) {
      ssh.write(data);
    }

    sm.feed(data);
    onOutput?.call(data);
  }

  Future<void> connectSSH({
    required String host,
    required String user,
    required String pass,
  }) async {
    await ssh.connect(
      host: host,
      username: user,
      password: pass,
    );
  }

  void kill() {
    ssh.disconnect();
  }
}
