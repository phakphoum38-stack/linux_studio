import 'ansi_stream_parser.dart';
import 'vt100_state_machine.dart';
import 'scrollback_buffer.dart';
import '../plugin/plugin.dart';
import '../plugin/plugin_manager.dart';

class StreamingTerminalEngine {
  final AnsiStreamParser parser = AnsiStreamParser();
  final VT100StateMachine state = VT100StateMachine();
  final ScrollbackBuffer scrollback = ScrollbackBuffer();

  PluginManager? pluginManager;

  Function(String text, int row, int col)? onText;
  Function(String cmd, List<int> args)? onCommand;

  StreamingTerminalEngine() {
    parser.onText = _handleText;
    parser.onCommand = _handleCommand;
  }

  void feed(String data) {
    parser.feed(data);
    pluginManager?.emitData(data);
  }

  void _handleText(String text) {
    scrollback.add(text);

    onText?.call(text, state.cursorRow, state.cursorCol);

    state.cursorCol += text.length;
  }

  void _handleCommand(String cmd, List<int> args) {
    state.applyCommand(cmd, args);

    onCommand?.call(cmd, args);

    pluginManager?.emitCommand(cmd, args);
  }
}
