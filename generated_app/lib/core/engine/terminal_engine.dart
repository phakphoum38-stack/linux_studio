import 'dart:async';

import '../backend/pty_terminal_backend.dart';
import '../backend/terminal_backend.dart';

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

  StreamSubscription<String>? _outputSub;

  StreamSubscription<String>? _errorSub;

  Function()? onUpdate;

  Future<void> start() async {
    _outputSub =
        backend.output.listen(
      _handleOutput,
    );

    _errorSub =
        backend.errors.listen(
      (error) {
        buffer.writeText(
          '\nERROR: $error\n',
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
        parser.parse(
      data,
    );

    for (final event in events) {
      vt100.handle(
        event,
      );
    }

    onUpdate?.call();
  }

  Future<void> write(
    String text,
  ) async {
    await backend.write(
      text,
    );
  }

  Future<void> sendKey(
    String key,
  ) async {
    await write(
      key,
    );
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
    await _outputSub?.cancel();
    await _errorSub?.cancel();

    await backend.stop();
  }
}
