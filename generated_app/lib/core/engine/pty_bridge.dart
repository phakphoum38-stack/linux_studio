import 'ansi_stream_parser.dart';
import 'terminal_state_machine.dart';
import 'screen_buffer.dart';

class PtyBridge {
  late ScreenBuffer screen;
  late TerminalStateMachine sm;

  Function(String)? onOutput;

  void start([int rows = 24, int cols = 80]) {
    screen = ScreenBuffer(rows: rows, cols: cols);
    sm = TerminalStateMachine(screen);
  }

  void write(String data) {
    sm.feed(data);
    onOutput?.call(data);
  }

  void clear() {
    screen.clear();
  }
}
