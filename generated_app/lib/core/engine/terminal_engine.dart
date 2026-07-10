import '../backend/terminal_backend.dart';
import '../backend/pty_terminal_backend.dart';

import 'ansi_csi_parser.dart';
import 'screen_buffer.dart';
import 'vt100_state_machine.dart';

class TerminalEngine {
  TerminalEngine({
    TerminalBackend? backend,
    ScreenBuffer? buffer,
  })  : backend = backend ?? PtyTerminalBackend(),
        buffer = buffer ?? ScreenBuffer() {
    vt100 = VT100StateMachine(this.buffer);
  }

  final TerminalBackend backend;

  final ScreenBuffer buffer;

  final AnsiCsiParser parser =
      AnsiCsiParser();

  late final VT100StateMachine vt100;

  Function()? onUpdate;

  bool _running = false;

  bool get isRunning =>
      _running;

  Future<void> start() async {
    if (_running) {
      return;
    }

    _running = true;

    backend.output.listen(
      _handleOutput,
      onError: (e) {
        buffer.writeText(
          '\n$error: $e\n',
        );

        onUpdate?.call();
      },
    );

    backend.errors.listen(
      (e) {
        buffer.writeText(
          '\n$error: $e\n',
        );

        onUpdate?.call();
      },
    );

    await backend.start();
  }

  void _handleOutput(
    String data,
  ) {
    final events =
        parser.parse(data);

    for (final event in events) {
      vt100.handle(event);
    }

    onUpdate?.call();
  }

  Future<void> write(
    String text,
  ) async {
    if (!_running) {
      return;
    }

    await backend.write(text);
  }

  Future<void> sendKey(
    String key,
  ) async {
    await write(key);
  }

  Future<void> resize(
    int cols,
    int rows,
  ) async {
    if (!_running) {
      return;
    }

    await backend.resize(
      cols,
      rows,
    );
  }

  Future<void> clear() async {
    buffer.clear();

    onUpdate?.call();
  }

  Future<void> kill() async {
    if (!_running) {
      return;
    }

    _running = false;

    await backend.stop();
  }

  void dispose() {
    kill();
  }
}
