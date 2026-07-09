import '../backend/terminal_backend.dart';

import 'ansi_csi_parser.dart';
import 'screen_buffer.dart';
import 'vt100_state_machine.dart';

class TerminalEngine {
  TerminalEngine({
    required this.backend,
    ScreenBuffer? buffer,
  }) : buffer = buffer ?? ScreenBuffer() {
    vt100 = VT100StateMachine(this.buffer);
  }

  final TerminalBackend backend;

  final ScreenBuffer buffer;

  final AnsiCsiParser parser = AnsiCsiParser();

  late final VT100StateMachine vt100;

  Function()? onUpdate;

  Future<void> start() async {
    backend.output.listen(_handleOutput);

    backend.errors.listen((error) {
      buffer.writeText('\n$error\n');
      onUpdate?.call();
    });

    await backend.start();
  }

  void _handleOutput(String data) {
    final events = parser.parse(data);

    for (final event in events) {
      vt100.handle(event);
    }

    onUpdate?.call();
  }

  Future<void> write(String text) async {
    await backend.write(text);
  }

  Future<void> sendKey(String key) async {
    await backend.write(key);
  }

  Future<void> resize(
    int cols,
    int rows,
  ) async {
    await backend.resize(
      cols,
      rows,
    );
  }

  Future<void> kill() async {
    await backend.stop();
  }
}
