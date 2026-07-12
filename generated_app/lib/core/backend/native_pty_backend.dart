import 'dart:async';

import 'native_terminal.dart';
import 'terminal_backend.dart';

class NativePtyBackend implements TerminalBackend {
  NativePtyBackend();

  final NativeTerminal _terminal =
      NativeTerminal();

  final StreamController<String> _outputController =
      StreamController<String>.broadcast();

  final StreamController<String> _errorController =
      StreamController<String>.broadcast();

  Timer? _pollTimer;

  @override
  Stream<String> get output =>
      _outputController.stream;

  @override
  Stream<String> get errors =>
      _errorController.stream;

  @override
  Future<void> start() async {
    if (!await _terminal.open()) {
      _errorController.add(
        'Failed to open native terminal.',
      );
      return;
    }

    _pollTimer = Timer.periodic(
      const Duration(milliseconds: 16),
      (_) {
        try {
          final text = _terminal.read();

          if (text.isNotEmpty) {
            _outputController.add(text);
          }
        } catch (e) {
          _errorController.add(
            e.toString(),
          );
        }
      },
    );
  }

  @override
  Future<void> write(
    String text,
  ) async {
    await _terminal.write(text);
  }

  @override
  String read() {
    return _terminal.read();
  }

  @override
  Future<void> resize(
    int cols,
    int rows,
  ) async {
    await _terminal.resize(
      cols: cols,
      rows: rows,
    );
  }

  @override
  Future<void> stop() async {
    _pollTimer?.cancel();
    _pollTimer = null;

    await _terminal.close();

    await _outputController.close();
    await _errorController.close();
  }
}
