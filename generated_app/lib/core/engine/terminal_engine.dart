import 'dart:async';

import '../backend/terminal_backend.dart';

import 'ansi_csi_parser.dart';
import 'screen_buffer.dart';
import 'vt100_state_machine.dart';

class TerminalEngine {
  TerminalEngine({
    required this.backend,
    ScreenBuffer? buffer,
  }) : buffer = buffer ?? ScreenBuffer() {
    vt100 = VT100StateMachine(
      this.buffer,
    );
  }

  final TerminalBackend backend;

  final ScreenBuffer buffer;

  final AnsiCsiParser parser =
      AnsiCsiParser();

  late final VT100StateMachine vt100;

  StreamSubscription<String>? _stdoutSub;

  StreamSubscription<String>? _stderrSub;

  Function()? onUpdate;

  bool _running = false;

  bool get isRunning =>
      _running;

  Future<void> start() async {
    if (_running) {
      return;
    }

    _stdoutSub =
        backend.output.listen(
      _handleOutput,
    );

    _stderrSub =
        backend.errors.listen(
      (error) {
        buffer.writeText(
          '\n$error\n',
        );

        onUpdate?.call();
      },
    );

    await backend.start();

    _running = true;
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

    /// ส่งข้อความไปยัง Terminal Backend
  Future<void> write(
    String text,
  ) async {
    if (!_running) {
      return;
    }

    await backend.write(text);
  }

  /// ส่ง Key
  Future<void> sendKey(
    String key,
  ) async {
    await write(key);
  }

  /// Resize Terminal
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

  /// Clear ScreenBuffer
  void clear() {
    buffer.clear();
    onUpdate?.call();
  }

  /// Reset VT100 + Buffer
  void reset() {
    vt100.reset();
    onUpdate?.call();
  }

  /// Stop Engine
  Future<void> kill() async {
    if (!_running) {
      return;
    }

    _running = false;

    await _stdoutSub?.cancel();
    await _stderrSub?.cancel();

    _stdoutSub = null;
    _stderrSub = null;

    await backend.stop();
  }

  Future<void> dispose() async {
    await kill();
  }
}
