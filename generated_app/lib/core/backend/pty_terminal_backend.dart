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
  bool get isRunning => _running;

  @override
  Stream<String> get output => _outputController.stream;

  @override
  Stream<String> get errors => _errorController.stream;

  @override
  Future<void> start() async {
    if (_running) {
      return;
    }

    if (!_terminal.open()) {
      _errorController.add(
        'Unable to start terminal.',
      );
      return;
    }

    _running = true;

    _readerTimer = Timer.periodic(
      const Duration(
        milliseconds: 16,
      ),
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

  @override
  Future<void> stop() async {
    _running = false;

    _readerTimer?.cancel();
    _readerTimer = null;

    _terminal.close();

    await _outputController.close();
    await _errorController.close();
  }
}
