import 'ansi_stream_parser.dart';
import 'vt100_state_machine.dart';
import 'scrollback_buffer.dart';
import 'screen_buffer.dart';
import '../plugin/plugin_manager.dart';

class StreamingTerminalEngine {
  final AnsiStreamParser parser = AnsiStreamParser();
  final ScreenBuffer buffer;
  late final VT100StateMachine state;
  final ScrollbackBuffer scrollback = ScrollbackBuffer();

  PluginManager? pluginManager;

  Function(String text, int row, int col)? onText;
  Function(String cmd, List<int> args)? onCommand;

  StreamingTerminalEngine({
    ScreenBuffer? buffer,
  }) : buffer = buffer ?? ScreenBuffer() {
    state = VT100StateMachine(this.buffer);
    parser.onText = _handleText;
    parser.onCommand = _handleCommand;
  }

  void feed(String data) {
    parser.feed(data);
    pluginManager?.emitData(data);
  }

  void _handleText(String text) {
    scrollback.add(text);
    buffer.writeText(text);

    onText?.call(text, buffer.cursor.row, buffer.cursor.col);
  }

  void _handleCommand(String cmd, List<int> args) {
    state.execute(cmd, args);

    onCommand?.call(cmd, args);

    pluginManager?.emitCommand(cmd, args);
  }
}
