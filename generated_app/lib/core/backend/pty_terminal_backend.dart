import 'dart:async';

import 'native_terminal.dart';
import 'terminal_backend.dart';

class PtyTerminalBackend implements TerminalBackend {
  PtyTerminalBackend({
    NativeTerminal? terminal,
  }) : _terminal = terminal ?? NativeTerminal();

  final NativeTerminal _terminal;

  final StreamController<String> _outputController =
      StreamController<String>.broadcast();

  final StreamController<String> _errorController =
      StreamController<String>.broadcast();

  Timer? _readerTimer;

  bool _running = false;

  @override
  Stream<String> get output =>
      _outputController.stream;

  @override
  Stream<String> get errors =>
      _errorController.stream;

  @override
  Future<void> start() async {
    if (_running) {
      return;
    }

    if (!_terminal.open()) {
      _errorController.add(
        'Unable to create native terminal.',
      );
      return;
    }

    _running = true;

    _readerTimer = Timer.periodic(
      const Duration(milliseconds: 16),
      (_) {
        if (!_running) {
          return;
        }

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
  Future<void> stop() async {
    _running = false;

    _readerTimer?.cancel();
    _readerTimer = null;

    _terminal.close();

    if (!_outputController.isClosed) {
      await _outputController.close();
    }

    if (!_errorController.isClosed) {
      await _errorController.close();
    }
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
    if (!_running) {
      return '';
    }

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
}
