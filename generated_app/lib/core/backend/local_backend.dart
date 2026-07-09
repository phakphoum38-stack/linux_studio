import 'dart:async';

import 'terminal_backend.dart';

class LocalBackend implements TerminalBackend {
  final List<String> _buffer = [];

  final StreamController<String> _outputController =
      StreamController<String>.broadcast();

  final StreamController<String> _errorController =
      StreamController<String>.broadcast();

  bool _running = false;

  @override
  Stream<String> get output => _outputController.stream;

  @override
  Stream<String> get errors => _errorController.stream;

  @override
  Future<void> start() async {
    _running = true;
  }

  @override
  Future<void> write(String data) async {
    if (!_running) {
      return;
    }

    _buffer.add(data);
    _outputController.add(data);
  }

  @override
  String read() {
    if (_buffer.isEmpty) {
      return '';
    }

    final data = _buffer.join();

    _buffer.clear();

    return data;
  }

  @override
  Future<void> resize(
    int cols,
    int rows,
  ) async {
    // Local backend does not support resize.
  }

  @override
  Future<void> stop() async {
    _running = false;

    _buffer.clear();

    await _outputController.close();
    await _errorController.close();
  }
}
