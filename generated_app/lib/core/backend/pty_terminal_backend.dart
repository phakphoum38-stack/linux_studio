import 'dart:async';

import 'native_terminal.dart';
import 'terminal_backend.dart';

class PtyTerminalBackend implements TerminalBackend {
  PtyTerminalBackend();

  final NativeTerminal _terminal =
      NativeTerminal();

  final StreamController<String> _outputController =
      StreamController<String>.broadcast();

  final StreamController<String> _errorController =
      StreamController<String>.broadcast();

  Timer? _reader;

  bool _running = false;

  @override
  Stream<String> get output =>
      _outputController.stream;

  @override
  Stream<String> get errors =>
      _errorController.stream;

  @override
  Future<void> start() async {
    if (!_terminal.open()) {
      _errorController.add(
        'Failed to create ConPTY session.',
      );
      return;
    }

    _running = true;

    _reader = Timer.periodic(
      const Duration(milliseconds: 16),
      (_) {
        if (!_running) {
          return;
        }

        try {
          final data = _terminal.read();

          if (data.isNotEmpty) {
            _outputController.add(data);
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
    if (!_running) {
      return;
    }

    _terminal.write(text);
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
    if (!_running) {
      return;
    }

    _terminal.resize(
      cols: cols,
      rows: rows,
    );
  }

  @override
  Future<void> stop() async {
    _running = false;

    _reader?.cancel();
    _reader = null;

    _terminal.close();

    await _outputController.close();
    await _errorController.close();
  }
}



}
